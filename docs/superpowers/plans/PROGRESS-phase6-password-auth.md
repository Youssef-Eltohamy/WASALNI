# تقدّم التنفيذ — Phase 6: تسجيل الدخول بكلمة السر (Password Auth)

> **آخر تحديث:** 2026-05-29 (بداية التنفيذ)
> **الخطة:** `docs/superpowers/plans/2026-05-29-frontend-phase6-password-auth.md`
> **الفرع:** `002-rebuild-from-zero`

## النسبة المئوية

**0 / 5 = 0%**

`[░░░░░░░░░░░░░] 0%`

## الحالة

| # | Task | الحالة | Commit |
|---|---|---|---|
| T1 | AuthRepository + استثناءات + Mock حسابات (rewrite) | ⬜ لسه | — |
| T2 | LoginCubit + شاشة الدخول | ⬜ لسه | — |
| T3 | OtpCodeField مشترك + SignupCubit + شاشة إنشاء حساب | ⬜ لسه | — |
| T4 | ResetCubit + شاشة نسيت كلمة السر | ⬜ لسه | — |
| T5 | routes + AccountScreen + إزالة OTP-login القديم + مراجعة | ⬜ لسه | — |

## القرار
- **تغيير من OTP-only لـ موبايل + كلمة سر** (قرار المستخدم 2026-05-29). الـ OTP بقى للتأكيد عند إنشاء الحساب + إعادة تعيين كلمة السر فقط.
- **mock:** حساب تجريبي مزروع `01000000000 / 123456 / أحمد`، كود OTP السحري `1234`، أقل طول لكلمة السر 6.
- بنحتفظ بـ `SessionCubit` + `session_sign_in` + `phone_validator`؛ بنشيل `PhoneEntryScreen`/`OtpScreen`/`OtpCubit`/`OtpState` القديمة.

## المتبقّي
- تنفيذ الـ 5 tasks subagent-driven + مراجعة نهائية + تحديث النسبة هنا.
