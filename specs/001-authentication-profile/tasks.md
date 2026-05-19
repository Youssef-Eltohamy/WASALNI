---
description: "Task breakdown for Authentication & User Profile implementation"
---

# Tasks: Authentication & User Profile

**Input**: Design documents from `specs/001-authentication-profile/`

**Prerequisites**: spec.md ✅, plan.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Bloc tests + Validator tests مطلوبة (متفق عليه في research.md R-10).

**Organization**: Tasks مقسّمة على Phases، وداخل كل Phase حسب User Story، ليمكن تنفيذ كل user story مستقلاً.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: يمكن تشغيله بالتوازي (ملفات مختلفة، بدون dependencies)
- **[Story]**: USx = أي user story (من spec.md)
- المسارات نسبية لـ `D:\programing\wasalni\`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: تجهيز التطبيق الأساسي + dependencies

- [ ] **T001** تحديث `apps/mobile/pubspec.yaml` بإضافة الـ dependencies الجديدة:
  - `flutter_bloc: ^9.0.0`, `bloc: ^9.0.0`, `equatable: ^2.0.7`
  - `formz: ^0.0.5`
  - `go_router: ^17.0.0`
  - `app_links: ^6.4.1`
  - `image_picker: ^1.1.2`, `image: ^4.6.0`
  - `flutter_secure_storage: ^9.2.4`
  - dev: `bloc_test: ^9.1.7`, `mocktail: ^1.0.4`
  ثم `flutter pub get`

- [ ] **T002** [P] إنشاء `apps/mobile/lib/core/theme/app_colors.dart` بألوان WASALNI (Primary: `#1B998B`, الأساسي + الثانوي + الأخطاء)

- [ ] **T003** [P] إنشاء `apps/mobile/lib/core/theme/app_theme.dart` بـ Material 3 + Cairo font + RTL

- [ ] **T004** [P] إنشاء `apps/mobile/lib/core/constants/governorates.dart` بقائمة الـ 27 محافظة (`Governorate` class مع `code` و `nameAr`)

- [ ] **T005** [P] إنشاء `apps/mobile/lib/core/routing/route_paths.dart` (ثوابت المسارات: `/splash`, `/feed`, `/signup`, `/signin`, `/profile/setup`, `/profile/me`, `/profile/edit`, `/forgot-password`, `/reset-password`)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: البنية التحتية المشتركة لكل الـ user stories

**⚠️ CRITICAL**: لا يبدأ أي user story قبل اكتمال هذه الـ phase

### Database & Backend

- [ ] **T006** كتابة `supabase/migrations/20260519XXXXXX_auth_profiles.sql` بناءً على `data-model.md` (CREATE TABLE profiles + indexes + trigger + RLS policies + avatars bucket + storage policies)

- [ ] **T007** ربط Supabase CLI بالمشروع: `supabase login` ثم `supabase link --project-ref nseuurovkxymrwxamftz`

- [ ] **T008** تطبيق الـ migration: `supabase db push` (ومراجعة في Dashboard إن `profiles` table و `avatars` bucket اتعملوا)

- [ ] **T009** [P] في Supabase Dashboard → Authentication → URL Configuration: إضافة Redirect URLs:
  - `wasalni://auth/confirm`
  - `wasalni://auth/reset-password`

### Core Utilities

- [ ] **T010** [P] إنشاء `apps/mobile/lib/core/network/supabase_client.dart` (singleton init من `.env`)

- [ ] **T011** [P] إنشاء `apps/mobile/lib/core/storage/secure_storage_service.dart` (wrapper للـ `flutter_secure_storage`)

- [ ] **T012** [P] إنشاء `apps/mobile/lib/core/errors/failures.dart` (Failure abstract + AuthFailure + ProfileFailure + NetworkFailure + UnknownFailure)

- [ ] **T013** [P] إنشاء `apps/mobile/lib/core/errors/error_mapper.dart` (يحول Supabase errors لـ Failure بـ Arabic messages)

