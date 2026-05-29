# Design — Phase 7: Auth OTP Hardening

> **Date:** 2026-05-29
> **Branch:** `002-rebuild-from-zero`
> **Status:** Approved (owner, 2026-05-29)
> **Supersedes:** the "Next iteration" notes in `docs/superpowers/plans/2026-05-29-frontend-phase6-password-auth.md`

## Goal

Three owner-requested hardening changes on top of the completed phone+password auth (Phase 6):

1. **Split the forgot-password flow into three separate screens:** phone → OTP (own screen) → (only after the code verifies) new-password (own screen).
2. **OTP codes expire after 2 minutes** — an expired code is rejected by the repository, not just visually.
3. **Resend is gated by code validity** — a new code can only be requested when no still-valid code exists. Applies to **both** signup and reset.

## Resolved decisions (owner, 2026-05-29)

- **Scope:** unify signup and reset under one OTP rule (2-min validity + validity-gated resend). Login is untouched.
- **Cooldown semantics (option A):** resend is allowed only while there is **no currently-valid code**. Because a code is valid for 2 minutes, the effective resend wait is **2 minutes**, not 5. The "5-minute cooldown" from the Phase 6 notes is **superseded** by this — it is replaced by the 2-minute validity window because validity is shorter. Rejection message while a code is still valid: «عندك كود لسه شغّال، استناه يخلص الأول».
- **Reset two-step verify:** the OTP screen verifies the code and receives a **short-lived token (5 min)**; the new-password screen uses that token. This decouples password entry from the code's 2-minute validity, so a user who takes time typing the new password is not blocked by an expired code.

## Architecture

### 1. Repository API (`AuthRepository` + `MockAuthRepository`)

**Injectable clock.** `MockAuthRepository` gains a `DateTime Function() now` constructor param defaulting to `DateTime.now`. All expiry/validity logic reads `now()`. Tests inject a mutable clock to advance time without real waits.

**Per-phone OTP tracking.** The repo tracks, per phone, the last issued code's `issuedAt` (and the code value — still the magic `1234` in the mock). Constant: `codeValidity = Duration(minutes: 2)`. A code is valid iff `now() - issuedAt < codeValidity`.

**Reset becomes three calls** (replacing `confirmReset`):

| Method | Behaviour | Throws |
|---|---|---|
| `startReset({phone})` *(kept)* | account-exists check; **rejects if a valid code already exists**; otherwise issues a code (stamps `issuedAt`). | `AccountNotFoundException`, `OtpResendTooSoonException` |
| `verifyResetCode({phone, code})` → `String token` *(new)* | validates code is correct **and** not expired; returns a short-lived reset token (valid 5 min, tied to phone). | `OtpWrongCodeException`, `OtpExpiredException` |
| `setNewPassword({phone, token, newPassword})` → `Profile` *(new)* | validates the token (correct + not expired) and sets the new password; returns the profile (for sign-in). | `ResetTokenInvalidException` |

`confirmReset` is **removed** (no remaining callers after the split).

**Signup tightening:**
- `startSignup({phone})`: free-phone check **and** rejects if a valid code already exists; otherwise issues a code. Throws `PhoneAlreadyRegisteredException` or `OtpResendTooSoonException`.
- `confirmSignup({name, phone, password, code})`: now also rejects an **expired** code (`OtpExpiredException`) in addition to a wrong code (`OtpWrongCodeException`).

**New exceptions** (added to `auth_exceptions.dart`, all extend the sealed `AuthException`):
- `OtpExpiredException` — «الكود خلصت صلاحيته، اطلب كود جديد».
- `OtpResendTooSoonException` — «عندك كود لسه شغّال، استناه يخلص الأول».
- `ResetTokenInvalidException` — «انتهت الجلسة، ابدأ من أول رقم الموبايل».

### 2. Reset flow — three screens

Independent screens; state travels via go_router `extra`. Each screen owns a small cubit constructed from `getIt<AuthRepository>()`.

| Route | Screen | Repo call | On success |
|---|---|---|---|
| `/auth/forgot` | phone entry | `startReset` | `push('/auth/forgot/otp', extra:{phone, from})` |
| `/auth/forgot/otp` | OTP only | `verifyResetCode` → token | `push('/auth/forgot/reset', extra:{phone, token, from})` |
| `/auth/forgot/reset` | new password only | `setNewPassword` | `signInAndReturn(context, profile, from)` |

- **Phone screen** keeps the existing phone-entry UI; on success navigates forward instead of revealing inline fields.
- **OTP screen** uses `OtpCodeField` (resend → `startReset` again, validity-gated). On a verified code, navigates forward carrying `{phone, token, from}`. Expired/wrong code shows the field error.
- **New-password screen** shows only the password field; `setNewPassword(phone, token, newPassword)` → sign in. An invalid/expired token routes the user back to `/auth/forgot` with the token-invalid message.

Cubit shape: three lean cubits (`ResetPhoneCubit`, `ResetOtpCubit`, `ResetPasswordCubit`) — one per screen, each with a tiny sealed state union — chosen over one shared cubit because the screens are separate routes and a per-screen cubit keeps each unit independently testable. The old single `ResetCubit`/`ResetState` are replaced. (Final naming/splitting confirmed in the implementation plan; the principle — one focused cubit per screen — is fixed.)

### 3. Signup flow — unchanged shape, new timing

Signup stays a **single screen** (form → inline OTP) because the password is already captured in the form; no third screen is needed. It only adopts the new OTP timing: `OtpCodeField.startSeconds = 120`, resend hits the tightened `startSignup`, and `confirmSignup` may now surface `OtpExpiredException`.

### 4. `OtpCodeField`

- `startSeconds` default raised so both flows pass **120**. When the countdown hits 0 the code is expired and the resend button enables — this UI gate mirrors the repo rule (option A). Resend re-issues and restarts the 120s countdown.
- No structural change to the local-countdown pattern (Timer + setState, never rebuilds the parent) settled in Phase 5.

### 5. Router

Add two routes — `/auth/forgot/otp` and `/auth/forgot/reset` — each reading `phone`/`token`/`from` from `extra`. `/auth/forgot` stays but its screen now navigates forward.

## Error handling

Every repo failure is an `AuthException` subtype with an Egyptian-Arabic message; cubits map `AuthException` → field/snackbar error and `NoConnectionException` → «مفيش اتصال بالإنترنت». An invalid reset token sends the user back to the start of the flow rather than dead-ending.

## Testing (TDD)

- **Repo (clock-injected):** valid code verifies; expired code (advance clock > 2 min) → `OtpExpiredException`; resend while a valid code exists → `OtpResendTooSoonException`; resend after expiry → succeeds; `verifyResetCode` returns a token that `setNewPassword` accepts; expired/forged token → `ResetTokenInvalidException`; signup expired-code path.
- **Cubits:** one bloc_test per reset cubit (phone/otp/password) covering success + each error; signup cubit gains an expired-code case. Login cubit unchanged.
- **Screens:** widget test per reset screen using the existing `getIt` + `SessionCubit` pattern; assert the forward navigation gates on a correct/non-expired code and that an invalid token bounces back.
- **Gate:** `flutter analyze` clean + full suite green (existing 107 + new).

## Out of scope (deferred)

Real Supabase auth + password hashing, email option, session persistence, WhatsApp-OTP, AuthGate route protection. Per-phone tracking and tokens are in-memory in the mock and reset on app restart.
