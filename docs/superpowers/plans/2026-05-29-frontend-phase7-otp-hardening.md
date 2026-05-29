# Phase 7: Auth OTP Hardening — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Harden the phone+password auth: split the forgot-password flow into three separate screens (phone → OTP → new password), expire OTP codes after 2 minutes, and gate resend by code validity — for both signup and reset.

**Architecture:** `MockAuthRepository` gains an injectable clock and per-phone OTP issue-time tracking; reset is split into `startReset` → `verifyResetCode` (returns a short-lived token) → `setNewPassword`. Three lean per-screen cubits drive three reset routes. Signup keeps its single screen but adopts the same OTP timing. The shared `OtpCodeField` countdown rises to 120s.

**Tech Stack:** Flutter, flutter_bloc (Cubit), go_router, get_it, freezed (no json_serializable / no `.g.dart`). Tests: flutter_test, bloc_test, mocktail.

**Spec:** `docs/superpowers/specs/2026-05-29-auth-otp-hardening-design.md`

**Conventions:** freezed `sealed` for state unions; codegen `dart run build_runner build --force-jit --delete-conflicting-outputs`; theme tokens only (`AppColors`/`AppSpacing`/`AppTextStyles`), Cairo, RTL, Egyptian-Arabic tone; **all commands run from `D:\programing\wasalni\apps\mobile`**.

**Key constants (mock):** magic OTP code = `1234`; `codeValidity = 2 min`; reset `tokenValidity = 5 min`; demo account `+201000000000 / 123456 / أحمد`; password min length 6.

---

## File Structure

**Repository layer**
- `lib/features/auth/auth_exceptions.dart` — *modify*: add `OtpExpiredException`, `OtpResendTooSoonException`, `ResetTokenInvalidException`.
- `lib/data/repositories/auth_repository.dart` — *modify*: replace `confirmReset` with `verifyResetCode` + `setNewPassword`.
- `lib/data/repositories/mock/mock_auth_repository.dart` — *rewrite*: injectable clock, per-phone code tracking, token store.
- `test/data/repositories/mock_auth_repository_test.dart` — *rewrite*: expiry/resend/token coverage.

**Reset cubits (one per screen)** — under `lib/features/auth/bloc/`
- `reset_phone_cubit.dart` + `reset_phone_state.dart`
- `reset_otp_cubit.dart` + `reset_otp_state.dart`
- `reset_password_cubit.dart` + `reset_password_state.dart`
- *Delete*: `reset_cubit.dart`, `reset_state.dart` (+ `reset_state.freezed.dart`).

**Reset screens** — under `lib/features/auth/view/`
- `reset_phone_screen.dart`, `reset_otp_screen.dart`, `reset_password_screen.dart`
- *Delete*: `forgot_password_screen.dart`.

**Shared / wiring**
- `lib/features/auth/view/otp_code_field.dart` — *modify*: `startSeconds` default 30 → 120.
- `lib/app/router.dart` — *modify*: swap forgot import + route for the three new reset routes.

**Tests** — under `test/features/auth/`
- *Delete*: `reset_cubit_test.dart`, `forgot_password_screen_test.dart`.
- *Create*: `reset_phone_cubit_test.dart`, `reset_otp_cubit_test.dart`, `reset_password_cubit_test.dart`, `reset_phone_screen_test.dart`, `reset_otp_screen_test.dart`, `reset_password_screen_test.dart`.

---

### Task 1: Repository — clock, OTP expiry, split reset

**Files:**
- Modify: `apps/mobile/lib/features/auth/auth_exceptions.dart`
- Modify: `apps/mobile/lib/data/repositories/auth_repository.dart`
- Rewrite: `apps/mobile/lib/data/repositories/mock/mock_auth_repository.dart`
- Rewrite: `apps/mobile/test/data/repositories/mock_auth_repository_test.dart`
- Delete: `lib/features/auth/bloc/reset_cubit.dart`, `lib/features/auth/bloc/reset_state.dart`, `lib/features/auth/bloc/reset_state.freezed.dart`, `lib/features/auth/view/forgot_password_screen.dart`, `test/features/auth/reset_cubit_test.dart`, `test/features/auth/forgot_password_screen_test.dart`
- Modify: `apps/mobile/lib/app/router.dart` (remove forgot import + `/auth/forgot` route — re-added in Task 2)

- [ ] **Step 1: Write the failing repo test**

Replace `apps/mobile/test/data/repositories/mock_auth_repository_test.dart` with:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';

