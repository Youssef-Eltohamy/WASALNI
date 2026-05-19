# Implementation Plan: Authentication & User Profile

**Branch**: `001-authentication-profile` | **Date**: 2026-05-19 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-authentication-profile/spec.md`

---

## Summary

تنفيذ نظام المصادقة وإكمال البروفايل لـ WASALNI. يدعم:
- التصفح كـ Guest بدون تسجيل
- التسجيل بالإيميل + كلمة سر مع تأكيد إيميل إلزامي
- استكمال بيانات بروفايل إلزامية بعد التأكيد
- جلسة 30 يوم تلقائية، استعادة كلمة سر، تسجيل خروج
- حذف تلقائي للحسابات غير المؤكدة بعد 7 أيام

**النهج التقني:** نستخدم Supabase Auth (built-in email/password + JWT) مع جدول `public.profiles` ممدد. الموبايل بـ Flutter + Bloc، التحقق client-side أولاً ثم server-side عبر RLS. التخزين للصور في Supabase Storage bucket `avatars`.

---

## Technical Context

| البند | القيمة |
|-------|--------|
| **Language/Version** | Dart 3.10.8 (Flutter 3.38.9) — Mobile |
| **Primary Dependencies** | `supabase_flutter ^2.5.6`, `flutter_bloc ^9.0.0`, `equatable ^2.0.7`, `go_router ^17.0.0`, `formz ^0.0.5`, `image_picker ^1.1.2`, `image ^4.6.0` (compression), `flutter_secure_storage ^9.2.4` |
| **Storage** | Supabase PostgreSQL (table `public.profiles`) + Supabase Storage (`avatars` bucket) |
| **Testing** | `flutter_test` (widget + bloc tests), `bloc_test ^9.1.7`, `mocktail ^1.0.4` |
| **Target Platform** | Android API 23+ (Android 6+), iOS 13+ |
| **Project Type** | Mobile app (Flutter) + Admin web (Next.js, لا يستخدم Auth في هذا الـ spec) |
| **Performance Goals** | شاشة Auth تفتح في <500ms، تسجيل دخول كامل <2s على 3G |
| **Constraints** | RTL وعربي فقط، offline-tolerant (تخزين session في secure storage)، تكلفة صفر (no SMS) |
| **Scale/Scope** | MVP target: 1000-5000 مستخدم أول 3 شهور، 6 شاشات auth-related |

---

## Constitution Check

### المبادئ الأساسية من الدستور

| المبدأ | الحالة | ملاحظات |
|--------|--------|---------|
| ✅ I. العربية أولاً والـ RTL | متطابق | كل النصوص بالعربي، MaterialApp بـ `locale: ar_EG` |
| ✅ II. Spec-Driven Development | متطابق | الـ spec موجودة قبل أي كود |
| ✅ III. Supabase = مصدر الحقيقة | متطابق | كل schema في `supabase/migrations/` |
| ✅ IV. الخصوصية والأمان | متطابق | RLS على `profiles`, secure storage للـ tokens, مفيش service_role في الموبايل |
| ✅ V. البساطة (YAGNI) | متطابق | لا OAuth, لا 2FA, لا الإيميل-changes في MVP |

### Tech Stack Constraints
| القيد | متطابق؟ |
|-------|---------|
| Flutter للموبايل | ✅ |
| Supabase Auth + Storage | ✅ |
| State: Bloc | ✅ |
| Naming: kebab-case للملفات | ✅ سيُطبّق |

**Constitution Gate:** ✅ **PASSED** — مفيش انتهاكات.

---

## Project Structure

### Documentation (this feature)

```text
specs/001-authentication-profile/
├── spec.md                # Feature specification ✅ (مكتمل)
├── plan.md                # هذا الملف ✅
├── research.md            # القرارات التقنية
├── data-model.md          # SQL schema + RLS
├── contracts/             # API contracts
│   ├── auth-signup.md
│   ├── auth-signin.md
│   ├── auth-signout.md
│   ├── auth-reset-password.md
│   ├── profile-create.md
│   ├── profile-update.md
│   └── avatar-upload.md
├── quickstart.md          # خطة اختبار يدوي
└── tasks.md               # ينُتج من /speckit-tasks (Phase 2)
```

### Source Code Structure

نتبع **Clean Architecture بـ Feature-First** كما حُدد في النقاش:

```text
apps/mobile/lib/
├── main.dart
├── app.dart                              # MaterialApp root
├── core/
│   ├── theme/
│   │   ├── app_theme.dart                # Material 3 + Cairo font
│   │   └── app_colors.dart               # ألوان WASALNI الموحّدة
│   ├── routing/
│   │   ├── app_router.dart               # go_router config
│   │   └── route_paths.dart              # ثوابت المسارات
│   ├── constants/
│   │   └── governorates.dart             # قائمة الـ 27 محافظة
│   ├── network/
│   │   └── supabase_client.dart          # Singleton Supabase init
│   ├── storage/
│   │   └── secure_storage_service.dart   # flutter_secure_storage wrapper
│   ├── errors/
│   │   ├── failures.dart                 # AuthFailure, ProfileFailure...
│   │   └── error_mapper.dart             # Supabase error → arabic message
│   ├── validators/
│   │   ├── email_validator.dart          # formz inputs
│   │   ├── password_validator.dart
│   │   ├── phone_validator.dart          # +20XXXXXXXXX
│   │   └── required_text_validator.dart
│   └── widgets/                          # Reusable widgets
│       ├── primary_button.dart
│       ├── secondary_button.dart
│       └── app_text_field.dart
│
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── auth_user_model.dart  # Wraps Supabase User
    │   │   └── repositories/
    │   │       └── auth_repository.dart  # Supabase Auth calls
    │   ├── domain/
    │   │   └── entities/
    │   │       └── auth_user.dart        # Plain entity (no Supabase types)
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart        # المراقب الأكبر: app-wide auth state
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       ├── pages/
    │       │   ├── splash_page.dart
    │       │   ├── signup_page.dart
    │       │   ├── signin_page.dart
    │       │   ├── email_confirmation_page.dart
    │       │   └── forgot_password_page.dart
    │       ├── widgets/
    │       │   ├── auth_required_modal.dart
    │       │   ├── email_confirmation_banner.dart
    │       │   └── terms_checkbox.dart
    │       └── cubit/
    │           ├── signup_form/
    │           │   ├── signup_form_cubit.dart   # Form state (Cubit أبسط)
    │           │   └── signup_form_state.dart
    │           ├── signin_form/
    │           ├── forgot_password_form/
    │           └── ...
    │
    └── profile/
        ├── data/
        │   ├── models/
        │   │   └── profile_model.dart     # Maps DB row to/from Profile entity
        │   └── repositories/
        │       └── profile_repository.dart
        ├── domain/
        │   └── entities/
        │       └── profile.dart
        └── presentation/
            ├── bloc/
            │   ├── profile_bloc.dart       # State بعد التحميل
            │   ├── profile_event.dart
            │   └── profile_state.dart
            ├── pages/
            │   ├── profile_setup_page.dart # شاشة استكمال بعد signup
            │   ├── my_account_page.dart    # عرض البروفايل + logout
            │   └── edit_profile_page.dart
            ├── widgets/
            │   ├── governorate_dropdown.dart
            │   ├── avatar_picker.dart
            │   └── profile_form_field.dart
            └── cubit/
                └── profile_form/
                    ├── profile_form_cubit.dart
                    └── profile_form_state.dart
