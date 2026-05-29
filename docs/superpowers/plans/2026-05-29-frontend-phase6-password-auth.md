# Password Auth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Replace the OTP-only login with a **phone + password** account system: log in with phone+password; create an account (name + phone + password) confirmed by an OTP code; reset a forgotten password via OTP → new password. OTP is now only a verification step for signup and reset, not the primary login.

**Why (decision 2026-05-29):** The owner chose a classic accounts model over passwordless OTP-login. Login is instant (no SMS wait); OTP is reused to verify a new phone on signup and to authorize a password reset.

**Architecture:** A mock `AuthRepository` backed by an in-memory accounts map (seeded with a demo account) exposes `login / startSignup / confirmSignup / startReset / confirmReset`. Three lean cubits drive the three screens: `LoginCubit`, `SignupCubit` (holds the pending name/phone/password between "send code" and "confirm"), `ResetCubit`. The global `SessionCubit` and the `signInAndReturn` helper are kept. A shared `OtpCodeField` widget (code input + resend countdown) is reused by signup and reset. The old `PhoneEntryScreen`, `OtpScreen`, `OtpCubit`, `OtpState` are retired.

**Tech Stack:** Flutter, flutter_bloc (Cubit), go_router, get_it, freezed (no json_serializable). Tests: flutter_test, bloc_test, mocktail.

**Kept as-is (do NOT rewrite):** `lib/data/models/profile.dart`, `lib/features/auth/bloc/session_cubit.dart` + `session_state.dart`, `lib/features/auth/view/session_sign_in.dart`, `lib/features/auth/phone_validator.dart`, `lib/features/account/view/account_screen.dart` (only its guest button target changes — already `/auth`).

**Conventions:** freezed `sealed` for state unions, `abstract`+`._()` for data with getters; **no json_serializable / no `.g.dart`**; codegen `dart run build_runner build --force-jit --delete-conflicting-outputs`; theme tokens only (`AppColors`/`AppSpacing`/`AppTextStyles`), Cairo, RTL; Egyptian-Arabic friendly tone; all commands from `D:\programing\wasalni\apps\mobile`; mocktail `any()` on custom types needs `registerFallbackValue` in `setUpAll`.

**Mock rules:** magic OTP code = `1234` (anything else → wrong code). Seeded demo account: phone `+201000000000`, password `123456`, name `أحمد`. Password min length = 6.

---

### Task 1: AuthRepository + exceptions + MockAuthRepository (rewrite)

**Files:**
- Rewrite: `apps/mobile/lib/features/auth/auth_exceptions.dart`
- Rewrite: `apps/mobile/lib/data/repositories/auth_repository.dart`
- Rewrite: `apps/mobile/lib/data/repositories/mock/mock_auth_repository.dart`
- Rewrite: `apps/mobile/test/data/repositories/mock_auth_repository_test.dart`

- [ ] **Step 1: Write the failing test**

Replace `apps/mobile/test/data/repositories/mock_auth_repository_test.dart` with:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';