void main() {
  late DateTime clock;
  late MockAuthRepository repo;

  setUp(() {
    clock = DateTime(2026, 1, 1, 12, 0, 0);
    repo = MockAuthRepository(latency: Duration.zero, now: () => clock);
  });

  group('login', () {
    test('seeded demo account logs in', () async {
      final p = await repo.login(phone: '+201000000000', password: '123456');
      expect(p.displayName, 'أحمد');
    });
    test('wrong password throws WrongCredentialsException', () {
      expect(() => repo.login(phone: '+201000000000', password: 'nope'),
          throwsA(isA<WrongCredentialsException>()));
    });
  });

  group('signup', () {
    test('startSignup on a free phone issues a code', () async {
      await expectLater(repo.startSignup(phone: '+201222222222'), completes);
    });
    test('startSignup on a taken phone throws PhoneAlreadyRegisteredException', () {
      expect(() => repo.startSignup(phone: '+201000000000'),
          throwsA(isA<PhoneAlreadyRegisteredException>()));
    });
    test('resend while code still valid throws OtpResendTooSoonException', () async {
      await repo.startSignup(phone: '+201222222222');
      expect(() => repo.startSignup(phone: '+201222222222'),
          throwsA(isA<OtpResendTooSoonException>()));
    });
    test('resend after code expires succeeds', () async {
      await repo.startSignup(phone: '+201222222222');
      clock = clock.add(const Duration(minutes: 3));
      await expectLater(repo.startSignup(phone: '+201222222222'), completes);
    });
    test('confirmSignup with 1234 creates an account that logs in', () async {
      await repo.startSignup(phone: '+201222222222');
      final p = await repo.confirmSignup(
          name: 'سعيد', phone: '+201222222222', password: 'secret1', code: '1234');
      expect(p.displayName, 'سعيد');
      final again = await repo.login(phone: '+201222222222', password: 'secret1');
      expect(again.phone, '+201222222222');
    });
    test('confirmSignup with wrong code throws OtpWrongCodeException', () async {
      await repo.startSignup(phone: '+201222222222');
      expect(
          () => repo.confirmSignup(
              name: 'x', phone: '+201222222222', password: 'secret1', code: '0000'),
          throwsA(isA<OtpWrongCodeException>()));
    });
    test('confirmSignup after code expires throws OtpExpiredException', () async {
      await repo.startSignup(phone: '+201222222222');
      clock = clock.add(const Duration(minutes: 3));
      expect(
          () => repo.confirmSignup(
              name: 'x', phone: '+201222222222', password: 'secret1', code: '1234'),
          throwsA(isA<OtpExpiredException>()));
    });
  });

  group('reset', () {
    test('startReset on an existing account issues a code', () async {
      await expectLater(repo.startReset(phone: '+201000000000'), completes);
    });
    test('startReset on unknown phone throws AccountNotFoundException', () {
      expect(() => repo.startReset(phone: '+201999999999'),
          throwsA(isA<AccountNotFoundException>()));
    });
    test('resend while code still valid throws OtpResendTooSoonException', () async {
      await repo.startReset(phone: '+201000000000');
      expect(() => repo.startReset(phone: '+201000000000'),
          throwsA(isA<OtpResendTooSoonException>()));
    });
    test('verifyResetCode returns a token; setNewPassword then logs in', () async {
      await repo.startReset(phone: '+201000000000');
      final token = await repo.verifyResetCode(phone: '+201000000000', code: '1234');
      expect(token, isNotEmpty);
      await repo.setNewPassword(
          phone: '+201000000000', token: token, newPassword: 'brandnew');
      final p = await repo.login(phone: '+201000000000', password: 'brandnew');
      expect(p.phone, '+201000000000');
    });
    test('verifyResetCode with wrong code throws OtpWrongCodeException', () async {
      await repo.startReset(phone: '+201000000000');
      expect(() => repo.verifyResetCode(phone: '+201000000000', code: '0000'),
          throwsA(isA<OtpWrongCodeException>()));
    });
    test('verifyResetCode after expiry throws OtpExpiredException', () async {
      await repo.startReset(phone: '+201000000000');
      clock = clock.add(const Duration(minutes: 3));
      expect(() => repo.verifyResetCode(phone: '+201000000000', code: '1234'),
          throwsA(isA<OtpExpiredException>()));
    });
    test('setNewPassword with a bad token throws ResetTokenInvalidException', () {
      expect(
          () => repo.setNewPassword(
              phone: '+201000000000', token: 'nope', newPassword: 'x'),
          throwsA(isA<ResetTokenInvalidException>()));
    });
    test('setNewPassword after token expires throws ResetTokenInvalidException', () async {
      await repo.startReset(phone: '+201000000000');
      final token = await repo.verifyResetCode(phone: '+201000000000', code: '1234');
      clock = clock.add(const Duration(minutes: 6));
      expect(
          () => repo.setNewPassword(
              phone: '+201000000000', token: token, newPassword: 'x'),
          throwsA(isA<ResetTokenInvalidException>()));
    });
  });
}
```

- [ ] **Step 2: Run → fails to compile** (new methods/exceptions/`now` param don't exist yet).

Run: `flutter test test/data/repositories/mock_auth_repository_test.dart`
Expected: compile errors (`verifyResetCode`, `setNewPassword`, `OtpExpiredException`, etc. undefined).

- [ ] **Step 3: Add the new exceptions**

Append to `apps/mobile/lib/features/auth/auth_exceptions.dart` (after `OtpWrongCodeException`):

```dart

/// OTP code is past its 2-minute validity window.
class OtpExpiredException extends AuthException {
  const OtpExpiredException() : super('الكود خلصت صلاحيته، اطلب كود جديد');
}

/// A still-valid code already exists for this phone — resend is blocked.
class OtpResendTooSoonException extends AuthException {
  const OtpResendTooSoonException()
      : super('عندك كود لسه شغّال، استناه يخلص الأول');
}

/// Reset token is unknown, mismatched, or past its 5-minute validity.
class ResetTokenInvalidException extends AuthException {
  const ResetTokenInvalidException()
      : super('انتهت الجلسة، ابدأ من أول رقم الموبايل');
}
```

- [ ] **Step 4: Update the repository interface**

In `apps/mobile/lib/data/repositories/auth_repository.dart`, replace the `confirmReset` declaration (the last method) with:

```dart
  /// Verifies a reset OTP and returns a short-lived reset token.
  /// Throws [OtpWrongCodeException] on a bad code, [OtpExpiredException] if expired.
  Future<String> verifyResetCode({required String phone, required String code});

  /// Sets a new password using a reset token from [verifyResetCode].
  /// Throws [ResetTokenInvalidException] if the token is bad or expired.
  Future<Profile> setNewPassword({
    required String phone,
    required String token,
    required String newPassword,
  });