```

### Test Structure

```text
apps/mobile/test/
├── core/
│   └── validators/
│       ├── email_validator_test.dart
│       ├── password_validator_test.dart
│       └── phone_validator_test.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   └── repositories/
    │   │       └── auth_repository_test.dart    # Mock Supabase
    │   └── presentation/
    │       └── bloc/
    │           └── auth_bloc_test.dart
    └── profile/
        └── presentation/
            └── bloc/
                └── profile_bloc_test.dart
```

### Supabase Structure

```text
supabase/
├── migrations/
│   ├── 20260519080900_initial_schema.sql          # موجود (extensions)
│   └── 20260519XXXXXX_001_auth_profiles.sql       # هذا الـ feature
└── seed.sql                                        # لا تعديل في هذا الـ spec
```

**Structure Decision:** Clean Architecture بـ feature-first في `apps/mobile/lib/features/`. كل feature ينقسم إلى `data/` + `domain/` + `presentation/`. الـ `core/` للأدوات المشتركة بين الـ features. هذا الهيكل **مرن وقابل للنمو** لـ Phase 2-4 بدون إعادة بناء.

---

## Implementation Phases

سنقسم التنفيذ على 4 مراحل صغيرة (ستتفصل في `tasks.md` لاحقاً):

### Phase A: البنية التحتية (Foundation)
1. تهيئة Supabase client في الموبايل
2. تهيئة `go_router` وتعريف المسارات
3. كتابة الـ migration للـ `profiles` + RLS policies + Storage bucket
4. تطبيق الـ migration على Supabase (`supabase db push`)
5. توليد types من DB (`supabase gen types`)
6. ملف الـ governorates (قائمة ثابتة 27 محافظة)
7. كتابة الـ `core/` utilities (validators, errors, theme, secure storage)

### Phase B: AuthBloc + Auth flows (P1 user stories)
1. `AuthRepository` (signUp, signIn, signOut, resetPassword, getCurrentUser, onAuthStateChange)
2. `AuthBloc` كـ app-wide state (Authenticated / Unauthenticated / Loading)
3. شاشة Splash + التحقق من session موجود
4. شاشة Signup (مع SignupFormCubit)
5. شاشة Signin (مع SigninFormCubit)
6. شاشة Email Confirmation (banner reminder + إعادة إرسال + عداد أيام)
7. حماية المسارات: Guest يقدر يدخل feed، لكن actions محتاجة auth تظهر modal

### Phase C: Profile flow
1. `ProfileRepository` (createProfile, getProfile, updateProfile, uploadAvatar)
2. `ProfileBloc` (loaded profile state)
3. شاشة Profile Setup (الإلزامية بعد التأكيد)
4. صفحة "حسابي" مع logout
5. صفحة "تعديل البروفايل"
6. Avatar Picker مع ضغط الصور client-side (≤2MB)

### Phase D: Polish + Edge Cases
1. شاشة Forgot Password + Deep link handling للـ reset
2. Edge case: 5 محاولات فاشلة → 60 ثانية تأخير
3. شاشة Terms & Conditions و Privacy Policy (محتوى placeholder)
4. حذف الحسابات غير المؤكدة بعد 7 أيام (Supabase scheduled function)
5. اختبارات الـ Bloc

---

## Acceptance Gates

قبل ما الـ feature يُعتبر مكتمل:

- [ ] كل 6 user stories من الـ spec تشتغل (manual test في `quickstart.md`)
- [ ] كل الـ FRs (FR-001 إلى FR-022) محققة
- [ ] `flutter analyze` بدون warnings
- [ ] `flutter test` كل الـ Bloc tests خضراء
- [ ] الـ migration مطبقة على Supabase وموثقة في `data-model.md`
- [ ] RLS مفعلة على `profiles` وtests على Supabase تأكد إن user بيشوف بروفايله بس
- [ ] Avatar upload يعمل على iOS و Android
- [ ] الـ navigation flow كله صحيح (Guest → Signin → Signup → Email Conf → Profile → Feed)

---

## Complexity Tracking

مفيش انتهاكات للدستور تحتاج justification. الـ feature بسيط نسبياً وفي نطاق MVP.

---

## Open Risks & Mitigations

| المخاطرة | الاحتمال | التأثير | التخفيف |
|-----------|----------|---------|----------|
| Supabase Auth email delivery يتأخر | متوسط | عالي | استخدام Resend أو Supabase SMTP custom لاحقاً |
| Email links مش بتشتغل في Deep Links | متوسط | عالي | اختبار مبكر، استخدام `app_links` package |
| رفع صور كبيرة يكسر Free Tier | منخفض | متوسط | ضغط client-side قبل الرفع (max 800x800) |
| Bot signups | متوسط | متوسط | Supabase Captcha integration (Phase 2 لو احتاج) |
| RLS misconfiguration → data leak | منخفض | عالي جداً | Comprehensive RLS tests + code review |

---

## References

- [Supabase Flutter docs](https://supabase.com/docs/reference/dart/initializing)
- [flutter_bloc patterns](https://bloclibrary.dev/architecture/)
- [WASALNI Constitution](../../.specify/memory/constitution.md)
- [Feature Spec](./spec.md)