- [ ] **T014** [P] إنشاء `apps/mobile/lib/core/validators/email_validator.dart` (formz input مع `EmailValidationError`)

- [ ] **T015** [P] إنشاء `apps/mobile/lib/core/validators/password_validator.dart` (≥8، حرف كبير + رقم)

- [ ] **T016** [P] إنشاء `apps/mobile/lib/core/validators/phone_validator.dart` (مصري `+201XXXXXXXXX` + normalize utility)

- [ ] **T017** [P] إنشاء `apps/mobile/lib/core/validators/required_text_validator.dart` (trim + min length parameter)

### Reusable Widgets

- [ ] **T018** [P] إنشاء `apps/mobile/lib/core/widgets/primary_button.dart` (مع loading state)

- [ ] **T019** [P] إنشاء `apps/mobile/lib/core/widgets/app_text_field.dart` (مع label + error + obscure للباسورد)

### Routing & App Shell

- [ ] **T020** إنشاء `apps/mobile/lib/core/routing/app_router.dart` (`go_router` config مع كل الـ routes — placeholder pages مؤقتاً)

- [ ] **T021** تحديث `apps/mobile/lib/main.dart` لتهيئة Supabase + dotenv قبل `runApp`

- [ ] **T022** إنشاء `apps/mobile/lib/app.dart` (MaterialApp.router مع AppTheme و locale ar_EG)

### Validator Tests

- [ ] **T023** [P] [Setup] `apps/mobile/test/core/validators/email_validator_test.dart`

- [ ] **T024** [P] [Setup] `apps/mobile/test/core/validators/password_validator_test.dart`

- [ ] **T025** [P] [Setup] `apps/mobile/test/core/validators/phone_validator_test.dart` (مهم: الـ normalize logic)

**Checkpoint**: البنية التحتية جاهزة. أي user story يمكن أن يبدأ.

---

## Phase 3: User Story 2 — Signup + Profile Setup (Priority: P1) 🎯 MVP

> **ملحوظة:** بدأت بـ US2 (مش US1) لأنها تنشئ معظم البنية التحتية للـ Auth. US1 (Guest) عملياً يكون ready بعدها بـ task واحد.

**Goal**: المستخدم يقدر ينشئ حساب → يأكد إيميله → يكمل بروفايله → يدخل الـ Feed.

**Independent Test**: تنفيذ Test 2 في `quickstart.md`.

### Domain & Data Layer

- [ ] **T026** [P] [US2] إنشاء `apps/mobile/lib/features/auth/domain/entities/auth_user.dart` (entity مستقل عن Supabase)

- [ ] **T027** [P] [US2] إنشاء `apps/mobile/lib/features/auth/data/models/auth_user_model.dart` (يحول من Supabase User)

- [ ] **T028** [US2] إنشاء `apps/mobile/lib/features/auth/data/repositories/auth_repository.dart` مع:
  - `Future<Either<Failure, AuthUser>> signUp(email, password)`
  - `Stream<AuthUser?> authStateChanges`
  - `Future<Either<Failure, void>> resendConfirmation(email)`

- [ ] **T029** [P] [US2] إنشاء `apps/mobile/lib/features/profile/domain/entities/profile.dart`

- [ ] **T030** [P] [US2] إنشاء `apps/mobile/lib/features/profile/data/models/profile_model.dart`

- [ ] **T031** [US2] إنشاء `apps/mobile/lib/features/profile/data/repositories/profile_repository.dart` مع:
  - `Future<Either<Failure, Profile>> createProfile(profileData)`
  - `Future<Either<Failure, Profile?>> getProfile(userId)`

### Auth Bloc

- [ ] **T032** [US2] إنشاء `apps/mobile/lib/features/auth/presentation/bloc/auth_event.dart` (`AppStarted`, `SignupRequested`, `EmailConfirmed`, `ResendConfirmationRequested`)

