# ✅ الـ Scope النهائي — WASALNI MVP (بعد كل القرارات)

> **التاريخ:** 2026-05-28
> **الحالة:** كل الـ 12 قرار محسومة + ملاحظاتك الإضافية. ده الـ **single source of truth** للـ MVP.
> **القرار الوحيد المعلّق:** هل التطوير solo (إنت + Claude) أم فيه developer تاني؟

---

## 1. الهوية الأساسية للمشروع (بعد التعديل)

**WASALNI = منصة اكتشاف محلي + تواصل مباشر** لربط سكان القرى المصرية بـ:
- 🔧 **مقدمي الخدمات و الحرفيين** (سباك، كهربائي، نجار، حلاق، خياط، مصور، دكتور...)
- 🏪 **المحلات و المتاجر** (بقالة، صيدلية، ملابس، إلكترونيات...) — **مع سلة مبسّطة**
- 🚗 **النقل** (تكاتك، عربيات نقل خاصة) — كـ directory

**التغيير عن الرؤية القديمة:**
- ✅ **أضفنا:** سلة شراء مبسّطة (Soft Cart)، tracking للطلبات، النقل
- ✅ **أكدنا:** المحلات و الخدمات الاتنين فالـ MVP
- ✅ **حافظنا:** التواصل المباشر (واتساب) كأساس، مش e-commerce كامل

**المبادئ الثلاثة (ثابتة):** السهولة • الثقة • التركيز المحلي

---

## 2. الـ User Types (4 أنواع)

| النوع | الوصف | الدفع |
|---|---|---|
| **المستخدم (Consumer)** | يبحث، يكتشف، يطلب، يتواصل | **مجاني** (مع extras اختيارية مدفوعة عبر السبورت) |
| **مقدم الخدمة (Provider)** | حرفي/خدمة بـ بروفايل + portfolio | Freemium (مجاني basic + Prime مدفوع) |
| **صاحب المحل (Shop)** | متجر بـ منتجات + سلة + توصيل اختياري | Freemium (مجاني basic + شرائح مدفوعة) |
| **السوبر أدمن (إنت)** | تحكم كامل فكل حاجة | — |

---

## 3. الـ MVP Features (المحسومة)

### 3.1 — Discovery & Browse
- ✅ Feed رئيسي (uniform 2-column grid + Map view tab)
- ✅ تصفّح بالـ Categories (كل الفئات + النقل)
- ✅ بحث بسيط (اسم/فئة/قرية)
- ✅ Filter بالقرية (قريتي / القرى المجاورة) — default على قرية اليوزر
- ✅ Guest browsing (بدون تسجيل)

### 3.2 — البروفايلات
- ✅ **صفحة مقدم خدمة:** portfolio (صور أعمال سابقة) + بيانات + ساعات + موقع + زرار تواصل
- ✅ **صفحة محل:** غلاف + شعار + بيانات + منتجات + توصيل (اختياري) + زرار تواصل
- ✅ **صفحة منتج:** صورة + اسم + سعر + المحل + "أضف للسلة"
- ✅ **صفحة سائق نقل:** نوع المركبة + المنطقة + بيانات + زرار تواصل

### 3.3 — الـ Soft Cart (مبسّطة)
- ✅ المستخدم يضيف منتجات للسلة
- ✅ زرار "اطلب" → **يولّد رسالة واتساب جاهزة** فيها:
  - اسم المحل
  - قائمة المنتجات + الكميات + الأسعار
  - الإجمالي
  - اسم المستخدم
  - نص: "أنا لقيتك على وصلني و عايز أطلب: ..."
- 🆕 **Order Tracking (مهم):** لما اليوزر يضغط "اطلب"، **نسجّل event فـ Supabase:**
  - `order_intents` table: user_id, shop_id, items (jsonb), total_value, village_id, created_at
  - **مفيش order management، مفيش payment، مفيش delivery tracking** — مجرد logging للـ analytics
  - **ليه فـ Supabase مش Google Sheet:** مجاني فعلياً، analytics أقوى، queries فورية. لما تتفاوض على الأرباح، تقدر تقول "X طلب بقيمة Y جنيه عبر Z مستخدم فـ N يوم"
