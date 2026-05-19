# Contract: Sign In

**Endpoint:** Supabase Auth — `supabase.auth.signInWithPassword()`

---

## Request

```dart
final response = await supabase.auth.signInWithPassword(
  email: 'user@example.com',
  password: 'StrongP@ss123',
);
```

### Parameters

| الحقل | النوع | إلزامي | Validation |
|------|------|---------|-------------|
| `email` | `String` | ✅ | Regex email |
| `password` | `String` | ✅ | non-empty |

---

## Success Response

```dart
AuthResponse {
  user: User { id, email, email_confirmed_at, ... },
  session: Session {
    access_token: 'jwt-here',
    refresh_token: 'refresh-jwt',
    expires_at: 1715000000,
  },
}
```

**في الـ Bloc:** 
1. نطلق `AuthEvent.signinSucceeded(user, session)` → state يبقى `AuthState.authenticated(user)`.
2. مع كل state authenticated، نلوّد الـ `Profile` من `ProfileBloc`.

---

## Error Responses

| الكود | الحالة | رسالة عربية |
|-------|---------|-------------|
| `400` | Invalid credentials | "بيانات الدخول غير صحيحة" (مش نكشف هل الإيميل ولا الباسورد الخطأ) |
| `400` | Email not confirmed | "الإيميل غير مؤكد، تحقق من بريدك" |
| `429` | Rate limit (5 محاولات) | "محاولات كتيرة، حاول بعد 60 ثانية" |
| `network` | لا اتصال | "تحقق من اتصالك بالإنترنت" |

---

## Special Behavior

### Email Not Confirmed
لو الـ User بيحاول signin وإيميله مأكدش:
- Supabase بيرجع 400 مع `error_description: 'Email not confirmed'`
- نوجّهه لشاشة "Email Confirmation Pending" مع زر "إعادة إرسال"

### Rate Limiting
بعد 5 محاولات فاشلة في 60 ثانية → 60 ثانية تأخير. نعرض timer للمستخدم.

---

## Acceptance Test

```dart
blocTest<AuthBloc, AuthState>(
  'emits [Loading, Authenticated] on successful signin',
  build: () => AuthBloc(repository: mockRepo),
  act: (bloc) => bloc.add(SigninRequested(email, password)),
  setUp: () {
    when(() => mockRepo.signIn(any(), any()))
        .thenAnswer((_) async => Right(mockUserWithSession));
  },
  expect: () => [
    AuthState.loading(),
    AuthState.authenticated(user: mockUser),
  ],
);
```
