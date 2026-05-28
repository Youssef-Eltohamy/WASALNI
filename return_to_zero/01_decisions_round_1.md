# 📝 الجولة 1 — قراراتك + الثغرات اللي محتاج نناقشها

> **التاريخ:** 2026-05-27
> **المحتوى:** صياغة رسمية لقراراتك من المحادثة + ملاحظات إضافية + الثغرات اللي لازم تتغطى قبل التنفيذ.

---

## القسم 1 — صياغة رسمية لرؤيتك الجديدة

### 1.1 — رفض الـ Phase 0 (Manual MVP)

**قرارك:** مش هنبتدي بـ 60 يوم WhatsApp manual.

**أسبابك (كما فهمتها):**
1. **العصر اتغيّر** — الـ Manual MVP كان pattern مناسب لـ 2015-2020. دلوقتي الـ smartphone و الـ apps موجودة فالقرى بشكل أوسع.
2. **جروب الفيسبوك موجود بالفعل** — أغلب أهل البلد فيه. ده يحل مشكلة "الـ atomic network" اللي الـ Manual MVP كان هيحلها.
3. **الـ Friction** — أي خطوة وسيطة هتفقدنا ناس. الـ WhatsApp Channel جديد = pretty much نفس الـ friction بتاع التطبيق نفسه.
4. **التطبيق الحقيقي = القيمة الفعلية** — مش "تجربة WhatsApp" قبلها.

**يعني:** قناة الـ acquisition الأولى = **جروب الفيسبوك الموجود** + الفريق الميداني، مش WhatsApp Channel جديد.

---

### 1.2 — الـ Communication: WhatsApp + In-App Chat معاً

**قرارك:**
- زرار WhatsApp فكل profile (مع رسالة default: "أنا لقيتك على وصلني و بتواصل معاك بخصوص: ___")
- **In-app chat** بين العملاء و مقدمي الخدمة (الـ default الرئيسي بداخل التطبيق)
- المستخدم يختار الـ channel اللي يناسبه
- **الـ chat نفسه:** مؤجّل، يظهر فالـ UI بـ "جاري العمل عليه"

**يعني:** الـ MVP بيكون عنده **زرّارين تواصل** على كل profile:
1. "تواصل من خلال وصلني" (مؤجّل، الـ button بيظهر "قريباً")
2. "تواصل عبر واتساب" (شغّال من اليوم الأول)

---

### 1.3 — أصحاب المحلات و المتاجر = جزء من الـ MVP

**قرارك:**
- المحلات/المتاجر جزء **ضروري** من المشروع، مش مؤجل
- كل صاحب متجر له **صفحة متجر خاصة بيه**
- المستخدم يقدر **يدخل و يطلب منتجات** (سلة شراء — Cart)
- صاحب المتجر يقدر **يضيف توصيل** أو مميزات إضافية لو عايز
- **الاتنين (خدمات + متاجر) فالـ MVP**

**يعني:** الـ scope توسّع جذرياً من "directory للحرفيين" إلى **منصة هجين**:
- Directory للحرفيين (services discovery)
- Marketplace للمحلات (with cart, products, optional delivery)

**🚨 ملاحظة حرجة:** ده **تحوّل أساسي** من الـ "WASALNI = مش متجر إلكتروني" المكتوبة فالـ memory و الـ design spec الحالي. **محتاجين نناقش الـ implications.** (راجع القسم 3.1 فالأسفل).

---

### 1.4 — الـ Admin Dashboard = مالك المشروع، مش مشرف

**قرارك:**
- الـ Admin Dashboard لازم يكون **أقوى من التطبيق نفسه**
- تحكم كامل و قوي فكل حاجة
- وصول لكل البيانات و العمليات
- **"دا ملك المشروع، مش مجرد مشرف"**

**يعني:** الـ admin = first-class user type، مش afterthought.

