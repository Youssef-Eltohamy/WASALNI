# Auth / OTP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Build the phone + OTP login flow (mock), a global session (guest vs authenticated), an Account tab that reflects it, redirect-after-login for protected routes, and wire the authenticated user's name into cart orders. The guest cart survives login automatically (the app-wide `CartCubit` singleton is never cleared on sign-in).

**Architecture:** A global `SessionCubit` (get_it singleton, provided app-wide) holds `SessionState` = `unknown | guest | authenticated(Profile)`, starting as `guest` (browse-first). A per-screen `OtpCubit` drives the OTP state machine against a mock `AuthRepository`. go_router gains `/auth` (phone) + `/auth/verify` (code) routes and a redirect that protects designated routes, returning the user to where they came from after login.

**Mock OTP rules (so every state is reachable in the UI):** correct code = `1234` → success; `0000` → expired; `9999` → rate-limited; anything else → wrong code. Real SMS/WhatsApp OTP and session persistence are deferred to the backend phase.

**Tech Stack:** Flutter, flutter_bloc (Cubit), go_router, get_it, freezed (no json_serializable). Tests: flutter_test, bloc_test, mocktail.

**Conventions (from existing code):**
- freezed: `abstract class` for data, `sealed class` for unions/states; `const X._();` when adding getters. **No json_serializable / no `.g.dart`.**
- codegen: `dart run build_runner build --force-jit --delete-conflicting-outputs` from `apps/mobile`.
- Theme tokens only (`AppColors`/`AppSpacing`/`AppTextStyles`), Cairo, min 14sp, RTL (`EdgeInsetsDirectional` for asymmetric).
- Egyptian-Arabic friendly tone. All commands from `D:\programing\wasalni\apps\mobile`.
- mocktail `any()` on custom types needs `registerFallbackValue` in a `setUpAll`.

---

### Task 1: Profile model + SessionCubit (+ DI + app-wide provider)

**Files:**
- Create: `apps/mobile/lib/data/models/profile.dart`
- Create: `apps/mobile/lib/features/auth/bloc/session_state.dart`
- Create: `apps/mobile/lib/features/auth/bloc/session_cubit.dart`
- Modify: `apps/mobile/lib/app/di.dart`
- Modify: `apps/mobile/lib/app/app.dart`
- Test: `apps/mobile/test/features/auth/session_cubit_test.dart`

- [ ] **Step 1: Write the failing test**

`apps/mobile/test/features/auth/session_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/bloc/session_state.dart';

Profile _profile() => Profile(
    id: 'u1', phone: '+201000000000', displayName: 'محمد', createdAt: DateTime(2026));

void main() {
  test('starts as guest', () {
    expect(SessionCubit().state, isA<SessionGuest>());
  });

  blocTest<SessionCubit, SessionState>(
    'signIn → authenticated with profile',
    build: SessionCubit.new,
    act: (c) => c.signIn(_profile()),
    expect: () => [isA<SessionAuthenticated>()],
    verify: (c) =>
        expect((c.state as SessionAuthenticated).profile.displayName, 'محمد'),
  );

  blocTest<SessionCubit, SessionState>(
    'signOut → back to guest',
    build: SessionCubit.new,
    act: (c) { c.signIn(_profile()); c.signOut(); },
    expect: () => [isA<SessionAuthenticated>(), isA<SessionGuest>()],
  );

  test('displayName helper: empty for guest, name when authenticated', () {
    final c = SessionCubit();
    expect(c.displayName, '');
    c.signIn(_profile());
    expect(c.displayName, 'محمد');
  });
}
```

- [ ] **Step 2: Run → fails** (`flutter test test/features/auth/session_cubit_test.dart`).

- [ ] **Step 3: Write the model + state + cubit**

`apps/mobile/lib/data/models/profile.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String phone,
    required String displayName,
    String? villageId,
    required DateTime createdAt,
  }) = _Profile;
}
```

