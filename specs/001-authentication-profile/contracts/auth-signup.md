# Contract: Sign Up

**Endpoint:** Supabase Auth — `supabase.auth.signUp()`

---

## Request

```dart
final response = await supabase.auth.signUp(
  email: 'user@example.com',
  password: 'StrongP@ss123',
  emailRedirectTo: 'wasalni://auth/confirm',
);
```

### Parameters

| الحقل | النوع | إلزامي | Validation |
|------|------|---------|-------------|
| `email` | `String` | ✅ | Regex: `^[\w-.]+@[\w-]+\.[a-z]{2,}$` |
| `password` | `String` | ✅ | `≥8` حرف، حرف كبير + رقم |
| `emailRedirectTo` | `String` | ✅ | Deep link: `wasalni://auth/confirm` |

---

## Success Response

```dart
AuthResponse {
  user: User {
    id: 'uuid-here',
    email: 'user@example.com',
    email_confirmed_at: null,  // لسه مأكدش
    created_at: '2026-05-19T08:30:00Z',
  },
  session: null,  // مفيش جلسة قبل التأكيد
}
```

**في الـ Bloc:** نطلق `AuthEvent.signupSucceeded(user)` → state يبقى `AuthState.awaitingEmailConfirmation`.

---

## Error Responses

| الكود | الحالة | رسالة عربية |
|-------|---------|-------------|
| `422` | Email already exists | "الإيميل مسجل بالفعل، حاول تسجيل الدخول" |
| `400` | Invalid email format | "تنسيق الإيميل غير صحيح" |
| `400` | Weak password | "كلمة السر ضعيفة (8 حروف، حرف كبير + رقم)" |
| `429` | Rate limit | "محاولات كتيرة، حاول بعد دقيقة" |
| `network` | لا اتصال | "تحقق من اتصالك بالإنترنت" |

---

## Side Effects

- ✅ Supabase يبعت تلقائياً إيميل تأكيد للمستخدم.
- ❌ مفيش row في `public.profiles` بعد — يتم إنشاؤه في خطوة "Profile Setup".

---

## Acceptance Test

```dart
blocTest<AuthBloc, AuthState>(
  'emits [Loading, AwaitingConfirmation] on successful signup',
  build: () => AuthBloc(repository: mockRepo),
  act: (bloc) => bloc.add(SignupRequested(email, password, true)),
  setUp: () {
    when(() => mockRepo.signUp(any(), any()))
        .thenAnswer((_) async => Right(mockUser));
  },
  expect: () => [
    AuthState.loading(),
    AuthState.awaitingEmailConfirmation(email: 'user@example.com'),
  ],
);
```