- [ ] **T033** [US2] إنشاء `apps/mobile/lib/features/auth/presentation/bloc/auth_state.dart` (`Unknown`, `Unauthenticated`, `AwaitingEmailConfirmation`, `AuthenticatedNoProfile`, `Authenticated`, `Loading`, `Failure`)

- [ ] **T034** [US2] إنشاء `apps/mobile/lib/features/auth/presentation/bloc/auth_bloc.dart` (يستمع لـ `authStateChanges` + يعالج الـ events)

### Signup Form Cubit

- [ ] **T035** [P] [US2] إنشاء `apps/mobile/lib/features/auth/presentation/cubit/signup_form/signup_form_state.dart` (مع formz inputs: Email, Password, ConfirmPassword, TermsAccepted)

- [ ] **T036** [US2] إنشاء `apps/mobile/lib/features/auth/presentation/cubit/signup_form/signup_form_cubit.dart`

### Profile Bloc + Form Cubit

- [ ] **T037** [P] [US2] إنشاء `apps/mobile/lib/features/profile/presentation/bloc/profile_event.dart` (`LoadProfile`, `CreateProfileRequested`)

- [ ] **T038** [P] [US2] إنشاء `apps/mobile/lib/features/profile/presentation/bloc/profile_state.dart` (`Initial`, `Loading`, `Loaded(profile)`, `NotFound`, `Error(failure)`)

- [ ] **T039** [US2] إنشاء `apps/mobile/lib/features/profile/presentation/bloc/profile_bloc.dart`

- [ ] **T040** [P] [US2] إنشاء `apps/mobile/lib/features/profile/presentation/cubit/profile_form/profile_form_state.dart` (formz: FullName, Phone, Governorate, CityOrVillage + اختياري: AvatarFile, BirthDate)

- [ ] **T041** [US2] إنشاء `apps/mobile/lib/features/profile/presentation/cubit/profile_form/profile_form_cubit.dart`

### UI Pages

- [ ] **T042** [US2] إنشاء `apps/mobile/lib/features/auth/presentation/pages/signup_page.dart` (مع TermsCheckbox + ربط بـ SignupFormCubit)

- [ ] **T043** [P] [US2] إنشاء `apps/mobile/lib/features/auth/presentation/widgets/terms_checkbox.dart`

- [ ] **T044** [US2] إنشاء `apps/mobile/lib/features/auth/presentation/pages/email_confirmation_page.dart` (مع "إعادة إرسال" + عداد الأيام المتبقية)

- [ ] **T045** [US2] إنشاء `apps/mobile/lib/features/profile/presentation/pages/profile_setup_page.dart` (الـ form الكاملة)

- [ ] **T046** [P] [US2] إنشاء `apps/mobile/lib/features/profile/presentation/widgets/governorate_dropdown.dart`

### Navigation

- [ ] **T047** [US2] تحديث `app_router.dart` لربط Signup → EmailConfirmation → ProfileSetup → Feed بناءً على `AuthState`

### Deep Link Handling

- [ ] **T048** [US2] إنشاء `apps/mobile/lib/core/routing/deep_link_handler.dart` (يستخدم `app_links` لاستقبال `wasalni://auth/confirm`)

- [ ] **T049** [US2] تهيئة Deep Links في:
  - iOS: `apps/mobile/ios/Runner/Info.plist` (Custom URL Scheme: `wasalni`)
  - Android: `apps/mobile/android/app/src/main/AndroidManifest.xml` (Intent filter)

### Tests

- [ ] **T050** [P] [US2] `apps/mobile/test/features/auth/data/repositories/auth_repository_test.dart` (mock Supabase)

- [ ] **T051** [P] [US2] `apps/mobile/test/features/auth/presentation/bloc/auth_bloc_test.dart`

- [ ] **T052** [P] [US2] `apps/mobile/test/features/profile/presentation/bloc/profile_bloc_test.dart`

**Checkpoint US2**: ✅ مستخدم يقدر يسجل، يأكد إيميل، يكمل بروفايل، يدخل الـ Feed. (راجع Test 2 في quickstart.md)

---

