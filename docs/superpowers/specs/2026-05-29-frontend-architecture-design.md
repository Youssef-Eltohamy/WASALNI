# WASALNI — تصميم معمارية الواجهة (Frontend Architecture)

> **التاريخ:** 2026-05-29
> **الفرع:** `002-rebuild-from-zero`
> **الحالة:** متفق عليه + مُكمَّل بدراسة فجوات (3 personas) — جاهز للانتقال لخطة التنفيذ
> **المراجع:** `return_to_zero/02_final_scope.md` (الـ scope)، `return_to_zero/design_system.md` (الهوية)، `return_to_zero/03_field_team_playbook.md` (الفريق الميداني)، `return_to_zero/قرارات_قاعدة_البيانات.docx` (الـ schema)، `return_to_zero/مناهج_بناء_الفرونت.docx` (مناهج البناء)

---

## 1. الهدف والنطاق

نبني **واجهة تطبيق WASALNI كاملة في Flutter (موبايل فقط)** معتمدة على **بيانات وهمية (mock data)**، قبل أي شغل في الباك إند. لما الـ UI يكتمل ويبقى قابل للتنقّل بالكامل، نستخرج المواصفات الدقيقة من الشاشات الفعلية، نثبّت الـ schema، نكتب الـ migration، وبعدها نبدّل الـ mock بـ Supabase.

**داخل النطاق:** تطبيق Flutter (كل الشاشات + الحالات + الـ bottom nav).
**خارج النطاق (لاحقاً):** تثبيت الـ schema، الـ migration، تبديل mock ← Supabase، صفحات الويب (Next.js)، الـ admin dashboard، الـ auth الحقيقي (OTP server)، أي تكامل خارجي (بوابات دفع، SMS gateway).

> ملاحظة منهجية: الواجهة بـ mock data، لكننا **نصمّم سلوك كل الحالات دلوقتي** (offline, أذونات, دورة حياة الكيان...) عشان النمط يكون مثبَّت قبل ربط الباك. الـ mock repositories بتحاكي التأخير والأخطاء وعدم الاتصال.

---

## 2. القرارات المحسومة

| البند | القرار | السبب |
|---|---|---|
| النطاق | موبايل Flutter فقط | التطبيق هو المنتج الأساسي |
| منهج البناء | **هجين** | يثبت المعمارية على شاشة واحدة قبل التوسّع |
| State management | `flutter_bloc` | تفضيل المستخدم |
| Navigation | `go_router` + ShellRoute | شِل الـ4 تابات + redirect/deep-links |
| DI | `get_it` | نقطة تبديل mock ↔ supabase |
| Models | `freezed` (json_serializable مؤجّل للباك) | unions للحالات؛ JSON يتضاف وقت ربط Supabase (تعارض حالي مع bloc_test + مش محتاجينه في الـ mock) |
| الخط | **Cairo** مبنْدل | offline وأوثق |
| Mock data | واقعية (كفر المقدام / تفهنا) | مراجعة UI ذات معنى + بذرة للـ DB |
| **نموذج التسجيل** | **Self-signup + مساعدة الفريق الميداني، والكل يروح للسوبر أدمن يوافق/يرفض** | الفريق بيساعد على الأرض لكن نفس واجهة الـ self-signup؛ مفيش flow "claim" منفصل |
| **الـ Soft Cart** | **سلة لكل محل + سلة نهائية تجمّع السلل، وزر "أرسل" منفصل لكل سلة محل (مفيش إرسال جماعي)** | يطابق واتساب-لكل-محل |
| **الملكية** | **نشاط (listing) واحد لكل حساب في الـ MVP** | أبسط schema/UI؛ يُراجع في Phase 2 |

---

## 3. المعمارية

