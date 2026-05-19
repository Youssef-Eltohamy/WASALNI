# Contract: Sign Out

**Endpoint:** Supabase Auth — `supabase.auth.signOut()`

---

## Request

```dart
await supabase.auth.signOut();
```

### Parameters
لا توجد.

---

## Success Response

`void` — لا response body. الـ `Session` تتمسح من الـ local storage تلقائياً.

**في الـ Bloc:**
- نطلق `AuthEvent.signoutSucceeded` → state يبقى `AuthState.unauthenticated`.
- نمسح أي `ProfileBloc` state.
- نوجّه User للـ Splash → Feed (Guest mode).

---

## Error Responses

| الكود | الحالة | المعالجة |
|-------|---------|----------|
| `network` | لا اتصال | نمسح session محلياً برضو، نعرض warning بسيط: "تم الخروج، لكن قد يكون لسه شغّال في السيرفر" |

**ملحوظة:** signOut عملياً لا يفشل من جهة العميل. حتى لو الشبكة مقطوعة، Supabase SDK بيمسح الـ session محلياً.

---

## Side Effects

- ✅ Refresh tokens يتم إبطالها في Supabase.
- ✅ Local session storage يتم مسحه.
- ✅ Auth listeners (`onAuthStateChange`) بيستقبلوا event `signedOut`.

---

## Acceptance Test

```dart
blocTest<AuthBloc, AuthState>(
  'emits [Unauthenticated] on signout',
  build: () => AuthBloc(repository: mockRepo),
  seed: () => AuthState.authenticated(user: mockUser),
  act: (bloc) => bloc.add(SignoutRequested()),
  setUp: () {
    when(() => mockRepo.signOut())
        .thenAnswer((_) async => const Right(null));
  },
  expect: () => [
    AuthState.unauthenticated(),
  ],
);
```