```

(Delete the old `confirmReset({phone, code, newPassword})` declaration entirely.)

- [ ] **Step 5: Rewrite the mock**

Replace `apps/mobile/lib/data/repositories/mock/mock_auth_repository.dart` with:

```dart
import '../../../features/auth/auth_exceptions.dart';
import '../../models/profile.dart';
import '../auth_repository.dart';

class _Account {
  _Account({required this.profile, required this.password});
  Profile profile;
  String password;
}

/// In-memory accounts. Magic OTP code = 1234. Codes live 2 min; reset tokens
/// live 5 min. Seeded demo account: +201000000000 / 123456 / "أحمد".
/// Real backend (Supabase auth) replaces this.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    this.latency = const Duration(milliseconds: 500),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    _accounts['+201000000000'] = _Account(
      profile: Profile(
        id: 'u_demo',
        phone: '+201000000000',
        displayName: 'أحمد',
        createdAt: DateTime(2026, 1, 1),
      ),
      password: '123456',
    );
  }

  final Duration latency;
  final DateTime Function() _now;
  static const _magicCode = '1234';
  static const codeValidity = Duration(minutes: 2);
  static const tokenValidity = Duration(minutes: 5);

  final Map<String, _Account> _accounts = {};
  final Map<String, DateTime> _codeIssuedAt = {}; // by phone
  final Map<String, ({String phone, DateTime issuedAt})> _resetTokens = {}; // by token
  int _tokenSeq = 0;

  bool _hasValidCode(String phone) {
    final issued = _codeIssuedAt[phone];
    return issued != null && _now().difference(issued) < codeValidity;
  }

  void _issueCode(String phone) => _codeIssuedAt[phone] = _now();

  @override
  Future<Profile> login({required String phone, required String password}) async {
    await Future<void>.delayed(latency);
    final acc = _accounts[phone];
    if (acc == null || acc.password != password) {
      throw const WrongCredentialsException();
    }
    return acc.profile;
  }

  @override
  Future<void> startSignup({required String phone}) async {
    await Future<void>.delayed(latency);
    if (_accounts.containsKey(phone)) {
      throw const PhoneAlreadyRegisteredException();
    }
    if (_hasValidCode(phone)) throw const OtpResendTooSoonException();
    _issueCode(phone);
  }

  @override
  Future<Profile> confirmSignup({
    required String name,
    required String phone,
    required String password,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (!_hasValidCode(phone)) throw const OtpExpiredException();
    if (code != _magicCode) throw const OtpWrongCodeException();
    final profile = Profile(
      id: 'u_${phone.hashCode.abs()}',
      phone: phone,
      displayName: name,
      createdAt: _now(),
    );
    _accounts[phone] = _Account(profile: profile, password: password);
    _codeIssuedAt.remove(phone);
    return profile;
  }

  @override
  Future<void> startReset({required String phone}) async {
    await Future<void>.delayed(latency);
    if (!_accounts.containsKey(phone)) {
      throw const AccountNotFoundException();
    }
    if (_hasValidCode(phone)) throw const OtpResendTooSoonException();
    _issueCode(phone);
  }

  @override
  Future<String> verifyResetCode({
    required String phone,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (!_hasValidCode(phone)) throw const OtpExpiredException();
    if (code != _magicCode) throw const OtpWrongCodeException();
    final token = 'rt_${_tokenSeq++}';
    _resetTokens[token] = (phone: phone, issuedAt: _now());
    _codeIssuedAt.remove(phone); // code consumed
    return token;
  }

  @override
  Future<Profile> setNewPassword({
    required String phone,
    required String token,
    required String newPassword,
  }) async {
    await Future<void>.delayed(latency);
    final t = _resetTokens[token];
    final valid = t != null &&
        t.phone == phone &&
        _now().difference(t.issuedAt) < tokenValidity;
    if (!valid) throw const ResetTokenInvalidException();
    final acc = _accounts[phone];
    if (acc == null) throw const ResetTokenInvalidException();
    acc.password = newPassword;
    _resetTokens.remove(token);
    return acc.profile;
  }
}
```

- [ ] **Step 6: Delete the now-uncompilable old reset files**

```bash
git rm apps/mobile/lib/features/auth/bloc/reset_cubit.dart \
       apps/mobile/lib/features/auth/bloc/reset_state.dart \
       apps/mobile/lib/features/auth/bloc/reset_state.freezed.dart \
       apps/mobile/lib/features/auth/view/forgot_password_screen.dart \
       apps/mobile/test/features/auth/reset_cubit_test.dart \
       apps/mobile/test/features/auth/forgot_password_screen_test.dart
```

- [ ] **Step 7: Remove the dangling forgot import + route from the router**

In `apps/mobile/lib/app/router.dart`:
- Delete the import line: `import '../features/auth/view/forgot_password_screen.dart';`
- Delete the `/auth/forgot` `GoRoute` block (the one returning `ForgotPasswordScreen`).

> Note: between this task and Task 2 the login screen's "نسيت كلمة السر؟" button pushes a route that doesn't exist yet (runtime no-op if tapped); Task 2 restores `/auth/forgot`. No test depends on it meanwhile.

- [ ] **Step 8: Run repo tests → pass; analyze; full suite**

```bash
flutter test test/data/repositories/mock_auth_repository_test.dart
flutter analyze
flutter test
```
Expected: repo tests pass; analyze clean; full suite green (fewer tests — deleted reset tests gone; signup/login still pass because their fresh codes are < 2 min old under the real clock).

- [ ] **Step 9: Commit**

```bash
git add -A
git commit -m "feat(auth): OTP expiry + injectable clock + split reset repo API (verifyResetCode/setNewPassword)"
```

---

### Task 2: ResetPhoneCubit + phone screen + route

**Files:**
- Create: `apps/mobile/lib/features/auth/bloc/reset_phone_state.dart`
- Create: `apps/mobile/lib/features/auth/bloc/reset_phone_cubit.dart`
- Create: `apps/mobile/lib/features/auth/view/reset_phone_screen.dart`
- Modify: `apps/mobile/lib/app/router.dart` (add `/auth/forgot` → `ResetPhoneScreen`)
- Test: `apps/mobile/test/features/auth/reset_phone_cubit_test.dart`
- Test: `apps/mobile/test/features/auth/reset_phone_screen_test.dart`

- [ ] **Step 1: Write the failing cubit test**

`apps/mobile/test/features/auth/reset_phone_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_phone_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_phone_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetPhoneCubit, ResetPhoneState>(
    'success → [submitting, sent]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenAnswer((_) async {});
      return ResetPhoneCubit(repo);
    },
    act: (c) => c.submit('+201000000000'),
    expect: () => [isA<ResetPhoneSubmitting>(), isA<ResetPhoneSent>()],
  );

  blocTest<ResetPhoneCubit, ResetPhoneState>(
    'unknown phone → [submitting, error]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenThrow(const AccountNotFoundException());
      return ResetPhoneCubit(repo);
    },
    act: (c) => c.submit('+201999999999'),
    expect: () => [isA<ResetPhoneSubmitting>(), isA<ResetPhoneError>()],
  );

  blocTest<ResetPhoneCubit, ResetPhoneState>(
    'resend-too-soon → [submitting, error]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenThrow(const OtpResendTooSoonException());
      return ResetPhoneCubit(repo);
    },
    act: (c) => c.submit('+201000000000'),
    expect: () => [isA<ResetPhoneSubmitting>(), isA<ResetPhoneError>()],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/reset_phone_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_phone_state.freezed.dart';

