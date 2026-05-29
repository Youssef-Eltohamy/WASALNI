# WASALNI — تصميم معمارية الواجهة (Frontend Architecture)

> **التاريخ:** 2026-05-29
> **الفرع:** `002-rebuild-from-zero`
> **الحالة:** متفق عليه (design approved) — جاهز للانتقال لخطة التنفيذ
> **المراجع:** `return_to_zero/02_final_scope.md` (الـ scope)، `return_to_zero/design_system.md` (الهوية)، `return_to_zero/قرارات_قاعدة_البيانات.docx` (الـ schema)، `return_to_zero/مناهج_بناء_الفرونت.docx` (مناهج البناء)

---

## 1. الهدف والنطاق

نبني **واجهة تطبيق WASALNI كاملة في Flutter (موبايل فقط)** معتمدة على **بيانات وهمية (mock data)**، قبل أي شغل في الباك إند. لما الـ UI يكتمل ويبقى قابل للتنقّل بالكامل، نستخرج المواصفات الدقيقة من الشاشات الفعلية، نثبّت الـ schema، نكتب الـ migration، وبعدها نبدّل الـ mock بـ Supabase.

**داخل النطاق:** تطبيق Flutter (كل الشاشات الـ18 + الـ bottom nav).
**خارج النطاق (لاحقاً):** تثبيت الـ schema، الـ migration، تبديل mock ← Supabase، صفحات الويب (Next.js)، الـ admin dashboard، الـ auth الحقيقي (OTP)، أي تكامل خارجي.

---

## 2. القرارات المحسومة

| البند | القرار | السبب |
|---|---|---|
| النطاق | موبايل Flutter فقط | التطبيق هو المنتج الأساسي؛ تركيز أعلى |
| منهج البناء | **هجين** | يثبت المعمارية على شاشة واحدة قبل التوسّع، ويوصل لـUI كامل أسرع وأنضف |
| State management | `flutter_bloc` | تفضيل المستخدم المعروف |
| Navigation | `go_router` + ShellRoute | شِل الـ4 تابات + مسارات تفصيلية |
| Dependency Injection | `get_it` | نقطة تبديل mock ↔ supabase |
| Models | `freezed` + `json_serializable` | أقل بويلربليت، unions لـ Bloc states، جاهز للـ JSON بعدين |
| الخط | **Cairo** مبنْدل في الأصول | offline وأوثق من google_fonts |
| Mock data | واقعية (كفر المقدام / تفهنا) | مراجعة UI ذات معنى + بذرة للـ DB لاحقاً |

---

## 3. المعمارية

### 3.1 الباكدجات المضافة
- `flutter_bloc`, `go_router`, `get_it`
- `freezed_annotation`, `json_annotation` (runtime) + `freezed`, `json_serializable`, `build_runner` (dev)
- `cached_network_image`, `flutter_svg`
- الموجود مسبقاً: `supabase_flutter`, `flutter_dotenv`, `intl`, `flutter_localizations` (الـ supabase مايتفعّلش غير في مرحلة الباك)

### 3.2 هيكل المجلدات (feature-first)
```
lib/
  main.dart                  # bootstrap: init DI, runApp
  app/
    app.dart                 # MaterialApp.router + theme + locale + RTL
    router.dart              # go_router config (ShellRoute + routes)
    di.dart                  # get_it registrations (نقطة تبديل mock/supabase)
  core/
    theme/
      app_colors.dart        # palette من design_system
      app_spacing.dart       # مسافات/أنصاف أقطار
      app_text_styles.dart   # Cairo، min 14sp
      app_theme.dart         # ThemeData مركّب من التوكنز
    widgets/                 # widgets مشتركة: أزرار، بادجات، حالات (loading/empty/error)، كروت أساس
    utils/                   # helpers (تنسيق سعر، واتساب deep-link، إلخ)
    constants/
  data/
    models/                  # Listing, ShopDetails, TransportDetails, Product,
                             # Village, Category, Profile, OrderIntent, Favorite (freezed)
    repositories/
      listing_repository.dart        # abstract interface
      category_repository.dart       # abstract
      ...                            # باقي الـ interfaces
      mock/
        mock_listing_repository.dart # implements ListingRepository
        ...
    mock_data/               # fixtures واقعية (Dart) + روابط صور
  features/
    feed/        { bloc/  view/  widgets/ }
    categories/  { ... }
    search/      { ... }
    listing_detail/ { ... }   # بروفايل مقدم خدمة/محل/سائق + صفحة منتج
    cart/        { ... }
    auth/        { ... }      # واجهات OTP/استكمال بروفايل (mock flow)
    account/     { ... }
    favorites/   { ... }
    onboarding/  { ... }      # اختيار القرية
```

### 3.3 تدفق البيانات (layered)
```
Model  ←  Repository (interface)  ←  Mock impl  ←  Bloc  ←  Screen (Widget)  ←  Theme
```
- الشاشات لا تعرف مصدر البيانات؛ بتتعامل مع الـ Bloc بس.
- الـ Bloc بيعتمد على **الـ interface المجرّد** للـ repository، مش التنفيذ.

### 3.4 آلية تبديل mock ↔ Supabase (العمود الفقري)
```dart
abstract class ListingRepository {
  Future<List<Listing>> getFeed({required String villageId, ListingKind? kind});
  Future<Listing> getById(String id);
}

class MockListingRepository implements ListingRepository { /* بيانات في الذاكرة + تأخير */ }
// لاحقاً:
class SupabaseListingRepository implements ListingRepository { /* استعلامات Supabase */ }
```
في `di.dart`:
```dart
getIt.registerLazySingleton<ListingRepository>(() => MockListingRepository());
// التبديل لاحقاً = تغيير السطر ده فقط. الـ Bloc والـ UI ما بيتلمسوش.
```