**ده بيتطلب تخطيط جدّي لـ:**
- إدارة المستخدمين (تعديل، تعطيل، حذف، عرض history)
- إدارة الـ providers و الـ shops (CRUD كامل، manual override للبيانات)
- إدارة الـ categories
- إدارة الـ orders (المنتجات اللي اتطلبت)
- إدارة الـ verification (مراجعة بطاقات، صور)
- إدارة الـ financial (الـ subscriptions، الـ payouts للمحلات لو حصل)
- إدارة الـ moderation (حذف محتوى، حظر مستخدمين)
- **Analytics قوية** (DAU/MAU، conversion، revenue، top performers)
- **Audit logs** (مين عمل ايه و امتى)
- **Multi-admin support** (لو فيه أكتر من admin مع صلاحيات مختلفة)

---

### 1.5 — إجاباتك على الـ 12 قرار (مع تعليقاتي)

| # | القرار | إجابتك | تعليقي |
|---|---|---|---|
| 1 | المسار قبل MVP | **Code Direct** (مش Manual) | فهمت السبب، بس فيه risk سأشير له. راجع 2.1 |
| 2 | نوع الـ Supply الأول | **Services أولاً + Shops UI مرئية بـ "قريباً"** | تمام، بس ايه معنى "Service-first" لو الـ MVP فيه shops؟ راجع 3.1 |
| 3 | Auth | **Phone OTP** ✅ | متفقين |
| 4 | WhatsApp | **WhatsApp + In-App Chat (الـ chat مؤجل)** | تمام بس محتاج تحديد فعلي للـ MVP scope |
| 5 | Existing Code | **Burn It All Down** (حتى الـ UI) | جذري بس واضح، نفذ |
| 6 | Categories | **كل الـ Categories + النقل (تكاتك، عربيات، إلخ)** | scope كبير، راجع 3.2 |
| 7 | Monetization | **3 شهور مجاني + 14 يوم trial للجديد ثم مدفوع** | محتاج تفاصيل، راجع 3.3 |
| 8 | Geography | **قريتين من البداية (كفر المقدام + تفهنا الأشراف) + قرية جديدة كل 3 شهور** | معقول، راجع 2.2 |
| 9 | Spec Kit | **أوقف** ✅ | متفقين |
| 10 | Web Fallback | **Mobile + Web Profile Pages** ✅ | متفقين |
| 11 | Field Team | **يحتاج تدريب + نقاش** | نخصّص جلسة لده |
| 12 | Reviews | **مؤجل** ✅ | متفقين |

---

## القسم 2 — ملاحظات على قراراتك (Trade-offs)

### 2.1 — رفض الـ Manual MVP: المخاطر و كيف نخفّفها

**موقفي:** قرارك مفهوم و فيه منطق قوي. **لكن** البحث كان مجمع على إن validation قبل التنفيذ ضرورة. لو هنرفض الـ Manual MVP، **محتاجين بديل للـ validation** يحقق نفس الـ outcome.

**ايه اللي خسرناه:**
- Customer discovery interviews (20+ مقابلة قبل أي كود)
- Validation للـ pain points الحقيقية
- اختبار الـ value prop قبل الـ investment

**ايه البدائل المقترحة (مش manual MVP، بس بديل ليه):**

#### الخيار البديل أ — "Discovery Sprint" (أسبوع واحد)
- إنت + 1-2 شخص من الفريق ينزلوا كفر المقدام لمدة 5 أيام
- 30 مقابلة بـ Mom Test (15 user + 15 محتمل provider)
- جمع التركيب فـ ملف واحد
- **بعد ده مباشرة نبدأ الـ build** بـ insights حقيقية
- **التكلفة:** ~$200 (مواصلات + شاي + غداء للناس)
- **المدة:** 5-7 أيام، مش 60 يوم

#### الخيار البديل ب — "Facebook Group Validation" (3-5 أيام)
- إنت تنزل على جروب الفيسبوك الموجود بنفسك
- تعمل 3-5 posts:
  1. سؤال: "ايه أكتر مشكلة بتقابلكم لما بتدوّروا على حرفي أو محل فالقرية؟"
  2. سؤال: "آخر مرة احتجتم سباك/كهربائي، حصل ايه؟"
  3. concept: "تخيلوا تطبيق يجمع كل ده — ايه الـ feature الأهم ليكم؟"