@freezed
sealed class ResetPhoneState with _$ResetPhoneState {
  const factory ResetPhoneState.idle() = ResetPhoneIdle;
  const factory ResetPhoneState.submitting() = ResetPhoneSubmitting;
  const factory ResetPhoneState.error(String message) = ResetPhoneError;
  const factory ResetPhoneState.sent(String phone) = ResetPhoneSent;
}
```

`apps/mobile/lib/features/auth/bloc/reset_phone_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_phone_state.dart';

class ResetPhoneCubit extends Cubit<ResetPhoneState> {
  ResetPhoneCubit(this._repo) : super(const ResetPhoneState.idle());
  final AuthRepository _repo;

  Future<void> submit(String phone) async {
    emit(const ResetPhoneState.submitting());
    try {
      await _repo.startReset(phone: phone);
      emit(ResetPhoneState.sent(phone));
    } on AuthException catch (e) {
      emit(ResetPhoneState.error(e.message ?? 'تعذّر إرسال الكود'));
    } on NoConnectionException {
      emit(const ResetPhoneState.error('مفيش اتصال بالإنترنت'));
    }
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

`flutter test test/features/auth/reset_phone_cubit_test.dart` → PASS.

- [ ] **Step 6: Write the phone screen**

`apps/mobile/lib/features/auth/view/reset_phone_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_phone_cubit.dart';
import '../bloc/reset_phone_state.dart';
import '../phone_validator.dart';

class ResetPhoneScreen extends StatelessWidget {
  const ResetPhoneScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPhoneCubit(getIt<AuthRepository>()),
      child: _Body(from: from),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({this.from});
  final String? from;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _phone = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _e164 => '+20${normalizeDigits(_phone.text).substring(1)}';

  void _submit() {
    setState(() => _localError = null);
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _localError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    context.read<ResetPhoneCubit>().submit(_e164);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نسيت كلمة السر')),
      body: BlocConsumer<ResetPhoneCubit, ResetPhoneState>(
        listener: (context, state) {
          if (state is ResetPhoneSent) {
            context.push('/auth/forgot/otp', extra: <String, String?>{
              'phone': state.phone,
              'from': widget.from,
            });
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('استرجاع كلمة السر', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('اكتب رقم موبايلك وهنبعتلك كود', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                decoration: InputDecoration(
                  labelText: 'رقم الموبايل',
                  hintText: '01xxxxxxxxx',
                  errorText: _localError ??
                      (state is ResetPhoneError ? state.message : null),
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: state is ResetPhoneSubmitting ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(state is ResetPhoneSubmitting ? 'لحظة...' : 'إرسال الكود'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Add the `/auth/forgot` route**

In `apps/mobile/lib/app/router.dart` add the import:
```dart
import '../features/auth/view/reset_phone_screen.dart';
```
And add the route (sibling to `/auth/signup`):
```dart
      GoRoute(
        path: '/auth/forgot',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return ResetPhoneScreen(from: extra?['from']);
        },
      ),
```

- [ ] **Step 8: Write the phone screen widget test**

`apps/mobile/test/features/auth/reset_phone_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/view/reset_phone_screen.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
  });
  tearDown(() async => getIt.reset());

  GoRouter makeRouter() => GoRouter(
        initialLocation: '/auth/forgot',
        routes: [
          GoRoute(
              path: '/auth/forgot',
              builder: (c, s) => const ResetPhoneScreen()),
          GoRoute(
              path: '/auth/forgot/otp',
              builder: (c, s) => const Scaffold(body: Text('otp stub'))),
        ],
      );

  Widget app() => MaterialApp.router(routerConfig: makeRouter());

  testWidgets('demo phone → navigates to OTP screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '01000000000');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pumpAndSettle();
    expect(find.text('otp stub'), findsOneWidget);
  });

  testWidgets('unknown phone shows account-not-found error', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '01999999999');
    await tester.tap(find.text('إرسال الكود'));
    await tester.pumpAndSettle();
    expect(find.text('مفيش حساب على الرقم ده'), findsOneWidget);
    expect(find.text('otp stub'), findsNothing);
  });
}
```

- [ ] **Step 9: analyze + full suite + commit**

```bash
flutter analyze && flutter test
git add apps/mobile/lib/features/auth/bloc/reset_phone_cubit.dart apps/mobile/lib/features/auth/bloc/reset_phone_state.dart apps/mobile/lib/features/auth/bloc/reset_phone_state.freezed.dart apps/mobile/lib/features/auth/view/reset_phone_screen.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/reset_phone_cubit_test.dart apps/mobile/test/features/auth/reset_phone_screen_test.dart
git commit -m "feat(auth): reset step 1 — phone screen (ResetPhoneCubit) at /auth/forgot"
```

---

### Task 3: ResetOtpCubit + OTP screen + route

**Files:**
- Create: `apps/mobile/lib/features/auth/bloc/reset_otp_state.dart`
- Create: `apps/mobile/lib/features/auth/bloc/reset_otp_cubit.dart`
- Create: `apps/mobile/lib/features/auth/view/reset_otp_screen.dart`
- Modify: `apps/mobile/lib/app/router.dart` (add `/auth/forgot/otp`)
- Test: `apps/mobile/test/features/auth/reset_otp_cubit_test.dart`
- Test: `apps/mobile/test/features/auth/reset_otp_screen_test.dart`

- [ ] **Step 1: Write the failing cubit test**

`apps/mobile/test/features/auth/reset_otp_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_otp_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_otp_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetOtpCubit, ResetOtpState>(
    'verify success → [verifying, verified]',
    build: () {
      when(() => repo.verifyResetCode(
              phone: any(named: 'phone'), code: any(named: 'code')))
          .thenAnswer((_) async => 'rt_0');
      return ResetOtpCubit(repo, '+201000000000');
    },
    act: (c) => c.verify('1234'),
    expect: () => [
      isA<ResetOtpVerifying>(),
      isA<ResetOtpVerified>().having((s) => s.token, 'token', 'rt_0'),
    ],
  );

  blocTest<ResetOtpCubit, ResetOtpState>(
    'wrong code → [verifying, error]',
    build: () {
      when(() => repo.verifyResetCode(
              phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return ResetOtpCubit(repo, '+201000000000');
    },
    act: (c) => c.verify('0000'),
    expect: () => [isA<ResetOtpVerifying>(), isA<ResetOtpError>()],
  );

  blocTest<ResetOtpCubit, ResetOtpState>(
    'expired code → [verifying, error]',
    build: () {
      when(() => repo.verifyResetCode(
              phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpExpiredException());
      return ResetOtpCubit(repo, '+201000000000');
    },
    act: (c) => c.verify('1234'),
    expect: () => [isA<ResetOtpVerifying>(), isA<ResetOtpError>()],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/reset_otp_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_otp_state.freezed.dart';

@freezed
sealed class ResetOtpState with _$ResetOtpState {
  const factory ResetOtpState.idle() = ResetOtpIdle;
  const factory ResetOtpState.verifying() = ResetOtpVerifying;
  const factory ResetOtpState.error(String message) = ResetOtpError;
  const factory ResetOtpState.verified(String token) = ResetOtpVerified;
}
```

`apps/mobile/lib/features/auth/bloc/reset_otp_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_otp_state.dart';

class ResetOtpCubit extends Cubit<ResetOtpState> {
  ResetOtpCubit(this._repo, this._phone) : super(const ResetOtpState.idle());
  final AuthRepository _repo;
  final String _phone;

  Future<void> verify(String code) async {
    emit(const ResetOtpState.verifying());
    try {
      final token = await _repo.verifyResetCode(phone: _phone, code: code);
      emit(ResetOtpState.verified(token));
    } on AuthException catch (e) {
      emit(ResetOtpState.error(e.message ?? 'الكود غلط'));
    } on NoConnectionException {
      emit(const ResetOtpState.error('مفيش اتصال بالإنترنت'));
    }
  }

  Future<void> resend() async {
    try {
      await _repo.startReset(phone: _phone);
    } catch (_) {/* best-effort: allowed only after the code expires */}
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

- [ ] **Step 6: Write the OTP screen**

`apps/mobile/lib/features/auth/view/reset_otp_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_otp_cubit.dart';
import '../bloc/reset_otp_state.dart';
import 'otp_code_field.dart';

class ResetOtpScreen extends StatelessWidget {
  const ResetOtpScreen({super.key, required this.phone, this.from});
  final String phone;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetOtpCubit(getIt<AuthRepository>(), phone),
      child: _Body(phone: phone, from: from),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.phone, this.from});
  final String phone;
  final String? from;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الكود')),
      body: BlocConsumer<ResetOtpCubit, ResetOtpState>(
        listener: (context, state) {
          if (state is ResetOtpVerified) {
            context.push('/auth/forgot/reset', extra: <String, String?>{
              'phone': widget.phone,
              'token': state.token,
              'from': widget.from,
            });
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('أكّد رقمك', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('بعتنا كود على ${widget.phone}  (للتجربة: ١٢٣٤)',
                  style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.lg),
              OtpCodeField(
                controller: _code,
                errorText: state is ResetOtpError ? state.message : null,
                onResend: () => context.read<ResetOtpCubit>().resend(),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: state is ResetOtpVerifying
                    ? null
                    : () => context.read<ResetOtpCubit>().verify(_code.text),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(state is ResetOtpVerifying ? 'بنأكد...' : 'تأكيد الكود'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Add the `/auth/forgot/otp` route**

`router.dart`:
```dart
import '../features/auth/view/reset_otp_screen.dart';
```
```dart
      GoRoute(
        path: '/auth/forgot/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return ResetOtpScreen(phone: extra?['phone'] ?? '', from: extra?['from']);
        },
      ),
```

- [ ] **Step 8: Write the OTP screen widget test**

`apps/mobile/test/features/auth/reset_otp_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/view/reset_otp_screen.dart';

void main() {
  const phone = '+201000000000';

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
    // A code must already exist for verifyResetCode to accept it.
    await getIt<AuthRepository>().startReset(phone: phone);
  });
  tearDown(() async => getIt.reset());

  GoRouter makeRouter() => GoRouter(
        initialLocation: '/auth/forgot/otp',
        routes: [
          GoRoute(
              path: '/auth/forgot/otp',
              builder: (c, s) => const ResetOtpScreen(phone: phone)),
          GoRoute(
              path: '/auth/forgot/reset',
              builder: (c, s) => const Scaffold(body: Text('reset stub'))),
        ],
      );

  Widget app() => MaterialApp.router(routerConfig: makeRouter());

  testWidgets('correct code → navigates to new-password screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '1234');
    await tester.tap(find.text('تأكيد الكود'));
    await tester.pumpAndSettle();
    expect(find.text('reset stub'), findsOneWidget);
  });

  testWidgets('wrong code shows the error and stays', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '0000');
    await tester.tap(find.text('تأكيد الكود'));
    await tester.pumpAndSettle();
    expect(find.text('الكود غلط، جرّب تاني'), findsOneWidget);
    expect(find.text('reset stub'), findsNothing);
  });
}
```

- [ ] **Step 9: analyze + full suite + commit**

```bash
flutter analyze && flutter test
git add apps/mobile/lib/features/auth/bloc/reset_otp_cubit.dart apps/mobile/lib/features/auth/bloc/reset_otp_state.dart apps/mobile/lib/features/auth/bloc/reset_otp_state.freezed.dart apps/mobile/lib/features/auth/view/reset_otp_screen.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/reset_otp_cubit_test.dart apps/mobile/test/features/auth/reset_otp_screen_test.dart
git commit -m "feat(auth): reset step 2 — OTP screen (ResetOtpCubit) → short-lived token"
```

---

### Task 4: ResetPasswordCubit + new-password screen + route

**Files:**
- Create: `apps/mobile/lib/features/auth/bloc/reset_password_state.dart`
- Create: `apps/mobile/lib/features/auth/bloc/reset_password_cubit.dart`
- Create: `apps/mobile/lib/features/auth/view/reset_password_screen.dart`
- Modify: `apps/mobile/lib/app/router.dart` (add `/auth/forgot/reset`)
- Test: `apps/mobile/test/features/auth/reset_password_cubit_test.dart`
- Test: `apps/mobile/test/features/auth/reset_password_screen_test.dart`

- [ ] **Step 1: Write the failing cubit test**

`apps/mobile/test/features/auth/reset_password_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_password_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_password_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(
    id: 'u1', phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'success → [submitting, success]',
    build: () {
      when(() => repo.setNewPassword(
              phone: any(named: 'phone'),
              token: any(named: 'token'),
              newPassword: any(named: 'newPassword')))
          .thenAnswer((_) async => _p());
      return ResetPasswordCubit(repo, '+201000000000', 'rt_0');
    },
    act: (c) => c.submit('brandnew'),
    expect: () => [isA<ResetPasswordSubmitting>(), isA<ResetPasswordSuccess>()],
  );

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'invalid token → [submitting, tokenInvalid]',
    build: () {
      when(() => repo.setNewPassword(
              phone: any(named: 'phone'),
              token: any(named: 'token'),
              newPassword: any(named: 'newPassword')))
          .thenThrow(const ResetTokenInvalidException());
      return ResetPasswordCubit(repo, '+201000000000', 'bogus');
    },
    act: (c) => c.submit('brandnew'),
    expect: () =>
        [isA<ResetPasswordSubmitting>(), isA<ResetPasswordTokenInvalid>()],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/reset_password_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'reset_password_state.freezed.dart';