---

## 4. الـ Models (مرآة لمسودة الـ schema)

تتبع نمط **supertype/subtype** المتفق عليه:
- `Listing` — الأساس المشترك (id, kind, ownerId, villageId, categoryId, name, bio, phones, lat/lng, workingHours, logoUrl, status, isVerified, isFeatured, plan...)
- `ShopDetails` — (coverUrl, hasDelivery, deliveryFee) — مرتبطة بـ listing نوعها shop
- `TransportDetails` — (vehicleType, serviceArea) — لنوع transport
- `Product`, `Village`, `Category`, `Profile`, `OrderIntent`, `Favorite`
- `ListingKind` enum: `service | shop | transport`؛ و enums للحالة والخطة.

كلها `freezed` (immutable + copyWith + equality + `fromJson/toJson`). الـ JSON بيتفعّل فعلياً وقت ربط Supabase.

---

## 5. الهوية والـ Theme

- مصدر التوكنز الوحيد = `return_to_zero/design_system.md`.
- **Palette:** Primary `#0D5C75`، Primary Dark `#082F3D`، Accent `#FF7A45`، WhatsApp `#25D366`، BG `#F4F8FA`، Text `#15252E`، Success `#2E9E5B`، Verified `#1B4965`.
- **الخط:** Cairo، مفيش أصغر من 14sp.
- **RTL إجباري:** `EdgeInsetsDirectional` في كل مكان، locale `ar-EG` (موجود).
- `app_theme.dart` بيبني `ThemeData` Material3 من التوكنز دي (بدل الـ seed color القديم `#1B998B` المؤقت).

---

## 6. الـ Navigation

- `go_router` مع `ShellRoute` للـ **bottom nav بـ4 تابات:** الرئيسية / التصنيفات / المفضلة / حسابي.
- مسارات مدفوعة (pushed) خارج الشِل: تفاصيل listing، صفحة منتج، السلة، تأكيد الطلب، auth (OTP/استكمال)، onboarding، الإعدادات.
- السلة = أيقونة في الـ app bar (مش تاب).

---

## 7. جرد الشاشات (18)

**الاكتشاف:** الرئيسية (Feed: جريد عمودين + تاب خريطة) • التصنيفات • البحث • فلتر القرية
**البروفايلات:** مقدم خدمة (بورتفوليو) • محل (منتجات + توصيل) • منتج • سائق نقل
**السلة:** السلة • تأكيد الطلب ← واتساب
**الحساب/الدخول:** onboarding/اختيار القرية • موبايل + OTP • استكمال البروفايل • حسابي • المفضلة
**تسجيل النشاط:** سجّل نشاطك (إنشاء listing) • رفع التوثيق
**متفرقات:** الإعدادات/الشروط/الخصوصية

---

## 8. حالات الـ UI ومعالجة الأخطاء

- كل feature Bloc بيعرّف حالات موحّدة: `Loading | Loaded | Empty | Error` (عبر freezed unions).
- widgets مشتركة في `core/widgets/`: `LoadingView`, `EmptyView`, `ErrorView` (بنبرة عامية مصرية ودودة + زر إعادة محاولة).
- الـ Mock repos بتقدر تحاكي تأخير وأخطاء عشان نختبر الحالات دي.

---

## 9. الـ Mock data

- بيانات واقعية من كفر المقدام/تفهنا: فئات حقيقية (سباكة، كهرباء، صيدلية، بقالة، تكاتك...)، أسماء محلات/حرفيين/سواقين معقولين، منتجات بأسعار بالجنيه، قريتين.
- مكتوبة كـ Dart fixtures في `data/mock_data/`، تتحوّل لـ models.
- مصمّمة عشان **تبذر الـ DB الحقيقية لاحقاً** (نفس البنية).

---

## 10. خطة المراحل (الهجين)

1. **الأساس:** الباكدجات + build_runner + theme/tokens + Cairo + هيكل المجلدات + DI + go_router shell (4 تابات) + repository interfaces + mock infra + models (freezed) + بيانات واقعية + widgets الحالات.
2. **الرئيسية (شريحة رأسية):** `FeedBloc` + `MockListingRepository` + جريد/كروت listing + فلتر القرية + تاب خريطة (stub) + كل الحالات + تلميع بالهوية. **هدفها إثبات النمط الكامل.**
3. **التوسّع:** باقي الـ17 شاشة بإعادة استخدام النمط والكومبوننتس المثبَّتة.
4. **مشية كاملة + تلميع نهائي:** تنقّل شامل، إصلاح التدفق/الـ IA، إقفال.

---

## 11. الاختبار

- **Bloc tests** لكل Bloc (الـ FeedBloc أولاً): الانتقالات بين الحالات مع mock repo.
- **Widget tests** للكومبوننتس المشتركة (الكروت، الحالات).
- **flutter analyze** نظيف كشرط لكل مرحلة.
- (Golden tests اختيارية للكروت في مرحلة التلميع.)

---

## 12. معايير النجاح

- التطبيق كله قابل للتنقّل (الـ18 شاشة) بـ mock data واقعية، بهوية WASALNI الكاملة، RTL سليم.
- التبديل لـ Supabase = تغيير تسجيلات `di.dart` فقط (الـ UI/Bloc لا يتغيّروا).
- الـ models تطابق مسودة الـ schema (supertype/subtype) وجاهزة للـ JSON.
- `flutter analyze` نظيف + اختبارات الـ FeedBloc والكومبوننتس المشتركة تعدّي.