- تجمع الـ responses
- ده **استخدام للجروب الموجود اللي اعتبرته asset** فالـ acquisition
- **مدة:** 5 أيام
- **تكلفة:** صفر

#### الخيار البديل ج — لا validation، نبدأ direct
- نقع فالـ anti-pattern #1 (Build before Validate)
- **المخاطرة عالية**

**توصيتي:** **الخيار البديل ب + ج معاً** = استخدم الجروب لـ pre-validation سريعة جداً (أسبوع) و نبدأ الـ build بناءً على النتائج.

**سؤال محتاج إجابتك:** أنهي بديل تختار؟ (ب/ج أم تركيبة)

---

### 2.2 — قريتين من البداية بدل واحدة

**موقفي:** قريتين فالـ launch ينفع، **بشروط**:

✅ **شروط النجاح للقريتين معاً:**
1. **Field team capacity:** لازم يكون فيه على الأقل 2 agents (واحد لكل قرية) — مش agent واحد بيتنقل
2. **Local champion في كل قرية:** شخص محلي من القرية يكون نقطة الاتصال الأساسية
3. **Tracking منفصل:** كل قرية لها metrics مستقلة (مش "إجمالي users")
4. **Kill criteria منفصلة:** لو قرية فشلت و الثانية نجحت، نقفل الفاشلة و نركز

❓ **سؤال محتاج إجابتك:** هل عندك:
- 2 field agents جاهزين (واحد منهم لتفهنا الأشراف بالذات)؟
- Local champion فـ تفهنا الأشراف؟
- علاقات هناك بالفعل؟ (الـ Facebook group اللي ذكرته هل هو لكفر المقدام فقط، أم لتفهنا الأشراف، أم للقريتين معاً؟)

---

## القسم 3 — الثغرات الكبرى (الـ Gaps)

### 3.1 — 🚨 الـ Cart + Checkout + Delivery: تحوّل جذري محتاج تفصيل

**ما قلته:** "المستخدمين يدخلوا و يطلبوا و يكون فيه سله و صاحب المتجر لو عايز يضيف توصيل أو مميزات تانيه يقدر"

**ما يستلزمه ذلك تقنياً و تجارياً:**

#### الـ Implications التقنية:
1. **Cart / Order data model** — جدول orders + order_items
2. **Order states** (pending → accepted → preparing → out_for_delivery → delivered → cancelled)
3. **Inventory tracking** — لو منتج 5 قطع، الـ stock يتنقص لما اتطلب
4. **Notifications** للـ shop owner لما يكون فيه order جديد
5. **Order history** لكل من الـ user و الـ shop owner
6. **Cancellation / refund flow**

#### الـ Implications التجارية:
1. **Payment:** هل COD (cash on delivery) فقط، أم online payment كمان؟ لو online، أنهي gateway مصري؟ (PayMob، Fawry، MyFatoorah، Stripe-Egypt)
2. **Delivery logistics:**
   - صاحب المحل بيوصّل بنفسه؟
   - شركة delivery خارجية (Mylerz، Bosta)؟
   - الـ user بيستلم بنفسه (pickup)؟
   - WASALNI بيدير الـ delivery؟
3. **Disputes:** ايه يحصل لو الـ user قال "مش وصلني" أو "وصلني مكسور"؟
4. **Refunds:** سياسة الـ refund — مين بيدفع؟ كم وقت؟
5. **Commission على الـ orders؟** لو نعم، كم %؟

#### الـ Implications على نموذج العمل:
- **WASALNI الأصلي:** "نحن discovery، التواصل بيتم خارج التطبيق" → بسيط، low risk
- **WASALNI الجديد بـ cart:** "نحن marketplace ينقل الـ transaction" → معقد، higher liability
- المستخدم لو حصلت له مشكلة فطلب، **هيوجه اللوم لـ WASALNI**، مش للمحل

#### الـ Implications القانونية:
- محتاج terms of service واضحة جداً
- ضريبة القيمة المضافة (VAT) لو نأخذ commission
- قانون حماية المستهلك المصري ينطبق على الـ transactions