@freezed
sealed class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.idle() = ResetPasswordIdle;
  const factory ResetPasswordState.submitting() = ResetPasswordSubmitting;
  const factory ResetPasswordState.error(String message) = ResetPasswordError;
  const factory ResetPasswordState.tokenInvalid(String message) =
      ResetPasswordTokenInvalid;
  const factory ResetPasswordState.success(Profile profile) = ResetPasswordSuccess;
}
```

`apps/mobile/lib/features/auth/bloc/reset_password_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._repo, this._phone, this._token)
      : super(const ResetPasswordState.idle());
  final AuthRepository _repo;
  final String _phone;
  final String _token;

  Future<void> submit(String newPassword) async {
    emit(const ResetPasswordState.submitting());
    try {
      final profile = await _repo.setNewPassword(
          phone: _phone, token: _token, newPassword: newPassword);
      emit(ResetPasswordState.success(profile));
    } on ResetTokenInvalidException catch (e) {
      emit(ResetPasswordState.tokenInvalid(e.message ?? 'انتهت الجلسة'));
    } on AuthException catch (e) {
      emit(ResetPasswordState.error(e.message ?? 'تعذّر تغيير كلمة السر'));
    } on NoConnectionException {
      emit(const ResetPasswordState.error('مفيش اتصال بالإنترنت'));
    }
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

- [ ] **Step 6: Write the new-password screen**

`apps/mobile/lib/features/auth/view/reset_password_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_password_cubit.dart';
import '../bloc/reset_password_state.dart';
import 'session_sign_in.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.phone,
    required this.token,
    this.from,
  });
  final String phone;
  final String token;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(getIt<AuthRepository>(), phone, token),
      child: _Body(from: from),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({this.from});
  final String? from;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _password = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _localError = null);
    if (_password.text.length < 6) {
      setState(() => _localError = 'كلمة السر لازم 6 حروف على الأقل');
      return;
    }
    context.read<ResetPasswordCubit>().submit(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('كلمة السر الجديدة')),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          } else if (state is ResetPasswordTokenInvalid) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.go('/auth/forgot');
          } else if (state is ResetPasswordError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('اعمل كلمة سر جديدة', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة السر الجديدة (6 حروف على الأقل)',
                  errorText: _localError,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: state is ResetPasswordSubmitting ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(state is ResetPasswordSubmitting
                    ? 'بنأكد...'
                    : 'تأكيد كلمة السر الجديدة'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Add the `/auth/forgot/reset` route**

`router.dart`:
```dart
import '../features/auth/view/reset_password_screen.dart';
```
```dart
      GoRoute(
        path: '/auth/forgot/reset',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return ResetPasswordScreen(
            phone: extra?['phone'] ?? '',
            token: extra?['token'] ?? '',
            from: extra?['from'],
          );
        },
      ),