- ⏸️ **Phase 2:** نقرر هل نخليه marketplace كامل (orders + payment + delivery) بناءً على الـ tracking data

### 3.4 — التواصل
- ✅ **زرار واتساب** على كل بروفايل، مع رسالة default:
  > "أنا لقيتك على وصلني و بتواصل معاك بخصوص: ___"
- ✅ **زرار اتصال** (phone deep-link)
- ✅ **زرار موقع** (Google Maps deep-link)
- ⏸️ **In-app chat:** **مش ظاهر فالـ MVP أصلاً.** يتضاف فـ Phase 2 لو الـ MVP أثبت الحاجة. (مفيش "قريباً" labels)

### 3.5 — الحساب و التسجيل
- ✅ **Phone + OTP** (مش email، مفيش Resend SMTP)
- ✅ Guest browsing بدون auth
- ✅ Auth بس عند: حفظ مفضلة، تسجيل provider/shop، الطلب من السلة
- ✅ استكمال بروفايل بسيط (اسم، موبايل، قرية)

### 3.6 — المفضلة
- ✅ حفظ مقدم خدمة / محل / منتج كمفضلة

### 3.7 — الـ Web Profile Pages
- ✅ كل بروفايل له URL على الويب (Next.js) — read-only
- ✅ Open Graph image (علشان الـ WhatsApp shares تبان حلوة)
- ✅ SEO-friendly

### 3.8 — الـ Verification
- ✅ مقدم الخدمة/المحل يرفع: صورة بطاقة + رقم + صورة المحل/النشاط
- ✅ السوبر أدمن يراجع (approve/reject)
- ✅ شارة "موثّق" بعد الموافقة
- ✅ الصور المشفّرة + حذف بعد المراجعة (الـ privacy policy من الـ memory)

---

## 4. الـ Admin Dashboard (السوبر أدمن فقط فالـ MVP)

> نوع واحد بس فالـ MVP = **Super Admin**. الـ roles الأخرى Phase 2. (جلسة مخصصة بعد القرارات)

**Features المطلوبة فالـ MVP:**
- ✅ CRUD كامل: providers, shops, products, categories, transport, users
- ✅ Verification queue (مراجعة البطاقات و الصور)
- ✅ Manual feature/unfeature (تمييز فالـ feed)
- ✅ User management (تعطيل، حذف، عرض history)
- ✅ **Order Intents viewer** (عرض الطلبات المسجّلة + الإجماليات)
- ✅ Analytics: DAU/WAU/MAU، عدد providers/shops، top categories، order value totals، per-village breakdown
- ✅ Audit log (مين عمل ايه و امتى)
- ✅ Multi-village management (كفر المقدام + تفهنا الأشراف، و إضافة قرى)

**التقنية:** Next.js + Supabase + Tailwind + Shadcn + Tanstack Table + Recharts

---

## 5. الـ Monetization (المحسوم)

### المستخدم النهائي (Consumer)
- **مجاني للأبد** فالأساسيات
- **Extras مدفوعة (عبر السبورت، مش in-app فالـ MVP):**
  - بروفايل/portfolio مميز (Prime)
  - إعلان لحاجة معينة → يتواصل مع السبورت و يتفق

### مقدم الخدمة (Provider)
- **Free tier:** بروفايل بسيط
- **Prime tier (مدفوع):** بروفايل مميز + مميزات أحسن — "حاجة كويسة تستحق الدفع"

### صاحب المحل (Shop)
- **Free tier:** بروفايل بسيط (تواصل + مكان + معلومات)
- **Paid tiers (شرائح):** يتناقش فيها لاحقاً

### التوقيت
- **3 شهور مجاني** من **تاريخ الإطلاق** (promotional period للكل)
- بعد الـ 3 شهور: **14 يوم trial** لأي **provider/shop** جديد، ثم المدفوع
- **الدفع شهري**

### ⏸️ مؤجّل للنقاش
- أسعار الـ Prime tier للـ providers (بالجنيه)
- شرائح المحلات و أسعارها
- آلية الدفع (Vodafone Cash / InstaPay / Fawry / cash عبر الفريق الميداني)