### 3.1 الباكدجات
**أساسية:** `flutter_bloc`, `go_router`, `get_it`, `freezed` (+ `build_runner`؛ `json_serializable` مؤجّل للباك)، `cached_network_image`, `flutter_svg`.
**حالات النظام (مضافة من دراسة الفجوات):**
- `connectivity_plus` — كشف الاتصال (مع فحص وصول حقيقي)
- `url_launcher` — واتساب / اتصال / خرايط / فتح الإعدادات
- `permission_handler` — أذونات الكاميرا/الجاليري/الموقع/الإشعارات
- `app_links` — استقبال الـ deep links (الويب → التطبيق)
- `flutter_image_compress` — ضغط الصور client-side قبل الرفع (≤1MB)
- `hive` / `hive_flutter` — تخزين محلي: cache آخر بيانات + **outbox queue** + مسودات (drafts)
- `package_info_plus` — رقم الإصدار (force-update/maintenance gate)
- `geolocator` — *(اختياري، مؤجّل)* للمسافة/الخريطة؛ اختيار القرية يدوي هو الأساس
- الموجود: `supabase_flutter` (يتفعّل في مرحلة الباك), `flutter_dotenv`, `intl`, `flutter_localizations`

### 3.2 هيكل المجلدات (feature-first)
```
lib/
  main.dart                  # bootstrap: init Hive + DI, runApp
  app/
    app.dart                 # MaterialApp.router + theme + locale + RTL
    router.dart              # go_router (ShellRoute + redirect/AuthGate + deep links)
    di.dart                  # get_it (نقطة تبديل mock/supabase)
  core/
    theme/                   # app_colors, app_spacing, app_text_styles, app_theme
    widgets/                 # أزرار، بادجات، حالات (loading/empty/error/offline/skeleton)، كروت أساس
    connectivity/            # ConnectivityCubit + بانر offline
    permissions/             # priming screens + permission helpers
    network/                 # RepositoryException + سياسة timeout/retry
    format/                  # NumberFormatter (عربي/لاتيني), money, relative-time, phone(E.164)
    launch/                  # whatsapp/call/maps launchers + fallbacks
    storage/                 # cache + outbox + drafts (Hive)
    utils/ constants/
  data/
    models/                  # Listing, ShopDetails, TransportDetails, Product, Village,
                             # Category, Profile, OrderIntent, Favorite, CartLine, ShopCart,
                             # Verification, Subscription (freezed)
    repositories/            # interfaces (abstract) + mock/ + mock_data/ واقعية
  features/
    onboarding/ feed/ categories/ search/ listing_detail/ cart/
    auth/ account/ favorites/ provider_register/ verification/ subscription/
        كل feature: bloc/ + view/ + widgets/
```

### 3.3 تدفق البيانات (layered)
```
Model  ←  Repository (interface)  ←  Mock impl  ←  Bloc  ←  Screen (Widget)  ←  Theme
```
الشاشات بتتعامل مع الـ Bloc بس؛ الـ Bloc بيعتمد على الـ interface المجرّد.

### 3.4 آلية تبديل mock ↔ Supabase (العمود الفقري)
```dart
abstract class ListingRepository {
  Future<List<Listing>> getFeed({required String villageId, ListingKind? kind});
  Future<Listing> getById(String id);
}
class MockListingRepository implements ListingRepository { /* ذاكرة + تأخير + محاكاة أخطاء/offline */ }
// لاحقاً: class SupabaseListingRepository implements ListingRepository {...}
```
في `di.dart`: تسجيل التنفيذ المطلوب — **التبديل = سطر واحد**؛ الـ UI/Bloc ما بيتلمسوش.

### 3.5 عقد الأخطاء (Repository contract) — يُعرَّف من دلوقتي
```dart
sealed class RepositoryException {
  NoConnection | Timeout | ServerError | NotFound | Unauthorized
}
```
الـ mock بيرمي الأنواع دي عشان الـ UI يتبني على معالجة حقيقية قبل ربط Supabase. كل repository بيطبّق **timeout (5–8s) + retry بـ back-off** قبل ما يفشل.

---

## 4. الـ Models (مرآة لمسودة الـ schema)