`apps/mobile/lib/features/auth/bloc/session_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.unknown() = SessionUnknown;
  const factory SessionState.guest() = SessionGuest;
  const factory SessionState.authenticated(Profile profile) = SessionAuthenticated;
}
```

`apps/mobile/lib/features/auth/bloc/session_cubit.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/profile.dart';
import 'session_state.dart';

/// Global session. Browse-first: starts as guest. Persistence across restarts
/// is deferred to the backend phase (mock session resets on cold start).
class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(const SessionState.guest());

  bool get isAuthenticated => state is SessionAuthenticated;

  String get displayName =>
      switch (state) { SessionAuthenticated(:final profile) => profile.displayName, _ => '' };

  void signIn(Profile profile) => emit(SessionState.authenticated(profile));
  void signOut() => emit(const SessionState.guest());
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes** (`flutter test test/features/auth/session_cubit_test.dart`).

- [ ] **Step 6: Register in DI + provide app-wide**

`di.dart` — add import `import '../features/auth/bloc/session_cubit.dart';` and to the cascade:
```dart
    ..registerLazySingleton<SessionCubit>(SessionCubit.new)
```

`app.dart` — add to the existing `MultiBlocProvider.providers` list:
```dart
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
```
(Add the import `import 'package:wasalni/features/auth/bloc/session_cubit.dart';`. Keep everything else unchanged.)

- [ ] **Step 7: analyze + full suite** — `flutter analyze && flutter test` (all pass).

- [ ] **Step 8: Commit**
```bash
git add apps/mobile/lib/data/models/profile.dart apps/mobile/lib/data/models/profile.freezed.dart apps/mobile/lib/features/auth/bloc/session_state.dart apps/mobile/lib/features/auth/bloc/session_state.freezed.dart apps/mobile/lib/features/auth/bloc/session_cubit.dart apps/mobile/lib/app/di.dart apps/mobile/lib/app/app.dart apps/mobile/test/features/auth/session_cubit_test.dart
git commit -m "feat(auth): Profile model + global SessionCubit (guest/authenticated)"
```

---

### Task 2: AuthRepository + MockAuthRepository + OTP exceptions

**Files:**
- Create: `apps/mobile/lib/features/auth/auth_exceptions.dart`
- Create: `apps/mobile/lib/data/repositories/auth_repository.dart`
- Create: `apps/mobile/lib/data/repositories/mock/mock_auth_repository.dart`
- Modify: `apps/mobile/lib/app/di.dart`
- Test: `apps/mobile/test/data/repositories/mock_auth_repository_test.dart`

- [ ] **Step 1: Write the failing test**

`apps/mobile/test/data/repositories/mock_auth_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/mock/mock_auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';