```

- [ ] **Step 8: Write the new-password screen widget test**

`apps/mobile/test/features/auth/reset_password_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/view/reset_password_screen.dart';

void main() {
  const phone = '+201000000000';
  late SessionCubit session;
  late String token;

  setUp(() async {
    await getIt.reset();
    getIt.registerLazySingleton<AuthRepository>(
        () => MockAuthRepository(latency: Duration.zero));
    final repo = getIt<AuthRepository>();
    await repo.startReset(phone: phone);
    token = await repo.verifyResetCode(phone: phone, code: '1234');
    session = SessionCubit();
  });
  tearDown(() async {
    await getIt.reset();
    session.close();
  });

  GoRouter makeRouter(String tok) => GoRouter(
        initialLocation: '/auth/forgot/reset',
        routes: [
          GoRoute(
              path: '/auth/forgot/reset',
              builder: (c, s) =>
                  ResetPasswordScreen(phone: phone, token: tok)),
          GoRoute(
              path: '/account',
              builder: (c, s) => const Scaffold(body: Text('account stub'))),
          GoRoute(
              path: '/auth/forgot',
              builder: (c, s) => const Scaffold(body: Text('forgot stub'))),
        ],
      );

  Widget app(String tok) => BlocProvider<SessionCubit>.value(
        value: session,
        child: MaterialApp.router(routerConfig: makeRouter(tok)),
      );

  testWidgets('valid token + new password → session authenticated', (tester) async {
    await tester.pumpWidget(app(token));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'brandnew');
    await tester.tap(find.text('تأكيد كلمة السر الجديدة'));
    await tester.pumpAndSettle();
    expect(session.isAuthenticated, isTrue);
    expect(find.text('account stub'), findsOneWidget);
  });

  testWidgets('invalid token bounces back to /auth/forgot', (tester) async {
    await tester.pumpWidget(app('bogus'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'brandnew');
    await tester.tap(find.text('تأكيد كلمة السر الجديدة'));
    await tester.pumpAndSettle();
    expect(find.text('forgot stub'), findsOneWidget);
    expect(session.isAuthenticated, isFalse);
  });
}
```

- [ ] **Step 9: analyze + full suite + commit**

```bash
flutter analyze && flutter test
git add apps/mobile/lib/features/auth/bloc/reset_password_cubit.dart apps/mobile/lib/features/auth/bloc/reset_password_state.dart apps/mobile/lib/features/auth/bloc/reset_password_state.freezed.dart apps/mobile/lib/features/auth/view/reset_password_screen.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/reset_password_cubit_test.dart apps/mobile/test/features/auth/reset_password_screen_test.dart
git commit -m "feat(auth): reset step 3 — new-password screen (token → setNewPassword) + sign-in"
```

---

### Task 5: Raise OTP countdown to 120s (signup + reset)

**Files:**
- Modify: `apps/mobile/lib/features/auth/view/otp_code_field.dart`

**Context:** The signup screen and the reset OTP screen both use `OtpCodeField` without passing `startSeconds`, so changing the default propagates to both. The 120s countdown mirrors the 2-minute repo validity: when it hits 0 the code is expired and resend re-enables — matching option A (resend only after the code expires). Signup already surfaces `OtpExpiredException` through its existing `SignupCodeSent(error:)` path (it extends `AuthException`), so no cubit change is needed.

- [ ] **Step 1: Change the default**

In `apps/mobile/lib/features/auth/view/otp_code_field.dart`, change:
```dart
    this.startSeconds = 30,