#### الـ Scope Risk:
- Cart system لوحده = **+30-50% effort فالـ MVP**
- Delivery features = **+15-25% effort**
- Order management = **+20% effort**
- **Total impact: MVP بياخد 2-3 شهور إضافية** على الأقل

**سؤالي ليك (أهم سؤال):**

> **هل الـ Cart/Order feature ده فعلاً ضروري فالـ MVP الأول؟**
>
> الـ alternatives:
>
> **خيار A:** Cart فالـ MVP الأول (نموذج marketplace كامل)
> - Pros: نموذج قوي، competitive
> - Cons: scope ضخم، delivery + payment صداع، MVP بياخد 6 شهور
>
> **خيار B:** Cart فالـ Phase 2 (بعد الـ MVP)
> - الـ MVP: discovery + WhatsApp للتواصل + ابتداء الـ negotiation
> - الـ Phase 2: cart + delivery + payment
> - Pros: MVP بسيط و سريع، نختبر الـ demand للـ cart قبل ما نبنيه
> - Cons: المنافسة موجودة (Facebook Marketplace) عملت cart-like
>
> **خيار C:** Cart بسيط جداً فالـ MVP (Soft Cart)
> - "السلة" = list من المنتجات اليوزر اختارها
> - لما يضغط "اطلب"، تتولّد رسالة WhatsApp فيها كل المنتجات + الأسعار + اسمه
> - **مفيش order management فالـ DB، مفيش payment، مفيش delivery tracking**
> - صاحب المحل يدير الـ order على واتساب عادي
> - Pros: نأخد فوائد الـ cart UX بدون تعقيد الـ marketplace
> - Cons: مفيش analytics عن الـ orders، مفيش commission، مفيش data
>
> **توصيتي:** **الخيار C (Soft Cart)** — تأخد UX الـ cart بدون التعقيد. ده يعطيك all the benefits with 10% of the work.

---

### 3.2 — الـ Categories: scope كبير جداً

**ما قلته:** "كل الـ Categories بالإضافة لخدمات النقل زي التكاتك و العربيات النقل الخاصة"

**Categories اللي بنفترض إنها داخلة:**
1. صيانة منزل (سباك، كهربائي، نجار، حداد، نقاش، مكييفات)
2. عناية شخصية (حلاق، كوافير، مكياج، خياط)
3. صحة (دكتور، صيدلية، تمريض)
4. تعليم (مدرسين، دروس قرآن)
5. مناسبات (مصور، DJ، طبّاخ)
6. **النقل (تكاتك، عربيات نقل خاصة، نقل كبير)** ← جديد
7. حرف يدوية (نحت، خط، مشغولات)
8. ميكانيكا و إصلاح (سيارات، موبايلات، إلكترونيات)
9. **محلات (بقالة، صيدلية، ملابس، إلكترونيات، إلخ)** — لأن المحلات داخلة

**ملاحظات:**

🚨 **النقل (تكاتك، عربيات نقل):** ده فئة مختلفة جداً عن الباقي.
- الـ tuktuks بتشتغل **on-demand** ("عايز توصلني دلوقتي")
- مش "ابحث عن سواق و تواصل معاه" زي السباك
- محتاج: real-time location، availability status، fare calculation، تواصل سريع
- ده **Careem/Uber-style feature** = scope إضافي ضخم

**خياراتك:**

**خيار A:** كل الـ categories + النقل كـ on-demand فالـ MVP
- Scope ضخم. الـ MVP يطلع فـ 6-9 شهور.

**خيار B:** كل الـ categories + النقل كـ "directory للسواقين" (مش on-demand)
- الـ user بيشوف سواقين متاحين، يتواصل معاهم على واتساب/اتصال
- مفيش real-time location/availability
- Scope معقول

**خيار C:** كل الـ categories بدون النقل فالـ MVP
- النقل = Phase 2

**توصيتي:** **الخيار B** — النقل يدخل كـ directory بسيط، مش Uber-style. الـ real-time features تيجي فـ Phase 2.

**سؤالي ليك:** أنهي خيار؟ + هل في categories تانية إنت شايف لازم تضاف؟

---

### 3.3 — Monetization: تفاصيل ناقصة