void main() {
  late MockAuthRepository repo;
  setUp(() => repo = MockAuthRepository(latency: Duration.zero));

  test('requestOtp completes for a normal phone', () async {
    await expectLater(repo.requestOtp('+201000000000'), completes);
  });

  test('verifyOtp with 1234 returns a profile carrying the phone', () async {
    final p = await repo.verifyOtp(phone: '+201000000000', code: '1234');
    expect(p.phone, '+201000000000');
    expect(p.id, isNotEmpty);
  });

  test('wrong code throws OtpWrongCodeException', () {
    expect(() => repo.verifyOtp(phone: '+201000000000', code: '5555'),
        throwsA(isA<OtpWrongCodeException>()));
  });

  test('0000 throws OtpExpiredException', () {
    expect(() => repo.verifyOtp(phone: '+201000000000', code: '0000'),
        throwsA(isA<OtpExpiredException>()));
  });

  test('9999 throws OtpRateLimitedException', () {
    expect(() => repo.verifyOtp(phone: '+201000000000', code: '9999'),
        throwsA(isA<OtpRateLimitedException>()));
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write exceptions + repository + mock**

`apps/mobile/lib/features/auth/auth_exceptions.dart`:

```dart
/// OTP-flow errors. The OtpCubit maps each to a distinct UI state.
sealed class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

class OtpWrongCodeException extends AuthException {
  const OtpWrongCodeException() : super('الكود غلط، جرّب تاني');
}

class OtpExpiredException extends AuthException {
  const OtpExpiredException() : super('الكود انتهت صلاحيته، اطلب كود جديد');
}

class OtpRateLimitedException extends AuthException {
  const OtpRateLimitedException() : super('حاولت كتير، استنى شوية وجرّب تاني');
}
```

`apps/mobile/lib/data/repositories/auth_repository.dart`:

```dart
import '../models/profile.dart';

abstract interface class AuthRepository {
  Future<void> requestOtp(String phone);
  Future<Profile> verifyOtp({required String phone, required String code});
}
```

`apps/mobile/lib/data/repositories/mock/mock_auth_repository.dart`:

```dart
import '../../../features/auth/auth_exceptions.dart';
import '../../models/profile.dart';
import '../auth_repository.dart';

/// Mock OTP. Magic codes: 1234 = success, 0000 = expired, 9999 = rate-limited,
/// everything else = wrong code. Real OTP server is deferred to the backend phase.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({this.latency = const Duration(milliseconds: 500)});
  final Duration latency;

  @override
  Future<void> requestOtp(String phone) async {
    await Future<void>.delayed(latency);
  }

  @override
  Future<Profile> verifyOtp({required String phone, required String code}) async {
    await Future<void>.delayed(latency);
    switch (code) {
      case '0000':
        throw const OtpExpiredException();
      case '9999':
        throw const OtpRateLimitedException();
      case '1234':
        return Profile(
          id: 'u_${phone.hashCode.abs()}',
          phone: phone,
          displayName: '',
          createdAt: DateTime.now(),
        );
      default:
        throw const OtpWrongCodeException();
    }
  }
}
```

- [ ] **Step 4: Run → passes.**

- [ ] **Step 5: Register in DI** — `di.dart` add imports + cascade entry:
```dart
import '../data/repositories/auth_repository.dart';
import '../data/repositories/mock/mock_auth_repository.dart';
```
```dart
    ..registerLazySingleton<AuthRepository>(MockAuthRepository.new)
```

- [ ] **Step 6: analyze + full suite.**

- [ ] **Step 7: Commit**
```bash
git add apps/mobile/lib/features/auth/auth_exceptions.dart apps/mobile/lib/data/repositories/auth_repository.dart apps/mobile/lib/data/repositories/mock/mock_auth_repository.dart apps/mobile/lib/app/di.dart apps/mobile/test/data/repositories/mock_auth_repository_test.dart
git commit -m "feat(auth): AuthRepository + mock OTP (magic-code rules) + OTP exceptions"
```

---

### Task 3: OtpCubit (state machine + resend countdown)

**Files:**
- Create: `apps/mobile/lib/features/auth/bloc/otp_state.dart`
- Create: `apps/mobile/lib/features/auth/bloc/otp_cubit.dart`
- Test: `apps/mobile/test/features/auth/otp_cubit_test.dart`

**Context:** States: `idle → sending → codeSent(resendSeconds) → verifying → wrongCode / rateLimited / expired / success(Profile)`. `requestCode` sends then starts a 30s resend countdown (`Timer.periodic`). `verify` maps mock exceptions to states. The countdown timer fires at 1s intervals, so bloc_test's default settle window won't capture ticks — tests that only call `requestCode`/`verify` see the immediate transitions. Cancel the timer in `close()`.

- [ ] **Step 1: Write the failing test**

`apps/mobile/test/features/auth/otp_cubit_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/data/repositories/auth_repository.dart';
import 'package:wasalni/features/auth/auth_exceptions.dart';
import 'package:wasalni/features/auth/bloc/otp_cubit.dart';
import 'package:wasalni/features/auth/bloc/otp_state.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

Profile _p() => Profile(id: 'u1', phone: '+201000000000', displayName: '', createdAt: DateTime(2026));

void main() {
  late MockAuthRepo repo;
  setUp(() => repo = MockAuthRepo());

  blocTest<OtpCubit, OtpState>(
    'requestCode emits [sending, codeSent]',
    build: () {
      when(() => repo.requestOtp(any())).thenAnswer((_) async {});
      return OtpCubit(repo);
    },
    act: (c) => c.requestCode('+201000000000'),
    expect: () => [isA<OtpSending>(), isA<OtpCodeSent>()],
    verify: (c) => expect((c.state as OtpCodeSent).resendSeconds, 30),
  );

  blocTest<OtpCubit, OtpState>(
    'verify success emits [verifying, success]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenAnswer((_) async => _p());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '1234'),
    expect: () => [isA<OtpVerifying>(), isA<OtpSuccess>()],
  );

  blocTest<OtpCubit, OtpState>(
    'wrong code emits [verifying, wrongCode]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpWrongCodeException());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '5555'),
    expect: () => [isA<OtpVerifying>(), isA<OtpWrongCode>()],
  );

  blocTest<OtpCubit, OtpState>(
    'expired emits [verifying, expired]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpExpiredException());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '0000'),
    expect: () => [isA<OtpVerifying>(), isA<OtpExpired>()],
  );

  blocTest<OtpCubit, OtpState>(
    'rate limited emits [verifying, rateLimited]',
    build: () {
      when(() => repo.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')))
          .thenThrow(const OtpRateLimitedException());
      return OtpCubit(repo);
    },
    act: (c) => c.verify(phone: '+201000000000', code: '9999'),
    expect: () => [isA<OtpVerifying>(), isA<OtpRateLimited>()],
  );
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write state + cubit**

`apps/mobile/lib/features/auth/bloc/otp_state.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'otp_state.freezed.dart';

@freezed
sealed class OtpState with _$OtpState {
  const factory OtpState.idle() = OtpIdle;
  const factory OtpState.sending() = OtpSending;
  const factory OtpState.codeSent({@Default(30) int resendSeconds}) = OtpCodeSent;
  const factory OtpState.verifying() = OtpVerifying;
  const factory OtpState.wrongCode() = OtpWrongCode;
  const factory OtpState.rateLimited() = OtpRateLimited;
  const factory OtpState.expired() = OtpExpired;
  const factory OtpState.success(Profile profile) = OtpSuccess;
}
```

`apps/mobile/lib/features/auth/bloc/otp_cubit.dart`:

```dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._repo) : super(const OtpState.idle());

  final AuthRepository _repo;
  Timer? _timer;
  static const _resendStart = 30;

  Future<void> requestCode(String phone) async {
    emit(const OtpState.sending());
    try {
      await _repo.requestOtp(phone);
      _startCountdown();
    } on AuthException catch (e) {
      _mapError(e);
    }
  }

  Future<void> resend(String phone) => requestCode(phone);

  Future<void> verify({required String phone, required String code}) async {
    emit(const OtpState.verifying());
    try {
      final profile = await _repo.verifyOtp(phone: phone, code: code);
      _timer?.cancel();
      emit(OtpState.success(profile));
    } on AuthException catch (e) {
      _mapError(e);
    }
  }

  void _mapError(AuthException e) => emit(switch (e) {
        OtpExpiredException() => const OtpState.expired(),
        OtpRateLimitedException() => const OtpState.rateLimited(),
        OtpWrongCodeException() => const OtpState.wrongCode(),
      });

  void _startCountdown() {
    _timer?.cancel();
    emit(const OtpState.codeSent(resendSeconds: _resendStart));
    var remaining = _resendStart;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      remaining--;
      if (remaining <= 0) {
        t.cancel();
        emit(const OtpState.codeSent(resendSeconds: 0));
      } else {
        emit(OtpState.codeSent(resendSeconds: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 4: Generate freezed** — `dart run build_runner build --force-jit --delete-conflicting-outputs`.

- [ ] **Step 5: Run → passes.**

- [ ] **Step 6: analyze + full suite.**

- [ ] **Step 7: Commit**
```bash
git add apps/mobile/lib/features/auth/bloc/otp_state.dart apps/mobile/lib/features/auth/bloc/otp_state.freezed.dart apps/mobile/lib/features/auth/bloc/otp_cubit.dart apps/mobile/test/features/auth/otp_cubit_test.dart
git commit -m "feat(auth): OtpCubit state machine + resend countdown"
```

---

### Task 4: Phone-entry + OTP screens + routes

**Files:**
- Create: `apps/mobile/lib/features/auth/view/phone_entry_screen.dart`
- Create: `apps/mobile/lib/features/auth/view/otp_screen.dart`
- Create: `apps/mobile/lib/features/auth/phone_validator.dart`
- Modify: `apps/mobile/lib/app/router.dart`
- Test: `apps/mobile/test/features/auth/phone_validator_test.dart`
- Test: `apps/mobile/test/features/auth/phone_entry_screen_test.dart`
- Test: `apps/mobile/test/features/auth/otp_screen_test.dart`

**Context:** Phone screen: a phone field + "إرس��ل الكود". On `OtpCodeSent`, navigate to `/auth/verify` carrying `{phone, from}`. OTP screen: a 4-digit code field + "تأكيد", a resend button showing the countdown, and inline messages for wrongCode/rateLimited/expired. On `OtpSuccess`: `SessionCubit.signIn(profile)` then `context.go(from ?? '/account')`. Both screens build their own `OtpCubit(getIt<AuthRepository>())` via `BlocProvider`. The `from` return-location is passed through `GoRouterState.extra` as a `Map<String, String?>`.

- [ ] **Step 1: Write the phone-validator test**

`apps/mobile/test/features/auth/phone_validator_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/features/auth/phone_validator.dart';

void main() {
  test('accepts 11-digit Egyptian mobile starting 01', () {
    expect(isValidEgyptianMobile('01000000000'), isTrue);
    expect(isValidEgyptianMobile('٠١٠٠٠٠٠٠٠٠٠'), isTrue); // arabic-indic
  });
  test('rejects too short / wrong prefix', () {
    expect(isValidEgyptianMobile('0100'), isFalse);
    expect(isValidEgyptianMobile('02000000000'), isFalse);
    expect(isValidEgyptianMobile(''), isFalse);
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write the validator**

`apps/mobile/lib/features/auth/phone_validator.dart`:

```dart
const _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

String normalizeDigits(String raw) {
  final b = StringBuffer();
  for (final ch in raw.trim().split('')) {
    final ai = _arabicDigits.indexOf(ch);
    if (ai >= 0) {
      b.write(ai);
    } else if (ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39) {
      b.write(ch);
    }
  }
  return b.toString();
}

/// Egyptian mobile: 11 digits starting with 01 (after digit normalization).
bool isValidEgyptianMobile(String raw) {
  final d = normalizeDigits(raw);
  return d.length == 11 && d.startsWith('01');
}
```

- [ ] **Step 4: Run → passes.**

- [ ] **Step 5: Write the screens**

`apps/mobile/lib/features/auth/view/phone_entry_screen.dart`:

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
import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import '../phone_validator.dart';

class PhoneEntryScreen extends StatelessWidget {
  const PhoneEntryScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(getIt<AuthRepository>()),
      child: _PhoneEntryBody(from: from),
    );
  }
}

class _PhoneEntryBody extends StatefulWidget {
  const _PhoneEntryBody({this.from});
  final String? from;
  @override
  State<_PhoneEntryBody> createState() => _PhoneEntryBodyState();
}

class _PhoneEntryBodyState extends State<_PhoneEntryBody> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final phone = _controller.text;
    if (!isValidEgyptianMobile(phone)) {
      setState(() => _error = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    setState(() => _error = null);
    context.read<OtpCubit>().requestCode('+20${normalizeDigits(phone).substring(1)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpCodeSent) {
            context.push('/auth/verify', extra: <String, String?>{
              'phone': '+20${normalizeDigits(_controller.text).substring(1)}',
              'from': widget.from,
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('اكتب رقم موبايلك', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('هنبعتلك كود تأكيد على الرقم ده', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                decoration: InputDecoration(
                  labelText: 'رقم الموبايل',
                  hintText: '01xxxxxxxxx',
                  errorText: _error,
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) => FilledButton(
                  onPressed: state is OtpSending ? null : _submit,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is OtpSending ? 'بنبعت الكود...' : 'إرسال الكود'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

`apps/mobile/lib/features/auth/view/otp_screen.dart`:

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
import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import 'session_sign_in.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.phone, this.from});
  final String phone;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(getIt<AuthRepository>())..requestCode(phone),
      child: _OtpBody(phone: phone, from: from),
    );
  }
}

class _OtpBody extends StatefulWidget {
  const _OtpBody({required this.phone, this.from});
  final String phone;
  final String? from;
  @override
  State<_OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<_OtpBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _messageFor(OtpState state) => switch (state) {
        OtpWrongCode() => 'الكود غلط، جرّب تاني',
        OtpExpired() => 'الكود انتهت صلاحيته، اطلب كود جديد',
        OtpRateLimited() => 'حاولت كتير، استنى شوية',
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الرقم')),
      body: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        builder: (context, state) {
          final msg = _messageFor(state);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text('اكتب الكود اللي وصلك', style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.sm),
                Text('بعتنا كود على ${widget.phone}', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.sm),
                Text('(للتجربة: الكود ١٢٣٤)', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.headline,
                  decoration: InputDecoration(
                    counterText: '',
                    errorText: msg,
                    hintText: '____',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is OtpVerifying
                      ? null
                      : () => context.read<OtpCubit>().verify(phone: widget.phone, code: _controller.text),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is OtpVerifying ? 'بنأكد...' : 'تأكيد'),
                ),
                const SizedBox(height: AppSpacing.md),
                _ResendButton(phone: widget.phone, state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  const _ResendButton({required this.phone, required this.state});
  final String phone;
  final OtpState state;

  @override
  Widget build(BuildContext context) {
    final canResend = state is! OtpCodeSent || (state as OtpCodeSent).resendSeconds <= 0;
    final seconds = state is OtpCodeSent ? (state as OtpCodeSent).resendSeconds : 0;
    return TextButton(
      onPressed: canResend ? () => context.read<OtpCubit>().resend(phone) : null,
      child: Text(canResend ? 'ابعت الكود تاني' : 'ابعت تاني بعد ($seconds)'),
    );
  }
}
```

`apps/mobile/lib/features/auth/view/session_sign_in.dart` (tiny helper so the OTP screen and tests share the post-success behavior):

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/profile.dart';
import '../bloc/session_cubit.dart';

/// On OTP success: set the session and return to where the user came from.
void signInAndReturn(BuildContext context, Profile profile, String? from) {
  context.read<SessionCubit>().signIn(profile);
  context.go(from ?? '/account');
}
```

- [ ] **Step 6: Add routes**

`router.dart` — add imports:
```dart
import '../features/auth/view/phone_entry_screen.dart';
import '../features/auth/view/otp_screen.dart';
```
Add sibling routes:
```dart
      GoRoute(
        path: '/auth',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return PhoneEntryScreen(from: extra?['from']);
        },
      ),
      GoRoute(
        path: '/auth/verify',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>? ?? const {};
          return OtpScreen(phone: extra['phone'] ?? '', from: extra['from']);
        },
      ),
```

- [ ] **Step 7: Write screen widget tests**

`apps/mobile/test/features/auth/phone_entry_screen_test.dart`: pump `PhoneEntryScreen` wrapped in `MaterialApp` (no router needed if you only test validation). Assert: tapping "إرسال الكود" with an invalid number shows the error text; entering a valid 11-digit number clears it. (Provide a fake/real `AuthRepository` via `getIt` — register `MockAuthRepository(latency: Duration.zero)` in the test `setUp`, or refactor `PhoneEntryScreen` to accept an optional repo. Prefer registering in getIt in `setUp` and `getIt.reset()` in `tearDown` to keep it simple.)

`apps/mobile/test/features/auth/otp_screen_test.dart`: build an `OtpScreen` with a stub `AuthRepository` registered in getIt; type `1234`, tap "تأكيد"; since success calls `signInAndReturn` which needs a `SessionCubit` + router, wrap in a minimal `MaterialApp.router` (GoRouter with `/auth/verify` and `/account` stub) and provide `SessionCubit` via `BlocProvider`. Assert that after a successful verify the session becomes authenticated. Keep this test focused; if full router wiring is heavy, instead assert the wrong-code path: type `5555`, tap تأكيد, expect the error text "الكود غلط، جرّب تاني" appears (no navigation needed). Implement whichever is robust; at minimum cover the wrong-code inline message.

Follow the existing widget-test style in `test/features/products/` for getIt setup/reset.

- [ ] **Step 8: Run the auth tests + analyze + full suite.**

Run: `flutter test test/features/auth/ && flutter analyze && flutter test`
Expected: all pass.

- [ ] **Step 9: Commit**
```bash
git add apps/mobile/lib/features/auth/view/ apps/mobile/lib/features/auth/phone_validator.dart apps/mobile/lib/app/router.dart apps/mobile/test/features/auth/phone_validator_test.dart apps/mobile/test/features/auth/phone_entry_screen_test.dart apps/mobile/test/features/auth/otp_screen_test.dart
git commit -m "feat(auth): phone-entry + OTP screens + /auth routes"
```

---

### Task 5: AuthGate redirect-after-login + Account screen + cart user-name wiring

**Files:**
- Create: `apps/mobile/lib/features/account/view/account_screen.dart`
- Delete: `apps/mobile/lib/features/account/account_placeholder.dart` (replaced)
- Modify: `apps/mobile/lib/app/router.dart` (use AccountScreen + protected-route redirect)
- Modify: `apps/mobile/lib/features/cart/view/cart_screen.dart` (use SessionCubit.displayName)
- Test: `apps/mobile/test/features/account/account_screen_test.dart`

**Context:** The Account tab reflects the session: a guest sees a sign-in prompt + button (→ `/auth` with `from: '/account'`); an authenticated user sees their name + phone + a sign-out button. Redirect-after-login: go_router's `redirect` protects a set of routes (future: registration/my-listing/verification/subscription). For now wire the mechanism + protect nothing aggressively (browsing + cart stay open to guests); the concrete, testable login path is via the Account tab. Also: the cart's order message should carry the signed-in user's name — read `SessionCubit.displayName` in `CartScreen`.

- [ ] **Step 1: Write the failing Account test**

`apps/mobile/test/features/account/account_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/features/account/view/account_screen.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';

Widget _host(SessionCubit session) => MaterialApp(
      home: BlocProvider.value(value: session, child: const AccountScreen()),
    );

void main() {
  testWidgets('guest sees a sign-in prompt', (tester) async {
    await tester.pumpWidget(_host(SessionCubit()));
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });

  testWidgets('authenticated user sees name + sign out', (tester) async {
    final session = SessionCubit()
      ..signIn(Profile(id: 'u1', phone: '+201000000000', displayName: 'محمد', createdAt: DateTime(2026)));
    await tester.pumpWidget(_host(session));
    expect(find.text('محمد'), findsOneWidget);
    expect(find.text('تسجيل الخروج'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Write AccountScreen**

`apps/mobile/lib/features/account/view/account_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/bloc/session_cubit.dart';
import '../../auth/bloc/session_state.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) => switch (state) {
          SessionAuthenticated(:final profile) => _Authenticated(
              name: profile.displayName.isEmpty ? 'مستخدم وصلني' : profile.displayName,
              phone: profile.phone,
              onSignOut: () => context.read<SessionCubit>().signOut(),
            ),
          _ => _Guest(onSignIn: () => context.push('/auth', extra: <String, String?>{'from': '/account'})),
        },
      ),
    );
  }
}

class _Guest extends StatelessWidget {
  const _Guest({required this.onSignIn});
  final VoidCallback onSignIn;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined, size: 72, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text('سجّل دخولك عشان تكمّل', style: AppTextStyles.title, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text('تقدر تتصفح من غير تسجيل، بس التسجيل بيخليك تطلب وتحفظ المفضلة',
                style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: onSignIn,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              icon: const Icon(Icons.login),
              label: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Authenticated extends StatelessWidget {
  const _Authenticated({required this.name, required this.phone, required this.onSignOut});
  final String name;
  final String phone;
  final VoidCallback onSignOut;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.md),
        const CircleAvatar(radius: 36, backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 40, color: Colors.white)),
        const SizedBox(height: AppSpacing.md),
        Text(name, style: AppTextStyles.headline, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        Text(phone, style: AppTextStyles.caption, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xl),
        OutlinedButton.icon(
          onPressed: onSignOut,
          icon: const Icon(Icons.logout, color: AppColors.error),
          label: Text('تسجيل الخروج', style: AppTextStyles.label.copyWith(color: AppColors.error)),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run → passes.**

- [ ] **Step 5: Swap the placeholder in the router**

`router.dart`: remove `import '../features/account/account_placeholder.dart';`, add `import '../features/account/view/account_screen.dart';`, and change the `/account` branch builder to `const AccountScreen()`. Then delete `apps/mobile/lib/features/account/account_placeholder.dart`.

- [ ] **Step 6: Wire the cart message to the signed-in name**

`cart_screen.dart`: the `_send` method currently uses `widget.userName`. Change it to prefer the session name when the widget value is empty. At the top of `_send`, before calling `sender.send`, compute:
```dart
import '../../auth/bloc/session_cubit.dart';
// ...
    final name = widget.userName.isNotEmpty
        ? widget.userName
        : context.read<SessionCubit>().displayName;
```
and pass `userName: name` to `sender.send(...)`. (The `CartScreen` is built under the app-wide `SessionCubit` provider, so `context.read` works. In the existing `cart_screen_test.dart`, add a `BlocProvider<SessionCubit>` to the test host so `_send` can read it — though the current tests don't trigger send, add the provider defensively to keep the widget tree valid.)

- [ ] **Step 7: (Optional, low-risk) protected-route redirect scaffold**

In `createRouter()`, add a `redirect` callback that is ready for protected routes but currently a no-op for existing routes (so nothing breaks). Keep it minimal:
```dart
  return GoRouter(
    initialLocation: '/feed',
    redirect: (context, state) {
      // Future protected routes can be gated here using getIt<SessionCubit>().isAuthenticated
      // and redirect to '/auth' with extra {'from': state.matchedLocation}. No-op for now.
      return null;
    },
    routes: [ /* ...unchanged... */ ],
  );
```
(This documents the extension point without changing behavior. Do not gate `/cart` or browsing — guests can use them.)

- [ ] **Step 8: analyze + full suite**

Run: `flutter analyze && flutter test`
Expected: all pass. Confirm no remaining references to `AccountPlaceholder`.

- [ ] **Step 9: Commit**
```bash
git add apps/mobile/lib/features/account/ apps/mobile/lib/app/router.dart apps/mobile/lib/features/cart/view/cart_screen.dart apps/mobile/test/features/account/account_screen_test.dart
git commit -m "feat(auth): account screen (guest/authenticated) + sign-in flow + cart name wiring"
```

---

## Final review (after all 5 tasks)

Dispatch a final code-review subagent over the whole Auth/OTP implementation. Verify against spec section 11:
- OTP states present (idle/sending/codeSent/verifying/wrongCode/rateLimited/expired/success) ✓
- resend countdown ✓
- guest cart survives login (app-wide CartCubit not cleared) ✓ — note favorites-merge is deferred (favorites not built)
- redirect-after-login mechanism + returns to `from` ✓
- account reflects session; sign in / sign out ✓
- mock OTP (magic codes), real OTP deferred ✓

Then run `flutter analyze` + `flutter test`, update `docs/superpowers/plans/PROGRESS-phase5-auth-otp.md`, and report any deferred follow-ups (session persistence, favorites guest-merge, WhatsApp-OTP alternative, protected-route gating when those screens exist).
```