void main() {
  late MockAuthRepository repo;
  setUp(() => repo = MockAuthRepository(latency: Duration.zero));

  group('login', () {
    test('seeded demo account logs in', () async {
      final p = await repo.login(phone: '+201000000000', password: '123456');
      expect(p.phone, '+201000000000');
      expect(p.displayName, 'أحمد');
    });
    test('wrong password throws WrongCredentialsException', () {
      expect(() => repo.login(phone: '+201000000000', password: 'nope'),
          throwsA(isA<WrongCredentialsException>()));
    });
    test('unknown phone throws WrongCredentialsException', () {
      expect(() => repo.login(phone: '+201111111111', password: '123456'),
          throwsA(isA<WrongCredentialsException>()));
    });
  });

  group('signup', () {
    test('startSignup on a free phone completes', () async {
      await expectLater(repo.startSignup(phone: '+201222222222'), completes);
    });
    test('startSignup on a taken phone throws PhoneAlreadyRegisteredException', () {
      expect(() => repo.startSignup(phone: '+201000000000'),
          throwsA(isA<PhoneAlreadyRegisteredException>()));
    });
    test('confirmSignup with 1234 creates the account and it can log in', () async {
      await repo.startSignup(phone: '+201222222222');
      final p = await repo.confirmSignup(
          name: 'سعيد', phone: '+201222222222', password: 'secret1', code: '1234');
      expect(p.displayName, 'سعيد');
      final again = await repo.login(phone: '+201222222222', password: 'secret1');
      expect(again.phone, '+201222222222');
    });
    test('confirmSignup with wrong code throws OtpWrongCodeException', () {
      expect(
          () => repo.confirmSignup(
              name: 'x', phone: '+201222222222', password: 'secret1', code: '0000'),
          throwsA(isA<OtpWrongCodeException>()));
    });
  });

  group('reset', () {
    test('startReset on existing account completes', () async {
      await expectLater(repo.startReset(phone: '+201000000000'), completes);
    });
    test('startReset on unknown phone throws AccountNotFoundException', () {
      expect(() => repo.startReset(phone: '+201999999999'),
          throwsA(isA<AccountNotFoundException>()));
    });
    test('confirmReset sets a new password that then logs in', () async {
      await repo.startReset(phone: '+201000000000');
      await repo.confirmReset(
          phone: '+201000000000', code: '1234', newPassword: 'brandnew');
      final p = await repo.login(phone: '+201000000000', password: 'brandnew');
      expect(p.phone, '+201000000000');
    });
    test('confirmReset with wrong code throws OtpWrongCodeException', () {
      expect(
          () => repo.confirmReset(
              phone: '+201000000000', code: '0000', newPassword: 'brandnew'),
          throwsA(isA<OtpWrongCodeException>()));
    });
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write exceptions**

Replace `apps/mobile/lib/features/auth/auth_exceptions.dart` with:

```dart
/// Auth-flow errors. Cubits map each to a distinct UI message.
sealed class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

/// Login failed — wrong phone or password (don't reveal which).
class WrongCredentialsException extends AuthException {
  const WrongCredentialsException() : super('رقم الموبايل أو كلمة السر غلط');
}

/// Signup on a phone that already has an account.
class PhoneAlreadyRegisteredException extends AuthException {
  const PhoneAlreadyRegisteredException() : super('الرقم ده مسجّل قبل كده، سجّل دخولك');
}

/// Reset requested for a phone with no account.
class AccountNotFoundException extends AuthException {
  const AccountNotFoundException() : super('مفيش حساب على الرقم ده');
}

/// OTP verification code is incorrect.
class OtpWrongCodeException extends AuthException {
  const OtpWrongCodeException() : super('الكود غلط، جرّب تاني');
}
```

- [ ] **Step 4: Write the repository interface**

Replace `apps/mobile/lib/data/repositories/auth_repository.dart` with:

```dart
import '../models/profile.dart';

abstract interface class AuthRepository {
  /// Logs in with phone + password. Throws [WrongCredentialsException] on failure.
  Future<Profile> login({required String phone, required String password});

  /// Starts signup: validates the phone is free and "sends" an OTP.
  /// Throws [PhoneAlreadyRegisteredException] if the phone is taken.
  Future<void> startSignup({required String phone});

  /// Confirms signup with the OTP code, creates the account, returns the profile.
  /// Throws [OtpWrongCodeException] on a bad code.
  Future<Profile> confirmSignup({
    required String name,
    required String phone,
    required String password,
    required String code,
  });

  /// Starts a password reset: validates the account exists and "sends" an OTP.
  /// Throws [AccountNotFoundException] if there is no account.
  Future<void> startReset({required String phone});

  /// Confirms reset with the OTP code, sets the new password, returns the profile.
  /// Throws [OtpWrongCodeException] on a bad code.
  Future<Profile> confirmReset({
    required String phone,
    required String code,
    required String newPassword,
  });
}
```

- [ ] **Step 5: Write the mock**

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

/// In-memory accounts. Magic OTP code = 1234. Seeded demo account:
/// +201000000000 / 123456 / "أحمد". Real backend (Supabase auth) replaces this.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.latency = const Duration(milliseconds: 500)}) {
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
  static const _magicCode = '1234';
  final Map<String, _Account> _accounts = {};

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
  }

  @override
  Future<Profile> confirmSignup({
    required String name,
    required String phone,
    required String password,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (code != _magicCode) throw const OtpWrongCodeException();
    final profile = Profile(
      id: 'u_${phone.hashCode.abs()}',
      phone: phone,
      displayName: name,
      createdAt: DateTime.now(),
    );
    _accounts[phone] = _Account(profile: profile, password: password);
    return profile;
  }

  @override
  Future<void> startReset({required String phone}) async {
    await Future<void>.delayed(latency);
    if (!_accounts.containsKey(phone)) {
      throw const AccountNotFoundException();
    }
  }

  @override
  Future<Profile> confirmReset({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    await Future<void>.delayed(latency);
    if (code != _magicCode) throw const OtpWrongCodeException();
    final acc = _accounts[phone];
    if (acc == null) throw const AccountNotFoundException();
    acc.password = newPassword;
    return acc.profile;
  }
}
```

- [ ] **Step 6: Run → passes; analyze; full suite (NOTE: this breaks the old OtpCubit which depended on `verifyOtp` + removed exceptions).**

Run: `flutter test test/data/repositories/mock_auth_repository_test.dart` (passes).
Then `flutter analyze` — expect COMPILE ERRORS in `lib/features/auth/bloc/otp_cubit.dart` and the old screens/tests that reference the removed `requestOtp`/`verifyOtp`/`OtpExpiredException`/`OtpRateLimitedException`. **That is expected** — those files are retired in Task 5. To keep the tree compiling between tasks, in THIS task also delete the now-uncompilable old files and their tests that block analysis:
- Delete `lib/features/auth/bloc/otp_cubit.dart`, `lib/features/auth/bloc/otp_state.dart` (+ `otp_state.freezed.dart`)
- Delete `lib/features/auth/view/otp_screen.dart`, `lib/features/auth/view/phone_entry_screen.dart`
- Delete tests `test/features/auth/otp_cubit_test.dart`, `test/features/auth/otp_screen_test.dart`, `test/features/auth/phone_entry_screen_test.dart`
- Temporarily remove the `/auth` and `/auth/verify` routes from `lib/app/router.dart` that import those screens (Task 5 re-adds `/auth` → LoginScreen). To keep `/account`'s guest button working meanwhile, point the removed import gap: just delete the two GoRoute blocks and their imports; the AccountScreen's `context.push('/auth', ...)` will simply no-op until Task 2 adds the route — acceptable mid-rework.

After deletions: `flutter analyze` clean, `flutter test` green (fewer tests).

- [ ] **Step 7: Commit**
```bash
git add -A
git commit -m "feat(auth): rewrite AuthRepository for phone+password (login/signup/reset) + retire OTP-login"
```

---

### Task 2: LoginCubit + Login screen

**Files:**
- Create: `apps/mobile/lib/features/auth/bloc/login_cubit.dart`
- Create: `apps/mobile/lib/features/auth/bloc/login_state.dart`
- Create: `apps/mobile/lib/features/auth/view/login_screen.dart`
- Modify: `apps/mobile/lib/app/router.dart` (add `/auth` → LoginScreen)
- Test: `apps/mobile/test/features/auth/login_cubit_test.dart`
- Test: `apps/mobile/test/features/auth/login_screen_test.dart`

- [ ] **Step 1: Write the failing cubit test**

`apps/mobile/test/features/auth/login_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/login_cubit.dart';
import 'package:wasalni/features/auth/bloc/login_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<LoginCubit, LoginState>(
    'success: [submitting, success]',
    build: () {
      when(() => repo.login(phone: any(named: 'phone'), password: any(named: 'password')))
          .thenAnswer((_) async => _p());
      return LoginCubit(repo);
    },
    act: (c) => c.submit(phone: '+201000000000', password: '123456'),
    expect: () => [isA<LoginSubmitting>(), isA<LoginSuccess>()],
  );

  blocTest<LoginCubit, LoginState>(
    'wrong credentials: [submitting, error]',
    build: () {
      when(() => repo.login(phone: any(named: 'phone'), password: any(named: 'password')))
          .thenThrow(const WrongCredentialsException());
      return LoginCubit(repo);
    },
    act: (c) => c.submit(phone: '+201000000000', password: 'nope'),
    expect: () => [isA<LoginSubmitting>(), isA<LoginError>()],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/login_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.submitting() = LoginSubmitting;
  const factory LoginState.error(String message) = LoginError;
  const factory LoginState.success(Profile profile) = LoginSuccess;
}
```

`apps/mobile/lib/features/auth/bloc/login_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(const LoginState.idle());
  final AuthRepository _repo;

  Future<void> submit({required String phone, required String password}) async {
    emit(const LoginState.submitting());
    try {
      final profile = await _repo.login(phone: phone, password: password);
      emit(LoginState.success(profile));
    } on AuthException catch (e) {
      emit(LoginState.error(e.message ?? 'تعذّر تسجيل الدخول'));
    } on NoConnectionException {
      emit(const LoginState.error('مفيش اتصال بالإنترنت'));
    }
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

- [ ] **Step 6: Write the Login screen**

`apps/mobile/lib/features/auth/view/login_screen.dart`:

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
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import '../phone_validator.dart';
import 'session_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(getIt<AuthRepository>()),
      child: _LoginBody(from: from),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody({this.from});
  final String? from;
  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _phoneError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    setState(() => _phoneError = null);
    final e164 = '+20${normalizeDigits(_phone.text).substring(1)}';
    context.read<LoginCubit>().submit(phone: e164, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final busy = state is LoginSubmitting;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('أهلاً بيك تاني', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('سجّل دخولك برقم موبايلك وكلمة السر', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                decoration: InputDecoration(
                  labelText: 'رقم الموبايل',
                  hintText: '01xxxxxxxxx',
                  errorText: _phoneError,
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة السر',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: busy ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(busy ? 'بنسجّل دخولك...' : 'دخول'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        context.push('/auth/forgot', extra: <String, String?>{'from': widget.from}),
                    child: const Text('نسيت كلمة السر؟'),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.push('/auth/signup', extra: <String, String?>{'from': widget.from}),
                    child: const Text('إنشاء حساب'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text('للتجربة: 01000000000 / 123456',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Add the `/auth` route**

In `apps/mobile/lib/app/router.dart` add the import and a sibling route:
```dart
import '../features/auth/view/login_screen.dart';
```
```dart
      GoRoute(
        path: '/auth',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return LoginScreen(from: extra?['from']);
        },
      ),
```

- [ ] **Step 8: Write the login screen widget test**

`apps/mobile/test/features/auth/login_screen_test.dart`: register `MockAuthRepository(latency: Duration.zero)` in `getIt` (`setUp`) + `getIt.reset()` (`tearDown`) — mirror the getIt pattern in `test/features/products/`. Provide a `SessionCubit` via `BlocProvider` and wrap in a minimal `MaterialApp.router` (GoRouter with `/auth` → LoginScreen and stub `/account`, `/auth/signup`, `/auth/forgot`). Assert: (1) entering the demo phone `01000000000` + password `123456` and tapping "دخول" navigates to the `/account` stub (login success). (2) wrong password shows an error SnackBar ("رقم الموبايل أو كلمة السر غلط"). If full routing is heavy, at minimum assert the error-snackbar path and that the demo login drives the session to authenticated (provide the SessionCubit and check `isAuthenticated`). Whatever compiles cleanly and is meaningful.

- [ ] **Step 9: analyze + full suite + commit**
```bash
git add apps/mobile/lib/features/auth/bloc/login_cubit.dart apps/mobile/lib/features/auth/bloc/login_state.dart apps/mobile/lib/features/auth/bloc/login_state.freezed.dart apps/mobile/lib/features/auth/view/login_screen.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/login_cubit_test.dart apps/mobile/test/features/auth/login_screen_test.dart
git commit -m "feat(auth): LoginCubit + phone/password login screen at /auth"
```

---

### Task 3: Shared OtpCodeField + SignupCubit + Signup screen

**Files:**
- Create: `apps/mobile/lib/features/auth/view/otp_code_field.dart`
- Create: `apps/mobile/lib/features/auth/bloc/signup_cubit.dart`
- Create: `apps/mobile/lib/features/auth/bloc/signup_state.dart`
- Create: `apps/mobile/lib/features/auth/view/signup_screen.dart`
- Modify: `apps/mobile/lib/app/router.dart` (add `/auth/signup`)
- Test: `apps/mobile/test/features/auth/signup_cubit_test.dart`
- Test: `apps/mobile/test/features/auth/signup_screen_test.dart`

**Context:** Signup is one screen with two phases. Phase A: name + phone + password form → `submitForm` → `startSignup` (free-phone check) → reveals the OTP field. Phase B: enter the code → `confirmCode` → `confirmSignup` creates the account → success → signin. The resend countdown is a pure-UI concern living inside `OtpCodeField` (its own Timer + setState — the cubit never emits per-second; this is the pattern we settled on after the OTP-rebuild fix).

- [ ] **Step 1: Write the SignupCubit test**

`apps/mobile/test/features/auth/signup_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/signup_cubit.dart';
import 'package:wasalni/features/auth/bloc/signup_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201222222222', displayName: 'سعيد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<SignupCubit, SignupState>(
    'submitForm success → [submitting, codeSent]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone'))).thenAnswer((_) async {});
      return SignupCubit(repo);
    },
    act: (c) => c.submitForm(name: 'سعيد', phone: '+201222222222', password: 'secret1'),
    expect: () => [isA<SignupSubmitting>(), isA<SignupCodeSent>()],
  );

  blocTest<SignupCubit, SignupState>(
    'submitForm on taken phone → [submitting, formError]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone')))
          .thenThrow(const PhoneAlreadyRegisteredException());
      return SignupCubit(repo);
    },
    act: (c) => c.submitForm(name: 'سعيد', phone: '+201000000000', password: 'secret1'),
    expect: () => [isA<SignupSubmitting>(), isA<SignupFormError>()],
  );

  blocTest<SignupCubit, SignupState>(
    'confirmCode success → [..., verifying, success]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmSignup(
              name: any(named: 'name'),
              phone: any(named: 'phone'),
              password: any(named: 'password'),
              code: any(named: 'code')))
          .thenAnswer((_) async => _p());
      return SignupCubit(repo);
    },
    act: (c) async {
      await c.submitForm(name: 'سعيد', phone: '+201222222222', password: 'secret1');
      await c.confirmCode('1234');
    },
    expect: () => [
      isA<SignupSubmitting>(),
      isA<SignupCodeSent>(),
      isA<SignupVerifying>(),
      isA<SignupSuccess>(),
    ],
  );

  blocTest<SignupCubit, SignupState>(
    'confirmCode wrong → [..., verifying, codeSent(error)]',
    build: () {
      when(() => repo.startSignup(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmSignup(
              name: any(named: 'name'),
              phone: any(named: 'phone'),
              password: any(named: 'password'),
              code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return SignupCubit(repo);
    },
    act: (c) async {
      await c.submitForm(name: 'سعيد', phone: '+201222222222', password: 'secret1');
      await c.confirmCode('0000');
    },
    expect: () => [
      isA<SignupSubmitting>(),
      isA<SignupCodeSent>(),
      isA<SignupVerifying>(),
      isA<SignupCodeSent>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/signup_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'signup_state.freezed.dart';

@freezed
sealed class SignupState with _$SignupState {
  const factory SignupState.form() = SignupForm;
  const factory SignupState.submitting() = SignupSubmitting;
  const factory SignupState.formError(String message) = SignupFormError;
  const factory SignupState.codeSent({String? error}) = SignupCodeSent;
  const factory SignupState.verifying() = SignupVerifying;
  const factory SignupState.success(Profile profile) = SignupSuccess;
}
```

`apps/mobile/lib/features/auth/bloc/signup_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._repo) : super(const SignupState.form());
  final AuthRepository _repo;

  String _name = '';
  String _phone = '';
  String _password = '';

  Future<void> submitForm({
    required String name,
    required String phone,
    required String password,
  }) async {
    _name = name;
    _phone = phone;
    _password = password;
    emit(const SignupState.submitting());
    try {
      await _repo.startSignup(phone: phone);
      emit(const SignupState.codeSent());
    } on AuthException catch (e) {
      emit(SignupState.formError(e.message ?? 'تعذّر إنشاء الحساب'));
    } on NoConnectionException {
      emit(const SignupState.formError('مفيش اتصال بالإنترنت'));
    }
  }

  Future<void> resend() async {
    try {
      await _repo.startSignup(phone: _phone);
    } catch (_) {/* keep showing codeSent; resend is best-effort in mock */}
  }

  Future<void> confirmCode(String code) async {
    emit(const SignupState.verifying());
    try {
      final profile = await _repo.confirmSignup(
          name: _name, phone: _phone, password: _password, code: code);
      emit(SignupState.success(profile));
    } on OtpWrongCodeException catch (e) {
      emit(SignupState.codeSent(error: e.message));
    } on AuthException catch (e) {
      emit(SignupState.codeSent(error: e.message));
    } on NoConnectionException {
      emit(const SignupState.codeSent(error: 'مفيش اتصال بالإنترنت'));
    }
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

- [ ] **Step 6: Write the shared OtpCodeField widget**

`apps/mobile/lib/features/auth/view/otp_code_field.dart`:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Reusable OTP entry: a 4-digit code field + a self-contained resend countdown.
/// The countdown is local (Timer + setState) so it never rebuilds the parent.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.controller,
    required this.onResend,
    this.errorText,
    this.startSeconds = 30,
  });

  final TextEditingController controller;
  final VoidCallback onResend;
  final String? errorText;
  final int startSeconds;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late int _seconds = widget.startSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _seconds = widget.startSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _seconds <= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: AppTextStyles.headline,
          decoration: InputDecoration(
            counterText: '',
            hintText: '____',
            errorText: widget.errorText,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: canResend
              ? () {
                  widget.onResend();
                  _start();
                }
              : null,
          child: Text(canResend ? 'ابعت الكود تاني' : 'ابعت تاني بعد ($_seconds)'),
        ),
      ],
    );
  }
}
```

- [ ] **Step 7: Write the Signup screen**

`apps/mobile/lib/features/auth/view/signup_screen.dart`:

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
import '../bloc/signup_cubit.dart';
import '../bloc/signup_state.dart';
import '../phone_validator.dart';
import 'otp_code_field.dart';
import 'session_sign_in.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(getIt<AuthRepository>()),
      child: _SignupBody(from: from),
    );
  }
}

class _SignupBody extends StatefulWidget {
  const _SignupBody({this.from});
  final String? from;
  @override
  State<_SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<_SignupBody> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  String? _formError;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  String get _e164 => '+20${normalizeDigits(_phone.text).substring(1)}';

  void _submitForm() {
    setState(() => _formError = null);
    if (_name.text.trim().isEmpty) {
      setState(() => _formError = 'اكتب اسمك');
      return;
    }
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _formError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    if (_password.text.length < 6) {
      setState(() => _formError = 'كلمة السر لازم 6 حروف على الأقل');
      return;
    }
    context.read<SignupCubit>().submitForm(
        name: _name.text.trim(), phone: _e164, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        builder: (context, state) {
          final onCode = state is SignupCodeSent || state is SignupVerifying;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(onCode ? 'أكّد رقمك' : 'اعمل حساب جديد', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.lg),
              if (!onCode) ...[
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'الاسم', prefixIcon: Icon(Icons.person_outline)),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  decoration: const InputDecoration(
                    labelText: 'رقم الموبايل', hintText: '01xxxxxxxxx',
                    prefixIcon: Icon(Icons.phone_android)),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة السر (6 حروف على الأقل)',
                    prefixIcon: Icon(Icons.lock_outline)),
                ),
                if (_formError != null || state is SignupFormError) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _formError ?? (state as SignupFormError).message,
                    style: AppTextStyles.caption.copyWith(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is SignupSubmitting ? null : _submitForm,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is SignupSubmitting ? 'لحظة...' : 'متابعة'),
                ),
              ] else ...[
                Text('بعتنا كود على $_e164  (للتجربة: ١٢٣٤)', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.lg),
                OtpCodeField(
                  controller: _code,
                  errorText: state is SignupCodeSent ? state.error : null,
                  onResend: () => context.read<SignupCubit>().resend(),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: state is SignupVerifying
                      ? null
                      : () => context.read<SignupCubit>().confirmCode(_code.text),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is SignupVerifying ? 'بنأكد...' : 'تأكيد وإنشاء الحساب'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 8: Add the `/auth/signup` route**

`router.dart`:
```dart
import '../features/auth/view/signup_screen.dart';
```
```dart
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return SignupScreen(from: extra?['from']);
        },
      ),
```

- [ ] **Step 9: Write the signup screen widget test**

`apps/mobile/test/features/auth/signup_screen_test.dart`: getIt-register `MockAuthRepository(latency: Duration.zero)` + `SessionCubit` provider, minimal `MaterialApp.router`. Assert: filling name + a NEW phone (e.g. `01222222222`) + password `secret1`, tapping "متابعة" reveals the OTP field ("تأكيد وإنشاء الحساب" appears). Then type `1234`, tap confirm → session becomes authenticated (or navigates to `/account` stub). Also assert the password-too-short inline error. Keep robust; mirror existing getIt test setup.

- [ ] **Step 10: analyze + full suite + commit**
```bash
git add apps/mobile/lib/features/auth/view/otp_code_field.dart apps/mobile/lib/features/auth/bloc/signup_cubit.dart apps/mobile/lib/features/auth/bloc/signup_state.dart apps/mobile/lib/features/auth/bloc/signup_state.freezed.dart apps/mobile/lib/features/auth/view/signup_screen.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/signup_cubit_test.dart apps/mobile/test/features/auth/signup_screen_test.dart
git commit -m "feat(auth): signup (name+phone+password → OTP confirm) + shared OtpCodeField"
```

---

### Task 4: ResetCubit + Forgot-password screen

**Files:**
- Create: `apps/mobile/lib/features/auth/bloc/reset_cubit.dart`
- Create: `apps/mobile/lib/features/auth/bloc/reset_state.dart`
- Create: `apps/mobile/lib/features/auth/view/forgot_password_screen.dart`
- Modify: `apps/mobile/lib/app/router.dart` (add `/auth/forgot`)
- Test: `apps/mobile/test/features/auth/reset_cubit_test.dart`
- Test: `apps/mobile/test/features/auth/forgot_password_screen_test.dart`

**Context:** Mirrors signup: Phase A enter phone → `submitPhone` → `startReset` (account-exists check) → reveal OTP + new-password fields. Phase B → `confirm(code, newPassword)` → `confirmReset` → success → signin.

- [ ] **Step 1: Write the ResetCubit test**

`apps/mobile/test/features/auth/reset_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/reset_cubit.dart';
import 'package:wasalni/features/auth/bloc/reset_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201000000000', displayName: 'أحمد', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<ResetCubit, ResetState>(
    'submitPhone success → [submitting, codeSent]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone'))).thenAnswer((_) async {});
      return ResetCubit(repo);
    },
    act: (c) => c.submitPhone('+201000000000'),
    expect: () => [isA<ResetSubmitting>(), isA<ResetCodeSent>()],
  );

  blocTest<ResetCubit, ResetState>(
    'submitPhone unknown → [submitting, phoneError]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone')))
          .thenThrow(const AccountNotFoundException());
      return ResetCubit(repo);
    },
    act: (c) => c.submitPhone('+201999999999'),
    expect: () => [isA<ResetSubmitting>(), isA<ResetPhoneError>()],
  );

  blocTest<ResetCubit, ResetState>(
    'confirm success → [..., verifying, success]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmReset(
              phone: any(named: 'phone'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword')))
          .thenAnswer((_) async => _p());
      return ResetCubit(repo);
    },
    act: (c) async {
      await c.submitPhone('+201000000000');
      await c.confirm(code: '1234', newPassword: 'brandnew');
    },
    expect: () => [
      isA<ResetSubmitting>(),
      isA<ResetCodeSent>(),
      isA<ResetVerifying>(),
      isA<ResetSuccess>(),
    ],
  );

  blocTest<ResetCubit, ResetState>(
    'confirm wrong code → [..., verifying, codeSent(error)]',
    build: () {
      when(() => repo.startReset(phone: any(named: 'phone'))).thenAnswer((_) async {});
      when(() => repo.confirmReset(
              phone: any(named: 'phone'),
              code: any(named: 'code'),
              newPassword: any(named: 'newPassword')))
          .thenThrow(const OtpWrongCodeException());
      return ResetCubit(repo);
    },
    act: (c) async {
      await c.submitPhone('+201000000000');
      await c.confirm(code: '0000', newPassword: 'brandnew');
    },
    expect: () => [
      isA<ResetSubmitting>(),
      isA<ResetCodeSent>(),
      isA<ResetVerifying>(),
      isA<ResetCodeSent>().having((s) => s.error, 'error', isNotNull),
    ],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/reset_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'reset_state.freezed.dart';

@freezed
sealed class ResetState with _$ResetState {
  const factory ResetState.phone() = ResetPhase;
  const factory ResetState.submitting() = ResetSubmitting;
  const factory ResetState.phoneError(String message) = ResetPhoneError;
  const factory ResetState.codeSent({String? error}) = ResetCodeSent;
  const factory ResetState.verifying() = ResetVerifying;
  const factory ResetState.success(Profile profile) = ResetSuccess;
}
```

`apps/mobile/lib/features/auth/bloc/reset_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_state.dart';

class ResetCubit extends Cubit<ResetState> {
  ResetCubit(this._repo) : super(const ResetState.phone());
  final AuthRepository _repo;

  String _phone = '';

  Future<void> submitPhone(String phone) async {
    _phone = phone;
    emit(const ResetState.submitting());
    try {
      await _repo.startReset(phone: phone);
      emit(const ResetState.codeSent());
    } on AuthException catch (e) {
      emit(ResetState.phoneError(e.message ?? 'تعذّر إرسال الكود'));
    } on NoConnectionException {
      emit(const ResetState.phoneError('مفيش اتصال بالإنترنت'));
    }
  }

  Future<void> resend() async {
    try {
      await _repo.startReset(phone: _phone);
    } catch (_) {/* best-effort in mock */}
  }

  Future<void> confirm({required String code, required String newPassword}) async {
    emit(const ResetState.verifying());
    try {
      final profile =
          await _repo.confirmReset(phone: _phone, code: code, newPassword: newPassword);
      emit(ResetState.success(profile));
    } on AuthException catch (e) {
      emit(ResetState.codeSent(error: e.message));
    } on NoConnectionException {
      emit(const ResetState.codeSent(error: 'مفيش اتصال بالإنترنت'));
    }
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

- [ ] **Step 6: Write the Forgot-password screen**

`apps/mobile/lib/features/auth/view/forgot_password_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_cubit.dart';
import '../bloc/reset_state.dart';
import '../phone_validator.dart';
import 'otp_code_field.dart';
import 'session_sign_in.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetCubit(getIt<AuthRepository>()),
      child: _ForgotBody(from: from),
    );
  }
}

class _ForgotBody extends StatefulWidget {
  const _ForgotBody({this.from});
  final String? from;
  @override
  State<_ForgotBody> createState() => _ForgotBodyState();
}

class _ForgotBodyState extends State<_ForgotBody> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  String get _e164 => '+20${normalizeDigits(_phone.text).substring(1)}';

  void _submitPhone() {
    setState(() => _localError = null);
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _localError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    context.read<ResetCubit>().submitPhone(_e164);
  }

  void _confirm() {
    setState(() => _localError = null);
    if (_password.text.length < 6) {
      setState(() => _localError = 'كلمة السر لازم 6 حروف على الأقل');
      return;
    }
    context.read<ResetCubit>().confirm(code: _code.text, newPassword: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نسيت كلمة السر')),
      body: BlocConsumer<ResetCubit, ResetState>(
        listener: (context, state) {
          if (state is ResetSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        builder: (context, state) {
          final onCode = state is ResetCodeSent || state is ResetVerifying;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(onCode ? 'اعمل كلمة سر جديدة' : 'استرجاع كلمة السر',
                  style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.lg),
              if (!onCode) ...[
                Text('اكتب رقم موبايلك وهنبعتلك كود', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  decoration: InputDecoration(
                    labelText: 'رقم الموبايل', hintText: '01xxxxxxxxx',
                    errorText: _localError ?? (state is ResetPhoneError ? state.message : null),
                    prefixIcon: const Icon(Icons.phone_android)),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is ResetSubmitting ? null : _submitPhone,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is ResetSubmitting ? 'لحظة...' : 'إرسال الكود'),
                ),
              ] else ...[
                Text('بعتنا كود على $_e164  (للتجربة: ١٢٣٤)', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.lg),
                OtpCodeField(
                  controller: _code,
                  errorText: state is ResetCodeSent ? state.error : null,
                  onResend: () => context.read<ResetCubit>().resend(),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة السر الجديدة (6 حروف على الأقل)',
                    errorText: _localError,
                    prefixIcon: const Icon(Icons.lock_outline)),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is ResetVerifying ? null : _confirm,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is ResetVerifying ? 'بنأكد...' : 'تأكيد كلمة السر الجديدة'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 7: Add the `/auth/forgot` route**

`router.dart`:
```dart
import '../features/auth/view/forgot_password_screen.dart';
```
```dart
      GoRoute(
        path: '/auth/forgot',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return ForgotPasswordScreen(from: extra?['from']);
        },
      ),
```

- [ ] **Step 8: Write the forgot-password widget test**

`apps/mobile/test/features/auth/forgot_password_screen_test.dart`: getIt-register `MockAuthRepository(latency: Duration.zero)` + `SessionCubit`, minimal `MaterialApp.router`. Assert: entering the demo phone `01000000000`, tapping "إرسال الكود" reveals the code + new-password fields; entering `1234` + a 6+ char password and confirming → session authenticated (or `/account` stub). Also assert: an unknown phone shows the account-not-found error. Mirror existing getIt test setup.

- [ ] **Step 9: analyze + full suite + commit**
```bash
git add apps/mobile/lib/features/auth/bloc/reset_cubit.dart apps/mobile/lib/features/auth/bloc/reset_state.dart apps/mobile/lib/features/auth/bloc/reset_state.freezed.dart apps/mobile/lib/features/auth/view/forgot_password_screen.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/reset_cubit_test.dart apps/mobile/test/features/auth/forgot_password_screen_test.dart
git commit -m "feat(auth): forgot-password (phone → OTP → new password)"
```

---

### Task 5: Final wiring, cleanup, and review

**Files:**
- Verify/Modify: `apps/mobile/lib/app/router.dart`
- Verify: `apps/mobile/lib/features/account/view/account_screen.dart` (guest button already pushes `/auth` with `from: '/account'` — confirm it still compiles and routes to LoginScreen)
- Confirm deletions from Task 1 (no dangling refs)
- Test: full suite

- [ ] **Step 1: Confirm no dangling references**

Run a search for the retired symbols; there should be **no** references left:
```bash
git grep -nE "PhoneEntryScreen|OtpScreen|OtpCubit|OtpState|requestOtp|verifyOtp|/auth/verify" -- apps/mobile/lib apps/mobile/test || echo "clean"
```
Fix any stragglers (e.g., an import or route still pointing at a deleted file).

- [ ] **Step 2: Confirm the account guest flow**

`account_screen.dart`'s guest branch calls `context.push('/auth', extra: {'from':'/account'})`. With `/auth` now → `LoginScreen`, this opens login. Verify it compiles and the `from` round-trips (login success → `signInAndReturn` → `context.go('/account')`).

- [ ] **Step 3: analyze + full suite**

Run: `flutter analyze && flutter test`
Expected: clean + all green.

- [ ] **Step 4: Manual smoke (optional, document only)**

Note in the PROGRESS file the manual paths to try on web: login (demo creds), signup (new phone + 1234), forgot (demo phone + 1234 + new pw), and that guest cart survives login.

- [ ] **Step 5: Commit any wiring fixes**
```bash
git add -A
git commit -m "chore(auth): finalize password-auth wiring + remove dangling OTP-login refs"
```

- [ ] **Step 6: Final code review**

Dispatch a final code-review subagent over the whole password-auth feature. Verify:
- login (phone+password) with seeded demo works; wrong creds show a friendly error.
- signup: free-phone check, OTP confirm (1234) creates an account that can then log in.
- forgot: account-exists check, OTP confirm sets a new password that logs in.
- guest cart survives login (SessionCubit.signIn doesn't clear CartCubit).
- redirect-after-login returns to `from`.
- no dangling OTP-login code; resend countdown is local (no per-second cubit emits).
- `flutter analyze` clean + all tests pass.

Then update `docs/superpowers/plans/PROGRESS-phase6-password-auth.md` and note deferred follow-ups (real Supabase auth + password hashing, email option, session persistence, rate-limiting).
```