---

## 6. الجغرافيا

- ✅ **الإطلاق:** كفر المقدام + تفهنا الأشراف (قريتين)
  - جروب فيسبوك منفصل لكل قرية (asset للـ acquisition)
  - إنت بتشرف على الاتنين
  - تفهنا = محلات و خدمات كتير، مش مجمّعة غير فالفيس
- ✅ **التوسع:** قرية جديدة كل 3 شهور (بعد التأكد من نجاح الأولى)

---

## 7. القرارات التقنية

| البند | القرار |
|---|---|
| Mobile | Flutter (جديد من الصفر) |
| Backend/DB | Supabase (schema جديد) |
| Admin + Web | Next.js (جديد) |
| Auth | Phone OTP (SMS مصري أو WhatsApp OTP) |
| Storage | Supabase Storage (صور) |
| State Mgmt | Bloc (تفضيلك المعروف) |
| Design | إنت + Claude Code + AI tools |
| Spec Kit | **موقّف** — نستخدم `current_plan.md` بسيط |
| Reviews | **مؤجّل** (Phase 2) |
| In-app chat | **مؤجّل** (Phase 2) |
| Real-time transport | **مؤجّل** (Phase 2) |

---

## 8. ايه اللي خرج من الـ MVP (Phase 2+)

- ❌ In-app chat
- ❌ Reviews & ratings
- ❌ Real-time transport (Uber-style)
- ❌ Full marketplace (payment + delivery management)
- ❌ شرائح اشتراك معقدة
- ❌ Multi-admin roles
- ❌ Push notifications المتقدمة
- ❌ إحصائيات للمحلات (analytics للـ shop owners)

---

## 9. الـ Data Model المبدئي (high-level)

```
villages (id, name, governorate, ...)
users (id, phone_e164, name, village_id, role, ...)
categories (id, name, icon, type[service|shop|transport], parent_id, ...)
providers (id, user_id, name, category_id, village_id, bio, status, is_prime, ...)
provider_photos (id, provider_id, url, ...)  ← portfolio
shops (id, user_id, name, category_id, village_id, cover_url, logo_url, has_delivery, tier, ...)
products (id, shop_id, name, price_egp, image_url, ...)
transport_drivers (id, user_id, vehicle_type, area, village_id, ...)
favorites (id, user_id, target_type, target_id, ...)
order_intents (id, user_id, shop_id, items_jsonb, total_value_egp, village_id, created_at)  ← tracking
verifications (id, target_type, target_id, id_card_url, selfie_url, status, reviewed_at, ...)
audit_logs (id, admin_id, action, target, timestamp, ...)
```

---

## 10. التقديرات الواقعية (بعد كل القرارات)

| البند | التقدير |
|---|---|
| **Timeline للـ MVP** | 4-6 شهور (مع solo dev + Claude) |
| **عدد الشاشات (Mobile)** | ~15-18 شاشة |
| **عدد جداول الـ DB** | ~12 جدول |
| **الفريق الميداني** | 4 agents (offline training) |
| **القرى** | 2 (كفر المقدام + تفهنا الأشراف) |
| **التكلفة** | راجع `04_budget_egp.md` |

---

## 11. الخطوة القادمة

1. ✅ Scope محسوم (الملف ده)
2. 📋 راجع `03_field_team_playbook.md` (الفريق الميداني) + جاوب على الأسئلة المطلوبة
3. 💰 راجع `04_budget_egp.md` (الميزانية بالجنيه)
4. 🛠️ بعد ما نأكد الـ solo/team dev question → نبدأ:
   - Cleanup الـ Repo (archive القديم، branch جديد)
   - `current_plan.md` (الخطة البسيطة)
   - Design identity sprint (إنت + أنا)
   - Sprint 1: الـ data model + auth + feed

---

> **ملاحظة:** ده الـ scope النهائي. أي تغيير من هنا = قرار واعي، مش drift. لو حسّينا الـ scope كبير أثناء التنفيذ، نشيل من Phase 2 list (cart tracking، transport، 2nd village).