**ما قلته:**
- 3 شهور مجاني من الإطلاق
- بعدها 14 يوم استخدام لأي مستخدم جديد ثم المدفوع
- تفاصيل الباقات هنناقشها بعدين

**أسئلة محتاج تجاوب عليها قبل الـ build:**

1. **مين بيدفع؟**
   - المستخدمين النهائيين (consumers)؟ — ❌ غالباً مش حيدفعوا (الـ research مجمع على ده)
   - مزودي الخدمات (سباك، كهربائي)؟
   - أصحاب المحلات؟
   - الـ 3 معاً؟

2. **بيدفعوا مقابل ايه؟**
   - Subscription شهري لكونهم على المنصة؟
   - Pay-per-lead (مقابل كل عميل بيوصل ليهم)؟
   - Commission على الـ orders (لو في cart)؟
   - Sponsored placement (الـ premium positioning)؟

3. **الـ 14 يوم trial لمين بالظبط؟**
   - لو الـ user (consumer) → بعد 14 يوم يدفع علشان يستخدم WASALNI؟ ⚠️ **ده هيقتل النمو** — الـ user الـ MENA مش بيدفع لـ discovery app
   - لو الـ provider/shop → بعد 14 يوم يدفع علشان يفضل listed؟ ✅ منطقي
   - لو الاتنين → معقد

4. **الـ 3 شهور مجاني من إمتى؟**
   - من تاريخ الـ launch (يعني لو حد سجل فاليوم الأول، يستخدم مجاني 3 شهور)
   - من تاريخ تسجيل المستخدم (كل user له 3 شهور مجاني من يوم تسجيله)
   - الاتنين معاً (3 شهور launch promotional + 3 شهور لكل user جديد)

**توصيتي للـ MVP:**
- **المستخدمين النهائيين (consumers) = مجاني تماماً للأبد** ❌ مش يدفعوا
- **مزودي الخدمات و أصحاب المحلات:**
  - 3 شهور مجاني من تاريخ تسجيلهم (مش launch)
  - بعدها، 3 خيارات (للنقاش):
    - **خيار 1: Subscription ثابت** (مثلاً 100 جنيه/شهر للـ provider، 200 للـ shop) — بسيط لكن مش معتمد على القيمة الفعلية
    - **خيار 2: Pay-per-lead** (10-20 جنيه لكل lead حقيقي) — أقرب للقيمة لكن صعب الـ tracking
    - **خيار 3: Freemium** (مجاني للأساسيات، sponsored placement مدفوع) — أبسط للـ ramp up

**سؤالي ليك:** أنهي نموذج monetization تفضّل؟ + هل المستخدمين النهائيين يدفعوا أم لا؟

---

### 3.4 — In-App Chat: مؤجّل بس فالـ UI

**ما قلته:** "الشات هيكون مؤجل و جاري العمل ع الخدمة"

**التحدي:** الـ "Coming Soon" feature فالـ UI ممكن يكون double-edged:
- ✅ يبيّن للمستخدم إن المنصة بتتطوّر
- ❌ يخلي المستخدم يتوقع feature غير موجود → frustration

**خياراتك:**
- **خيار A:** زرار الـ in-app chat ظاهر، يفتح modal "قريباً — بنشتغل عليه"
- **خيار B:** الـ chat مش ظاهر فالـ MVP أصلاً، يتضاف بعدين بدون warning
- **خيار C:** زرار الـ chat بياخدك على واتساب فالـ MVP، و يتم استبداله بـ in-app chat فالـ Phase 2

**توصيتي:** **الخيار C** — تجنب "Coming Soon" labels. اللي مش موجود، مش ظاهر.

---

### 3.5 — الـ Admin Dashboard: محتاج spec تفصيلي

**ما قلته:** "Admin أقوى من التطبيق، تحكم كامل، مالك المشروع"

**عشان أبني ده، محتاج إجابات على:**

#### 3.5.1 — الـ Personas للـ Admin
هل هتكون أنواع admin مختلفة؟
- **Super Admin** (إنت) — كل صلاحية
- **Moderator** — يراجع المحتوى، الـ verifications، الـ reports
- **Content Manager** — يضيف categories، featured shops، announcements
- **Field Manager** — يضيف providers/shops نيابة عنهم
- **Analyst** — يشوف الـ data بدون صلاحية تعديل