## Phase 4: User Story 3 — Signin (Priority: P1) 🎯 MVP

**Goal**: مستخدم موجود يقدر يدخل بإيميل + كلمة سر.

**Independent Test**: تنفيذ Test 3 في `quickstart.md`.

- [ ] **T053** [US3] إضافة `signIn(email, password)` و `signOut()` في `auth_repository.dart`

- [ ] **T054** [US3] إضافة event `SigninRequested` + state transitions في `AuthBloc`

- [ ] **T055** [P] [US3] إنشاء `apps/mobile/lib/features/auth/presentation/cubit/signin_form/signin_form_state.dart`

- [ ] **T056** [US3] إنشاء `apps/mobile/lib/features/auth/presentation/cubit/signin_form/signin_form_cubit.dart`

- [ ] **T057** [US3] إنشاء `apps/mobile/lib/features/auth/presentation/pages/signin_page.dart` (مع "نسيت كلمة السر" link)

- [ ] **T058** [US3] التعامل مع حالة "Email not confirmed" في الـ signin (توجيه لـ EmailConfirmationPage)

- [ ] **T059** [P] [US3] تحديث `auth_bloc_test.dart` لتشمل signin scenarios

**Checkpoint US3**: ✅ المستخدمون العائدون يدخلون بحساباتهم.

---

## Phase 5: User Story 1 — Guest Browsing (Priority: P1) 🎯 MVP

**Goal**: التطبيق يفتح مباشرة على Feed بدون إجبار على تسجيل. لما المستخدم يحاول action محتاج auth → modal.

**Independent Test**: تنفيذ Test 1 في `quickstart.md`.

- [ ] **T060** [US1] إنشاء `apps/mobile/lib/features/feed/presentation/pages/feed_placeholder_page.dart` (placeholder للـ Feed — هينُفّذ في Spec 5)

- [ ] **T061** [US1] إنشاء `apps/mobile/lib/features/auth/presentation/pages/splash_page.dart` (يفحص AuthState ويوجّه)

- [ ] **T062** [US1] تحديث `app_router.dart` ليبدأ من Splash → Feed (Guest) بدلاً من Splash → Login

- [ ] **T063** [P] [US1] إنشاء `apps/mobile/lib/features/auth/presentation/widgets/auth_required_modal.dart` (يظهر لما Guest يحاول action محتاج auth)

**Checkpoint US1**: ✅ Guest يقدر يتصفح، Modal يظهر عند actions محتاجة auth.

**🎯 MVP Milestone: P1 User Stories مكتملة.**

---

## Phase 6: User Story 5 — Signout (Priority: P2)

**Goal**: المستخدم يقدر يخرج من حسابه.

**Independent Test**: تنفيذ Test 5 في `quickstart.md`.

- [ ] **T064** [US5] إضافة event `SignoutRequested` في `AuthBloc`

- [ ] **T065** [US5] إنشاء `apps/mobile/lib/features/profile/presentation/pages/my_account_page.dart` (يعرض البروفايل + زر "تسجيل خروج")

- [ ] **T066** [P] [US5] إنشاء `apps/mobile/lib/core/widgets/confirmation_dialog.dart` (reusable)

- [ ] **T067** [P] [US5] تحديث `auth_bloc_test.dart` لتشمل signout scenarios

**Checkpoint US5**: ✅ المستخدم يخرج بنجاح، الـ session تتمسح، يعود Guest.

---

## Phase 7: User Story 4 — Reset Password (Priority: P2)

**Goal**: استعادة كلمة السر عبر إيميل.

**Independent Test**: تنفيذ Test 4 في `quickstart.md`.

- [ ] **T068** [US4] إضافة `resetPasswordForEmail(email)` و `updatePassword(newPassword)` في `auth_repository.dart`

- [ ] **T069** [P] [US4] إنشاء `apps/mobile/lib/features/auth/presentation/cubit/forgot_password_form/forgot_password_form_cubit.dart`

- [ ] **T070** [US4] إنشاء `apps/mobile/lib/features/auth/presentation/pages/forgot_password_page.dart`