```
to:
```dart
    this.startSeconds = 120,
```

- [ ] **Step 2: analyze + full suite**

```bash
flutter analyze && flutter test
```
Expected: clean + all green (signup and reset-otp screen tests still pass; their `pumpAndSettle` fast-forwards the 120s countdown in simulated time, which self-cancels at 0).

- [ ] **Step 3: Commit**

```bash
git add apps/mobile/lib/features/auth/view/otp_code_field.dart
git commit -m "feat(auth): OTP countdown 120s to match 2-minute code validity"
```

---

### Task 6: Final wiring, cleanup, and review

**Files:**
- Verify: `apps/mobile/lib/app/router.dart` (three reset routes present; no forgot-screen import)
- Verify: `apps/mobile/lib/features/auth/view/login_screen.dart` ("نسيت كلمة السر؟" pushes `/auth/forgot`, now → `ResetPhoneScreen`)
- Create/Update: `docs/superpowers/plans/PROGRESS-phase7-otp-hardening.md`

- [ ] **Step 1: Confirm no dangling references**

```bash
git grep -nE "ResetCubit|ResetState|confirmReset|ForgotPasswordScreen|forgot_password_screen" -- apps/mobile/lib apps/mobile/test || echo "clean"
```
Expected: `clean` (every hit should be gone). Fix any straggler.

- [ ] **Step 2: Confirm the three reset routes + login button**

Open `router.dart`: `/auth/forgot` → `ResetPhoneScreen`, `/auth/forgot/otp` → `ResetOtpScreen`, `/auth/forgot/reset` → `ResetPasswordScreen`. Open `login_screen.dart`: the "نسيت كلمة السر؟" button still does `context.push('/auth/forgot', extra: {'from': ...})` — now lands on `ResetPhoneScreen`.

- [ ] **Step 3: analyze + full suite**

```bash
flutter analyze && flutter test
```
Expected: clean + all green.

- [ ] **Step 4: Final code review**

Dispatch a final code-review subagent over the whole Phase 7 change. Verify:
- Codes expire after 2 min (repo-enforced via injected clock); expired code → `OtpExpiredException`.
- Resend blocked while a valid code exists (`OtpResendTooSoonException`), allowed once expired — for both signup and reset.
- Reset is three separate screens; OTP verify yields a short-lived token; new-password screen uses the token; an invalid/expired token bounces the user back to `/auth/forgot`.
- Signup unchanged in shape; 120s countdown; expiry surfaces in its OTP field.
- Guest cart survives login; redirect-after-login returns to `from`; resend countdown is local (no per-second cubit emits).
- `flutter analyze` clean + all tests pass.

- [ ] **Step 5: Write the PROGRESS doc + commit**

Create `docs/superpowers/plans/PROGRESS-phase7-otp-hardening.md` summarizing tasks (✅), the final test count, the manual web smoke paths (login demo creds; signup new phone + 1234; forgot: demo phone → 1234 → new password across three screens; resend disabled until the 120s countdown ends), and the resolved cooldown semantics (effective resend wait = 2 min validity). Then:

```bash
git add docs/superpowers/plans/PROGRESS-phase7-otp-hardening.md
git commit -m "docs(auth): mark Phase 7 OTP-hardening complete + manual smoke paths"
```

---

## Self-Review

**Spec coverage:**
- Split reset into 3 screens → Tasks 2, 3, 4 (+ routes). ✅
- 2-minute code expiry (repo-enforced) → Task 1 (`_hasValidCode`, `OtpExpiredException`) + tests. ✅
- Validity-gated resend for signup + reset → Task 1 (`OtpResendTooSoonException` in `startSignup`/`startReset`) + tests. ✅
- Short-lived reset token → Task 1 (`verifyResetCode`/`setNewPassword`, `tokenValidity`) + Tasks 3, 4. ✅
- Injectable clock for tests → Task 1 (`now` param). ✅
- 120s countdown → Task 5. ✅
- Cooldown semantics (option A: effective wait = validity) → encoded by gating resend on `_hasValidCode` only; documented in Task 6 PROGRESS. ✅
- Invalid-token bounce-back → Task 4 (`tokenInvalid` state → `context.go('/auth/forgot')`). ✅

**Placeholder scan:** No TBD/TODO; every code step shows complete code. ✅

**Type consistency:** Repo method names (`verifyResetCode`, `setNewPassword`), state classes (`ResetPhoneSent`, `ResetOtpVerified(token)`, `ResetPasswordTokenInvalid`), and exception names (`OtpExpiredException`, `OtpResendTooSoonException`, `ResetTokenInvalidException`) are used identically across interface, mock, cubits, screens, and tests. Constructor shapes match tests: `ResetPhoneCubit(repo)`, `ResetOtpCubit(repo, phone)`, `ResetPasswordCubit(repo, phone, token)`. ✅