نمط **supertype/subtype**:
- `Listing` (الأساس): id, kind, ownerId, villageId, categoryId, name, bio, phoneWhatsapp, phoneCall, lat/lng, addressText, workingHours, logoUrl, **status**, **isVerified**, **isFeatured**, **plan**, isTemporarilyClosed, createdAt
- `ShopDetails` (coverUrl, hasDelivery, deliveryFee) | `TransportDetails` (vehicleType, serviceArea)
- `Product` (+ isAvailable), `Village`, `Category`, `Profile`, `OrderIntent`, `Favorite`
- `CartLine` (productId, name, price, qty), `ShopCart` (shopId, lines[]) — للسلة لكل محل
- `Verification` (status, rejectReason), `Subscription` (plan, trialEndsAt, expiresAt)

**Enums:**
- `ListingKind`: `service | shop | transport`
- `ListingStatus`: `draft | pending | active | rejected | suspended | deactivated | expired`
- `VerificationStatus`: `none | pending | approved | rejected | resubmitRequested`
- `ListingPlan`: `free | prime`
- `AuthStatus` / حالات OTP (قسم 11)

كلها `freezed` (immutable + copyWith + equality). الـ `fromJson/toJson` (json_serializable) **يتضاف في مرحلة الباك** وقت ربط Supabase — مش محتاجينه في الـ mock دلوقتي.

---

## 5. الهوية والـ Theme

- مصدر التوكنز الوحيد: `return_to_zero/design_system.md`.
- **Palette:** Primary `#0D5C75`، Primary Dark `#082F3D`، Accent `#FF7A45`، WhatsApp `#25D366`، BG `#F4F8FA`، Text `#15252E`، Success `#2E9E5B`، Verified `#1B4965`.
- **الخط:** Cairo، مفيش أصغر من 14sp.
- **RTL إجباري:** `EdgeInsetsDirectional` في كل مكان، locale `ar-EG`.
- `app_theme.dart` بيبني `ThemeData` Material3 من التوكنز (بدل الـ seed المؤقت `#1B998B`).

---

## 6. الـ Navigation

- `go_router` + `ShellRoute` للـ **bottom nav بـ4 تابات:** الرئيسية / التصنيفات / المفضلة / حسابي.
- مسارات مدفوعة: تفاصيل listing، منتج، السلة، تأكيد الطلب، auth، onboarding، تسجيل نشاط، توثيق، اشتراك، الإعدادات.
- **AuthGate + redirect-after-login:** فتح شاشة محمية كـ guest → يروح للـ auth ويرجع لنفس النقطة بعد النجاح (حفظ الـ intent).
- **Deep links** (`app_links`): رابط بروفايل من الويب/مشاركة → يفتح نفس الـ listing داخل التطبيق.
- **Force-update / maintenance gate** عند الـ cold start (قبل الـ router).
- **سلوك زر الرجوع (أندرويد):** pop داخل التابات؛ double-back-to-exit على جذر التطبيق.

---

## 7. جرد الشاشات

**الاكتشاف:** الرئيسية (Feed: جريد عمودين + تاب خريطة) • التصنيفات • البحث • فلتر القرية
**البروفايلات:** مقدم خدمة (بورتفوليو) • محل (منتجات + توصيل) • منتج • سائق نقل
**السلة:** السلة (سلل لكل محل + إجمالي، وزر إرسال لكل محل) • تأكيد/تسليم واتساب
**الحساب/الدخول:** onboarding/اختيار القرية • موبايل + OTP (بحالاته) • استكمال البروفايل • حسابي • المفضلة
**العرض (المالك):** سجّل نشاطك (نموذج متعدد الخطوات + مسودة) • رفع التوثيق (بحالاته) • إدارة نشاطي (تعديل/توفر/إغلاق مؤقت/معاينة عامة) • اشتراكي + الترقية لـ Prime
**نظامية:** بوابة force-update/صيانة • شاشة "غير متاح" (listing مخفي/معلّق)
**متفرقات:** الإعدادات/الشروط/الخصوصية

> حالات OTP، تحت-المراجعة/مرفوض، offline، stale-data = **حالات داخل الشاشات** (مش شاشات مستقلة).

---

## 8. دورة حياة الكيان (Listing / Account lifecycle) — *بذرة المراجِع #2*

`ListingStatus` بسلوك معرّف لكل حالة، للمالك وللزبون:

| الحالة | عرض المالك | الظهور للزبون |
|---|---|---|
| `draft` | "أكمل تسجيل نشاطك" (مسودة auto-saved) | مخفي |
| `pending` | بانر "تحت المراجعة من الإدارة" | مخفي |
| `active` | عادي + معاينة عامة | ظاهر في feed/بحث/خريطة |
| `rejected` | بانر "اترفض" + **السبب** + زر "ارفع/عدّل وأعد التقديم" → `pending` | مخفي |
| `suspended` (أدمن) | بانر أحمر + السبب + "تواصل مع الدعم" | **مخفي** + منتجاته تختفي + يتشال من سلات المستخدمين |
| `deactivated` (المالك) | سويتش "مغلق — فعّل تاني" | مخفي |
| `expired` (اشتراك) | بانر "اشتراكك انتهى" + ترقية | ظاهر لكن **بقيود الـ free tier** (مش مخفي) |

- **التوثيق منفصل عن الحالة:** `VerificationStatus` + شارة "موثّق". الرفض بيعرض السبب + إعادة تقديم. الصور بتتحذف بعد المراجعة (المالك يعيد الرفع).
- **تعديل listing موثّق:** الحقول **الحساسة** (الاسم، الفئة) تغييرها يرجّع `isVerified=false` + `pending` (re-review)؛ الحقول الحرّة (الساعات، النبذة، الصور) تتعدّل من غير re-review.
- **الزبون على كيان مخفي** (من مفضلة/deep-link): شاشة "النشاط ده مش متاح حالياً" + إزالته بهدوء من المفضلة.
- **التمييز/التوثيق (freshness):** re-fetch عند فتح "حسابي"/البروفايل (realtime لاحقاً).

---

## 9. الاتصال والـ Offline والـ Outbox — *بذرة المراجِع #1*

- **`ConnectivityCubit` عام** فوق الـ ShellRoute → **بانر RTL ثابت** "مفيش نت" (كشف عبر `connectivity_plus` + فحص وصول حقيقي، مش مجرد وجود WiFi).
- **تمييز 3 حالات** في كل Bloc: `NoConnection` ≠ `Timeout/Slow` ≠ `ServerError` (بدل `Error` واحد). نت بطيء → "النت بطيء، بنحاول..." + auto-retry لما الاتصال يرجع.
- **Cache محلي (Hive)** لآخر feed/بروفايلات → عرضها offline مع بانر **"بيانات قديمة — اسحب للتحديث"**. سياسة حجم/إخلاء للكاش.
- **فشل تحميل صورة** (مش بس غيابها) → placeholder بأيقونة القسم.
- **Outbox queue (حرج):** الضغط على "أرسل السلة" أو تسجيل `order_intent` وهو offline → يتخزّن محلياً بـ dedupe-id ويُرسَل/يُسجَّل لما النت يرجع (ده الأساس التجاري — مينفعش يضيع). رسالة الواتساب تتولّد وتتخزّن حتى لو الإرسال متأخر.

---

## 10. الأذونات (Permissions)

- **الموقع:** اختيار القرية **يدوي** هو الأساس؛ GPS اختياري للمسافة/الخريطة فقط.
- **الكاميرا/الجاليري:** للتوثيق/البورتفوليو/المنتجات.
- **الإشعارات:** مؤجّلة (Phase 2).
- **النمط:** **priming screen بعامية** تشرح ليه قبل بوب-أب النظام؛ عند الرفض → fallback يدوي؛ عند **الحظر الدائم** → زر "افتح الإعدادات" (`permission_handler` + `openAppSettings`).

---

## 11. الـ Auth / OTP / الجلسة / دمج الـ Guest

- **حالات OTP** (في الـ auth Bloc): `idle → sending → codeSent → verifying → wrongCode / rateLimited / expired → success`. زر "ابعت تاني (00:30)" بعدّاد. **بديل WhatsApp-OTP** لو الـ SMS اتأخّر.
- **دمج بيانات الـ Guest:** السلة/المفضلة المحلية للـ guest **تُنقل (merge)** للحساب بعد نجاح OTP — متضيعش.
- **Redirect-after-login:** الرجوع لنفس النقطة (السلة/البروفايل) مش للـ feed.
- **انتهاء الجلسة وسط رفع** → حفظ مسودة محلياً قبل بوابة الدخول.
- (الـ OTP الحقيقي مؤجّل؛ النهارده mock flow بنفس الحالات.)