- [ ] **T071** [P] [US4] إنشاء `apps/mobile/lib/features/auth/presentation/cubit/reset_password_form/reset_password_form_cubit.dart`

- [ ] **T072** [US4] إنشاء `apps/mobile/lib/features/auth/presentation/pages/reset_password_page.dart`

- [ ] **T073** [US4] تحديث `deep_link_handler.dart` لاستقبال `wasalni://auth/reset-password` وتوجيه المستخدم

- [ ] **T074** [P] [US4] tests للـ ForgotPassword و ResetPassword cubits

**Checkpoint US4**: ✅ المستخدم يقدر يستعيد كلمة السر بنجاح.

---

## Phase 8: User Story 6 — Edit Profile (Priority: P3)

**Goal**: تعديل بيانات البروفايل + الصورة.

**Independent Test**: تنفيذ Test 6 في `quickstart.md`.

- [ ] **T075** [US6] إضافة `updateProfile(updates)` و `uploadAvatar(file)` في `profile_repository.dart`

- [ ] **T076** [P] [US6] إنشاء `apps/mobile/lib/core/utils/image_compressor.dart` (max 800x800, JPEG quality 85)

- [ ] **T077** [P] [US6] إنشاء `apps/mobile/lib/features/profile/presentation/widgets/avatar_picker.dart` (يستخدم image_picker + compressor)

- [ ] **T078** [US6] إضافة event `UpdateProfileRequested` في `ProfileBloc`

- [ ] **T079** [US6] إنشاء `apps/mobile/lib/features/profile/presentation/pages/edit_profile_page.dart` (نفس الـ form بس بـ partial update logic)

- [ ] **T080** [P] [US6] tests للـ ProfileBloc.update + image_compressor unit test

**Checkpoint US6**: ✅ المستخدم يقدر يعدّل كل حقول بروفايله ويرفع صورة.

---

## Phase 9: Polish & Cross-Cutting

**Purpose**: تحسينات تخص كل الـ stories

- [ ] **T081** [Polish] إنشاء `apps/mobile/lib/features/auth/presentation/widgets/email_confirmation_banner.dart` (FR-010c — يظهر للمستخدم اللي مأكدش، مع عدّاد الأيام المتبقية)

- [ ] **T082** [Polish] دمج الـ banner في `feed_placeholder_page` (يظهر فقط لو `AuthState.AwaitingEmailConfirmation`)

- [ ] **T083** [Polish] إنشاء `supabase/migrations/20260519YYYYYY_unconfirmed_cleanup.sql` (function + pg_cron schedule لحذف الحسابات بعد 7 أيام — FR-010b)

- [ ] **T084** [Polish] تطبيق الـ migration الجديدة على Supabase

- [ ] **T085** [Polish] التعامل مع Rate Limiting في الـ UI (لو 429 من Supabase → عداد 60 ثانية، الزر معطّل أثناء الانتظار)

- [ ] **T086** [P] [Polish] إنشاء صفحات placeholder للشروط والخصوصية:
  - `apps/mobile/lib/features/legal/presentation/pages/terms_page.dart`
  - `apps/mobile/lib/features/legal/presentation/pages/privacy_page.dart`

- [ ] **T087** [Polish] ربط الـ Terms checkbox بصفحات الشروط (روابط فيها)

- [ ] **T088** [Polish] `flutter analyze` بدون warnings

- [ ] **T089** [Polish] `flutter test` كل الـ tests خضراء

- [ ] **T090** [Polish] تنفيذ كل الـ 9 tests في `quickstart.md` يدوياً وتحديث الـ checkboxes

- [ ] **T091** [Polish] تحديث `README.md` الرئيسي لذكر إن Spec 1 مكتمل

- [ ] **T092** [Polish] merge الـ branch `001-authentication-profile` على main عبر PR على GitHub

**Checkpoint Polish**: ✅ كل الـ acceptance gates من plan.md متحققة.

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1 (Setup)
   ↓