#### 3.5.2 — الـ Features الأساسية
**المطلوبة لـ MVP:**
- ✅ CRUD على providers, shops, categories, products
- ✅ Verification queue (مراجعة الـ ID، الصور)
- ✅ User management (حظر، تعديل، حذف)
- ✅ Manual feature/unfeature (تمييز محل/مزود فالـ feed)
- ✅ Analytics dashboard (DAU/WAU/MAU، breakdowns)
- ✅ Audit log (مين عمل ايه و امتى)

**Phase 2:**
- Order management (لو في cart)
- Financial dashboard
- Subscription management
- Push notification broadcasting
- Bulk operations (import/export)

#### 3.5.3 — التقنية
- **Existing:** Next.js + Supabase JS client (موجود)
- **يفضل:** Tailwind + Shadcn + Tanstack Table + Recharts (standard combo قوي)
- **Auth:** Supabase Auth مع role-based access control

**سؤالي ليك:** هل تحب نناقش الـ admin features فجلسة مخصصة بعد ما نخلص قرارات الـ MVP؟

---

### 3.6 — الـ Brand Identity من الصفر: مين بيعمله؟

**ما قلته:** "Burn It All Down، عايزين نعمل من البداية هوية كاملة من البداية"

**سؤال:** الهوية البصرية (الـ logo، الـ palette، الـ typography، الـ illustrations) مين هيعملها؟

**خياراتك:**
1. **مصمم خارجي** — مكتب أو freelancer مصري ($500-3000 على Behance/Designtok)
2. **مولّد AI** — Midjourney + Claude للـ palette و التركيب ($30-100)
3. **إنت + Claude Code + AI tools** — تشتغل معاي على الـ design ($0)
4. **مزيج** — AI للأولي، مصمم للتشطيب النهائي

**توصيتي:** خيار 4 (مزيج) للجودة + سرعة، أو خيار 3 لو ميزانية ضيقة.

---

### 3.7 — Field Team Training Plan

**ما قلته:** "نحتاج تدريب ليهم و ليّ كمان"

**اقتراحي لجلسة تدريب الفريق الميداني:**

#### الجلسة 1 — أساسيات (3 ساعات)
- ما هو WASALNI؟ (Value Prop)
- مين الجمهور المستهدف؟
- ما هو دور الـ field agent؟
- إيه نقول، إيه ما نقولش

#### الجلسة 2 — Mom Test (2 ساعة)
- كيف تطرح أسئلة صحيحة؟
- كيف تستمع بدون "بيع"؟
- كيف توثّق المقابلة؟

#### الجلسة 3 — Onboarding workflow (3 ساعات)
- إزاي تسجّل مزوّد على المنصة
- إزاي تصوّر الـ portfolio
- إزاي تحصل على بيانات التواصل الصحيحة
- إزاي تعمل verification (بطاقة، رقم، صورة المحل)

#### الجلسة 4 — Field practice (يوم كامل)
- نزول حقيقي لكفر المقدام
- 5 onboardings مباشرة معاي
- مراجعة بعد كل واحد

**نقاش محتاج:**
- كم عدد agents هنبدأ بيهم؟
- هل ال training بـ في الـ in-person أم online؟
- هل عندك مرشح من القرية يكون part-time؟

---

## القسم 4 — الـ Scope Summary بعد قراراتك

### MVP الجديد (كما فهمته من قراراتك):

**Supply side:**
- ✅ Services (سباك، كهربائي، نجار، حداد، نقاش، حلاق، خياط، إلخ)
- ✅ Shops (بقالة، صيدلية، ملابس، إلكترونيات، إلخ) — مع cart
- ✅ Transport directory (تكاتك، عربيات نقل خاصة)
- ✅ Medical (دكتور، صيدلية)
- ✅ Education (مدرسين، دروس قرآن)
- ✅ Events (مصور، DJ، طبّاخ)