---

## 12. الـ Soft Cart (مفصّل)

- **سلة لكل محل** (`ShopCart` مفتاحها `shopId`).
- **شاشة السلة** = إجمالي يجمّع السلل، كل سلة محل في كرت مستقل فيه عناصره + إجماليه + **زر "أرسل السلة" خاص بيه** (يولّد رسالة واتساب لهذا المحل + يسجّل `order_intent`). **مفيش إرسال جماعي.**
- **Validation عند فتح السلة:** منتج بقى `out_of_stock` أو السعر اتغيّر → badge + تحديث الإجمالي.
- **حالة سلة فاضية** + حذف عنصر + تأكيد الحذف.
- **رقم واتساب المحل ناقص** → زر الإرسال متعطّل برسالة (مش واتساب فاضي).
- رسالة الطلب: اسم المحل + المنتجات/الكميات/الأسعار + الإجمالي + اسم المستخدم + النص الافتتاحي.

---

## 13. التسليمات الخارجية (WhatsApp / Call / Maps)

- **util موحّد** (`core/launch`):
  - **تطبيع الرقم لـ E.164** (`٠١xxxxxxxxx` → `+20xxxxxxxxxx`) لبناء `wa.me`.
  - **واتساب مش متنصّب** (`canLaunch` فشل) → fallback: نسخ الرسالة + "نزّل واتساب" + بديل SMS/اتصال.
  - **اتصال:** dialer deep-link.
  - **خرايط:** لو مفيش lat/lng → الزر متخفي؛ فشل الفتح → fallback.

---

## 14. رفع الصور والمسودات

- **لكل صورة حالة:** `queued → uploading(%) → done / failed(+retry)`. رفع **بالتتابع** لا دفعة واحدة.
- **ضغط client-side** ≤1MB (`flutter_image_compress`)؛ رفض الصور الكبيرة جداً برسالة.
- **حفظ draft محلي** للنموذج والصور → استئناف عند فقد النت أو الخروج.
- **بورتفوليو/منتجات:** سحب لإعادة الترتيب + تعليم "الغلاف/الصورة الرئيسية".

---

## 15. التسجيل والمراجعة + إدارة المالك + الاشتراك

- **التسجيل:** نموذج self-signup متعدد الخطوات (المالك بنفسه أو بمساعدة الفريق الميداني على الأرض — نفس الواجهة) + **auto-save draft**. بعد التقديم → `pending` لمراجعة السوبر أدمن (approve/reject).
- **إدارة نشاطي:** تعديل البيانات، toggle توفر المنتج (`available/out_of_stock`)، "مغلق مؤقتاً" (`isTemporarilyClosed`)، **معاينة عامة** ("شوف بروفايلك زي الزباين").
- **الاشتراك (`subscription`):** قسم "اشتراكي" بحالات `free / trial-N-days / prime / expired` + شاشة الترقية (مزايا Prime) + طريقة الدفع *(placeholder: Vodafone Cash/InstaPay/cash عبر الفريق — التكامل مؤجّل)*. **قيود الـ free tier صريحة** (مثلاً عدد صور أقل، لا featured)، وإيه اللي بيتقص عند الـ downgrade. الأسعار مؤجّلة (من الـ scope).
- **order-intents للمحل:** مؤجّلة في الـ MVP (تأكيد واعٍ من الـ scope — مفيش analytics للمحلات).

---

## 16. التعريب والأرقام والـ RTL

- **`NumberFormatter`:** أرقام **عربية شرقية للعرض** (١٢٠ جنيه)، **لاتينية للمنطق**. أرقام الهواتف/`wa.me` تفضل لاتيني E.164.
- **خلط RTL/LTR:** `Bidi.wrap`/`Directionality` للأرقام/الروابط اللاتينية داخل نص عربي (عشان متظهرش مقلوبة).
- تنسيق الجنيه + **وقت نسبي بالعربي** ("من ساعة") عبر `intl` بـ `ar`.
- **سقف `textScaleFactor`** واختبار عند 1.3× (الكروت ما تتكسرش).