Phase 2 (Foundational)  ← BLOCKING
   ↓
Phase 3 (US2 - Signup + Profile)  ← المسار الأساسي
   ↓
Phase 4 (US3 - Signin)             ← يعتمد على AuthBloc من US2
   ↓
Phase 5 (US1 - Guest browsing)     ← يحتاج Splash + Feed placeholder
   ↓
🎯 MVP P1 MILESTONE
   ↓
Phase 6 (US5 - Signout)            ← يعتمد على AuthBloc
   ↓
Phase 7 (US4 - Reset password)     ← features منفصلة
   ↓
Phase 8 (US6 - Edit profile)
   ↓
Phase 9 (Polish)
```

### Critical Path

T001 → T006 → T007 → T008 → T020 → T021 → T022 → (Phase 3 tasks) → ... → T091

---

## Parallel Execution Opportunities

### في Phase 1 (Setup):
T002, T003, T004, T005 يمكن أن يعملوا في نفس الوقت (ملفات مختلفة).

### في Phase 2 (Foundational):
- T010-T019 كلهم [P] (utilities وwidgets منفصلين)
- T023-T025 [P] (Validator tests)

### في Phase 3 (US2):
- T026 + T029 (entities) متوازين
- T027 + T030 (models) متوازين
- T035, T037, T038, T040 (forms & states) متوازين
- T043, T046 (widgets) متوازين
- T050, T051, T052 (tests) متوازين

### في الـ Phases الأخرى:
- كل [P] tasks في كل phase يمكن تنفيذها في نفس الوقت

---

## Implementation Strategy: MVP First

### الأسبوع الأول: P1 (الأساسي)
1. ✅ Phase 1: Setup
2. ✅ Phase 2: Foundational
3. ✅ Phase 3: US2 (Signup + Profile Setup)
4. ✅ Phase 4: US3 (Signin)
5. ✅ Phase 5: US1 (Guest browsing)
6. 🛑 **STOP** — اختبار manual لكل P1 stories من quickstart.md
7. 🎉 **MVP P1 جاهز للنشر التجريبي**

### الأسبوع الثاني: P2 + P3
8. Phase 6: US5 (Signout)
9. Phase 7: US4 (Reset password)
10. Phase 8: US6 (Edit profile)

### الأسبوع الثالث: Polish + Merge
11. Phase 9: Polish (banner, terms, rate limiting, إلخ)
12. PR إلى main

---

## Notes

- **[P]** = ملفات مختلفة، آمن للتشغيل بالتوازي.
- **[USx]** = ربط الـ task بقصة محددة من الـ spec.
- **Commit بعد كل task** (أو مجموعة منطقية) عشان نقدر نرجع لو في مشكلة.
- **اختبر بعد كل Phase** بـ quickstart.md قبل ما تكمل.
- **إجمالي عدد الـ tasks**: 92 task.
- **التقدير الزمني**: 3 أسابيع لمطوّر solo (Phase 1-9).

---

## Summary

| Phase | Tasks | Goal | Priority |
|-------|-------|------|----------|
| 1. Setup | T001-T005 | Dependencies + Theme + Routes | Blocking |
| 2. Foundational | T006-T025 | DB + Core utilities + Tests | Blocking |
| 3. US2 (Signup) | T026-T052 | Sign up + Profile Setup flow | P1 🎯 |
| 4. US3 (Signin) | T053-T059 | Login flow | P1 🎯 |
| 5. US1 (Guest) | T060-T063 | Guest browsing + Auth modal | P1 🎯 |
| 6. US5 (Signout) | T064-T067 | Logout | P2 |
| 7. US4 (Reset) | T068-T074 | Password reset | P2 |
| 8. US6 (Edit) | T075-T080 | Edit profile + Avatar | P3 |
| 9. Polish | T081-T092 | Banner, terms, cleanup, QA | All |

**🎯 MVP Acceptance**: Tasks T001-T063 مكتملة + quickstart Tests 1, 2, 3 ناجحة.