**Features:**
- ✅ Feed / Discovery
- ✅ Search + Categories
- ✅ Profile pages (services + shops + products)
- ✅ Shopping Cart (TBD: soft أم full)
- ✅ Optional delivery (per shop)
- ✅ WhatsApp deep-link
- ⏸️ In-app chat (UI exists, marked coming-soon, OR completely deferred)
- ✅ Phone OTP auth
- ✅ Guest browsing
- ✅ Web profile pages (Mobile + Web)
- ✅ Admin dashboard (قوي جداً)
- ❌ Reviews (Phase 2)
- ❌ Real-time tracking (Phase 2)

**Geography:**
- ✅ كفر المقدام + تفهنا الأشراف (الـ launch)
- Then قرية جديدة كل 3 شهور

**Monetization:**
- 3 شهور مجاني من launch
- 14 يوم trial لـ new users
- Paid model TBD

### ⚠️ Scope Risk Assessment

**حجم الـ MVP اللي اتفقنا عليه = ~3-4x الـ MVP الأصلي.**

**التوقعات الواقعية:**
- **Timeline:** 5-8 شهور (مش 3-4)
- **Budget:** $25-40k (مش $20k)
- **Team:** على الأقل 2-3 ناس (مش solo founder + part-time)

**هل ده مقبول لك؟** لو لأ، نرجع نحسم scope.

---

## القسم 5 — أهم 5 أسئلة محتاج إجاباتها قبل أي تنفيذ

### السؤال 1: Cart Strategy
أنهي خيار:
- **A:** Full marketplace cart (orders + payment + delivery tracking)
- **B:** Cart مؤجّل لـ Phase 2 (MVP = discovery + WhatsApp)
- **C:** Soft Cart (UI سلة، لكن الـ checkout = رسالة WhatsApp جاهزة)

### السؤال 2: Validation قبل الـ Code
أنهي خيار:
- **A:** Discovery Sprint (أسبوع مقابلات ميدانية)
- **B:** Facebook Group Validation (5 أيام posts فالجروب الموجود)
- **C:** Skip validation, start coding now

### السؤال 3: النقل (تكاتك)
أنهي خيار:
- **A:** Directory بسيط (زي السباكين، تواصل بواتساب)
- **B:** On-demand كامل (Careem-style، real-time)
- **C:** مؤجّل لـ Phase 2

### السؤال 4: Monetization Specifics
- **مين بيدفع؟** Users / Providers / Shops / كلهم؟
- **بكام؟** (مبدئياً)
- **بأي نموذج؟** Subscription / Pay-per-lead / Commission / Freemium

### السؤال 5: الـ Team
- **Solo (إنت لوحدك + Claude/agents)** أم تيم فعلي بيشتغل؟
- **Field team:** كم agent؟ Full-time أم part-time؟
- **Designer:** خارجي أم AI-only؟
- **Backup developer** للـ admin dashboard؟

---

## القسم 6 — الخطوة القادمة

بعد ما تجاوب على الـ 5 أسئلة فالقسم 5:

1. **هنحدّث الـ scope النهائي** (file: `02_final_scope.md`)
2. **هنرتب الـ Repo:**
   - Archive الـ existing branch
   - branch جديد `002-rebuild-from-zero` (أو اسم بتختاره)
   - Clean baseline (تطبيق Flutter جديد، Next.js جديد لـ admin، Supabase schema جديد)
3. **هنعمل خطة الـ 30 يوم الأولى** (validation + build kickoff)
4. **هنبدأ Sprint 1**

---

> **🎯 أهم نقطة:** Scope الـ MVP زاد ضعف على الأقل. ده ممكن، بس محتاج commitment أعلى فالـ time و الـ budget. لو ده يتعرّض على مشاكل، نرجع نشيل scope (الـ cart أو الـ النقل أو 2nd village).
>
> **سؤالي الأكبر:** هل تحب نبدأ بـ "Phase 0 Sprint" قصير (5-7 أيام validation + scope finalization) قبل ما نبدأ الـ build الفعلي؟ ده هياكل ١٠٪ من وقت الـ MVP بس بيخفّض الـ scope risk بـ 50%.