---

## 17. دورة حياة التطبيق والتكامل

- **Deep links** (`app_links`): ويب/مشاركة → listing في التطبيق + زر **مشاركة listing**.
- **Force-update / maintenance gate** عند الـ cold start (نسخة عبر `package_info_plus`؛ المصدر remote لاحقاً، النهارده stub).
- **سلوك زر الرجوع** موحّد (تابات + double-back-to-exit).
- cold start / resume + caching/eviction للصور.

---

## 18. حالات الـ UI العامة

- **Skeleton loaders** (مش spinner) للـ feed/القوائم.
- حالات Bloc موسّعة: `Loading | LoadingMore | Loaded | Empty | PartialError | NoConnection | Error`.
- **اصطلاحات الإشعار:** snackbar للنجاح الخفيف، inline للأخطاء القابلة للإصلاح، dialog للحرج/المدمّر فقط — بنبرة عامية مصرية ودودة + زر إعادة محاولة.
- widgets مشتركة: `LoadingView`, `SkeletonView`, `EmptyView`, `ErrorView`, `OfflineBanner`, `StaleDataBanner`.

---

## 19. الأداء والأجهزة الرخيصة

- صور مصغّرة من السيرفر + `memCacheWidth`/`cacheWidth`.
- **وضع موفّر داتا** على 2G (إخفاء الخريطة/الصور الكبيرة).
- حدود batch للـ pagination.
- اختبار على جهاز منخفض (2GB RAM).

---

## 20. الاختبار

- **Bloc tests** لكل Bloc (FeedBloc أولاً): الانتقالات بين الحالات (بما فيها `NoConnection`/`Empty`/`Error`) مع mock repo.
- **Widget tests** للكومبوننتس المشتركة (الكروت، الحالات، البانرات).
- **Unit tests** للـ utils الحساسة: `NumberFormatter`, phone→E.164, money/relative-time.
- `flutter analyze` نظيف كشرط لكل مرحلة. (Golden tests اختيارية للكروت في التلميع.)

---

## 21. خطة المراحل (الهجين)

1. **الأساس:** الباكدجات + build_runner + theme/Cairo/RTL + هيكل المجلدات + DI + go_router shell + ConnectivityCubit + RepositoryException + repository interfaces + mock infra + models (freezed) + بيانات واقعية + widgets الحالات (بما فيها offline/skeleton).
2. **الرئيسية (شريحة رأسية):** FeedBloc + MockListingRepository + جريد/كروت + فلتر القرية + تاب خريطة (stub) + **كل الحالات (loading/empty/error/offline/stale)** + تلميع. **إثبات النمط.**
3. **التوسّع:** باقي الشاشات + الحالات (دورة حياة الكيان، السلة per-shop، التسجيل/التوثيق، الاشتراك، الأذونات...) بالنمط المثبَّت.
4. **مشية كاملة + تلميع نهائي + اختبار على جهاز منخفض.**

---

## 22. خارج النطاق (لاحقاً)
تثبيت الـ schema → migration → تبديل mock بـ Supabase → OTP/دفع/SMS حقيقي → web profiles → admin dashboard → in-app chat/reviews/realtime/push → analytics للمحلات → ملكية أنشطة متعددة.

---

## 23. معايير النجاح

- التطبيق كله قابل للتنقّل بـ mock data واقعية، بهوية WASALNI، RTL سليم.
- **كل حالات النظام مغطّاة وقابلة للتجربة:** offline/stale، دورة حياة الكيان (pending/rejected/suspended...)، أذونات، OTP، سلة per-shop، فشل تسليمات خارجية، رفع صور، أرقام عربية/لاتينية.
- التبديل لـ Supabase = تغيير تسجيلات `di.dart` فقط.
- الـ models تطابق مسودة الـ schema (supertype/subtype) وجاهزة للـ JSON.
- `flutter analyze` نظيف + اختبارات FeedBloc/الكومبوننتس/الـ utils تعدّي.
