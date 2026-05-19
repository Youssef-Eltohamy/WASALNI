# Contract: Reset Password

**Endpoint:** Supabase Auth — `supabase.auth.resetPasswordForEmail()` + `supabase.auth.updateUser()`

---

## Step 1: Request Reset Email

```dart
await supabase.auth.resetPasswordForEmail(
  'user@example.com',
  redirectTo: 'wasalni://auth/reset-password',
);
```

### Parameters

| الحقل | النوع | إلزامي |
|------|------|---------|
| `email` | `String` | ✅ |
| `redirectTo` | `String` | ✅ Deep link |

### Response

`void` — لا رد فعلي. **مهم لأمان:** نعرض دائماً نفس الرسالة بغض النظر إن الإيميل مسجل أم لا:

> "تم إرسال رابط استعادة كلمة السر لو الإيميل مسجل عندنا"

ده يمنع enumeration attacks (التحقق من وجود إيميل عبر هذه الخدمة).

---

## Step 2: User يضغط الـ Link

اللينك بيفتح التطبيق على `wasalni://auth/reset-password?token=XXX`.

Supabase SDK بيعالج الـ token تلقائياً ويفتح session مؤقتة. App بيقرأ الـ event:

```dart
supabase.auth.onAuthStateChange.listen((event) {
  if (event.event == AuthChangeEvent.passwordRecovery) {
    // وجّه User لشاشة "كلمة سر جديدة"
    GoRouter.of(context).go('/reset-password');
  }
});
```

---

## Step 3: Update Password

```dart
await supabase.auth.updateUser(
  UserAttributes(password: 'NewStrongP@ss456'),
);
```

### Parameters

| الحقل | النوع | إلزامي | Validation |
|------|------|---------|-------------|
| `password` | `String` | ✅ | نفس قواعد signup (≥8، حرف كبير + رقم) |

### Response

```dart
UserResponse { user: User { ... } }
```

**في الـ Bloc:** Auth state يبقى `authenticated` تلقائياً → نوجّه للـ Feed.

---

## Error Responses

| الكود | الحالة | رسالة عربية |
|-------|---------|-------------|
| `400` | Token منتهي/غير صالح | "اللينك انتهت صلاحيته، اطلب رابط جديد" |
| `400` | Password ضعيفة | "كلمة السر ضعيفة (8 حروف، حرف كبير + رقم)" |
| `429` | Rate limit | "محاولات كتيرة، حاول بعد دقيقة" |

---

## Token Expiry

Supabase reset tokens صالحة لمدة **24 ساعة** افتراضياً. لو انتهت، User لازم يطلب رابط جديد.

---

## Acceptance Test

```dart
blocTest<ForgotPasswordCubit, ForgotPasswordState>(
  'emits [Submitting, Success] on valid email',
  build: () => ForgotPasswordCubit(repository: mockRepo),
  act: (cubit) => cubit.submit('user@example.com'),
  setUp: () {
    when(() => mockRepo.resetPasswordForEmail(any()))
        .thenAnswer((_) async => const Right(null));
  },
  expect: () => [
    ForgotPasswordState.submitting(),
    ForgotPasswordState.success(),
  ],
);
```
