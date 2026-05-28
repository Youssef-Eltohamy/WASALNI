# 🎯 القرارات المطلوبة — اختياراتك

> **الغرض:** الـ 12 قرار اللي محتاج تاخدهم قبل ما نبدأ rebuild. كل قرار له:
> - **الـ context** (ليه القرار ده مهم)
> - **الخيارات** (مع pros/cons)
> - **توصيتي** (المختار + ليه)
>
> اقرأ، فكّر، رجعّلي بالاختيارات. هنناقش أي قرار محتاج تفاصيل أكتر.

**تاريخ:** 2026-05-26

---

# 🔴 TIER 1 — قرارات حرجة (قبل أي rebuild)

## القرار 1: المسار قبل الـ MVP — Manual أو Code؟

### Context
بناءً على بحث Bootstrap (research_07) + قانون "Manual أولاً" (synthesis_patterns #2):
- Dunzo قعد سنة كاملة على WhatsApp manual، 700k user قبل ما يكتب سطر.
- Meesho بدأت كـ WhatsApp group، الـ founders بيديروا transactions يدوياً.
- Justdial كانت رقم تليفون + ناس بترد لسنين.
- DoorDash: founder phone + PDFs + manual delivery.

WASALNI الحالي اتعمل فيه كود كتير **بدون أي مستخدم اختبره**.

### الخيارات

**الخيار A — Manual MVP أولاً (Pre-Code Phase)** ⭐
- 30-60 يوم على WhatsApp Channel + Google Sheet + Facebook Page
- إنت بترد بنفسك، تجمع المحلات، تتكلم مع الـ users
- التطبيق الـ Flutter موقّف، أو يستخدم فقط للـ display للمحلات المجمعة
- **التكلفة:** ~$100-500
- **الـ Output:** validation حقيقي — لو الـ WhatsApp channel ما وصلش لـ 500 follower فـ 60 يوم، الفكرة محتاجة تتعدّل قبل أي كود

**الخيار B — كمل بناء MVP الحالي**
- استكمل Phases 6-9 (signout، reset، edit profile، polish)
- اشتغل على الـ UI shell
- اطلق الـ Flutter app + Supabase
- **التكلفة:** أسابيع إضافية من الكود + لسه ما اتأكدش الفكرة بتشتغل

**الخيار C — Hybrid: Manual + Code Parallel**
- WhatsApp Channel يبدأ دلوقتي
- التطبيق يتم rebuild ببطء فالخلفية
- لما الـ manual يثبت الـ demand، التطبيق يبقى جاهز
- **التكلفة:** wider effort، اتشتت

### توصيتي: **الخيار A (Manual First)** ⭐

**ليه:**
1. كل research عالمي (Dunzo، Meesho، DoorDash، Airbnb) بدأت Manual.
2. لو الفكرة هتفشل، Manual بيكشفها فأسبوعين بـ $200. Code بيكشفها بعد 6 شهور بـ $20,000.
3. الـ Manual ما بيوقفش — هو الـ research engine اللي **بيختبر**. حتى لو القررنا نبني، الـ Manual بيـ inform كل decision فالـ build.
4. التطبيق الحالي مش هيتحرّق — هيستنى. لو الـ Manual نجح، نرجع للـ code من position أقوى.
5. الـ "founder بيتمنّن من الكود" trap — research_07 صريح فيه. الـ 30 يوم Manual بيغيّر الـ founder من "coder" لـ "operator".

---

## القرار 2: نوع الـ Supply الأول — محلات أم خدمات أم الاتنين؟

### Context
الـ existing memory بيقول WASALNI يخدم 3 أنواع: مستخدم، مزوّد خدمة، صاحب محل.
- بناءً على research_09 (Service Providers): مزوّد الخدمة ≠ صاحب المحل. مختلفين تماماً.
- الـ UI مختلف، الـ acquisition مختلف، الـ value prop مختلف، الـ monetization مختلف.
- **محاولة خدمة الاتنين فالـ MVP = موت محقق** (anti-pattern #17).

### الخيارات

**الخيار A — محلات فقط (Shop-First)**
- التركيز: بقالة، صيدلية، ملابس، عطارة، إلكترونيات
- الـ Value prop: "اعرف كل محلات قريتك + شوف منتجاتهم + كلمهم"
- Onboarding: صور المحل، صور المنتجات، أسعار
- الـ User flow: browse → product → WhatsApp
- **Pros:** الـ existing direction، الـ memory مهيأ ليه، أسهل onboarding
- **Cons:** المحلات منافستها أعلى (Facebook Marketplace، WhatsApp Catalog)

**الخيار B — خدمات و حرفيين فقط (Service-First)** ⭐ (مفاجأة)
- التركيز: سباك، كهربائي، نجار، حلاق، مصور، خياط، دكتور
- الـ Value prop: "لاقي الحرفي اللي محتاجه فقريتك — مع صور لشغله السابق"
- Onboarding: صور للأعمال السابقة (portfolio)، التواصل عبر WhatsApp
- الـ User flow: browse → craftsman portfolio → WhatsApp
- **Pros:**
  - الـ pain أوضح (الناس فعلاً ما بيلاقوش حرفي ثقة)
  - أقل منافسة (Facebook غير منظم للحرفيين)
  - **Vezeeta proved this** — أقرب Egyptian success
  - أصحاب المحلات بيظهروا فالـ Phase 2
- **Cons:** الـ portfolio لازم يتجمع manually (تيم ميداني يصوّر شغلهم)، الـ مزود بيكون أصعب onboarding

**الخيار C — الاتنين معاً (Current Plan)**
- نفس المعمار الحالي
- **Pros:** marketing message أوسع
- **Cons:**
  - 2x onboarding effort
  - 2x UI complexity
  - الـ value prop بيتشتت
  - **research_09 + anti-pattern #17 ضد ده صراحة**

### توصيتي: **الخيار B (Service-First)** ⭐ بشدة

**ليه:**
1. **الـ pain أوضح:** "محتاج سباك" = طلب فوري متكرر فالقرية. "محتاج بقالة" = الـ user عارف بقالين القرية بالفعل.
2. **Vezeeta proved this فالسوق المصري:** نفس النموذج، أنجح Egyptian local platform.
3. **الـ moat أقوى:** Portfolio (صور شغل سابق) = حاجة Facebook ميقدرش يعملها كويس.
4. **WhatsApp Catalog مش منافس قوي للحرفيين** زي ما هو منافس للمحلات.
5. **الـ monetization أوضح بعدين:** الحرفي بيكسب لما حد يطلبه، فبيدفع. صاحب المحل قيمته أقل وضوحاً.
6. **Phase 2 = إضافة المحلات** — مفيش loss على المدى الطويل.

> **ملحوظة لو اخترت B:** الفكرة كلها بتتعدّل بشكل جذري. كل الـ existing code للمحلات يبقى مرجع، مش أساس.

---

## القرار 3: الـ Authentication — Phone OTP أم Email؟

### Context
الـ existing implementation = Email + Email confirmation + Custom SMTP via Resend.
- ([research_06]) 25.2% من ريف مصر أمي.
- ([research_03]) Phone هو الـ ID الفعلي فمصر، مش Email.
- 56M Egyptian WhatsApp user — كلهم بـ phone، مش Email.
- (anti-pattern #12) Email signup للريف = خطأ استراتيجي.

### الخيارات

**الخيار A — Phone + OTP فقط** ⭐
- SMS provider مصري (Mobily، Vodafone، إلخ) لـ OTP
- تكلفة: ~0.10-0.30 جنيه/OTP
- 60 ثانية تسجيل
- **Pros:** native للريف، WhatsApp يقدر يستلم OTP لو في WhatsApp Business API
- **Cons:** التكلفة SMS، التعقيد قليلاً

**الخيار B — Email فقط (الـ Existing)**
- الـ Email + confirmation link الحالي
- **Pros:** بناه إنت بالفعل، Free (عدا تكلفة Resend)
- **Cons:** الجمهور المستهدف 30-40% منهم مفيش email active

**الخيار C — Phone أو Email (الـ user يختار)**
- يدعم الاتنين
- **Pros:** flexibility
- **Cons:** 2x complexity، 2x bugs، 2x support

### توصيتي: **الخيار A (Phone OTP فقط)** ⭐

**ليه:**
1. كل research وافق ده.
2. **مفيش انتظار للريف يتعلم الإيميل.**
3. لو في حد فالقرية مش عنده smartphone (نادر بس وارد)، عنده تليفون بسيط = SMS بيوصل.
4. التكلفة منخفضة جداً.
5. تقدر تستخدم WhatsApp OTP بدل SMS لاحقاً = أسرع و أرخص و أقرب لجمهورك.

**الـ Migration path:**
- الـ existing Resend SMTP يتقفل (وفّر تكلفة).
- اشترك فـ SMS provider مصري (Vodafone Business، Mobily، Twilio).
- الـ existing Email users (مفيش غالباً) = منسحب.

---

## القرار 4: الـ WhatsApp Integration — أنهي نموذج؟

### Context
بناءً على research_08 (WhatsApp-first)، فيه 3 خيارات. الـ WhatsApp مش "feature"، هو **العمود الفقري**.

### الخيارات

**الخيار A — Pure Deep-Link (Classifieds Model)**
- على كل صفحة محل/حرفي، زرار "تواصل واتساب" يفتح WhatsApp مباشرة بـ pre-filled message
- مفيش in-app chat، مفيش tracking للمحادثات
- **Pros:** بسيط جداً، صفر cost، صفر policy risk، كل المنصات MENA الناجحة بتعمل ده (OLX، Hatla2ee، Aqarmap)
- **Cons:** مفيش data عن التحويلات الفعلية، مفيش control

**الخيار B — Hybrid (In-app discovery + WhatsApp communication)** ⭐
- نفس Option A
- + Click tracking ("X واحد ضغط واتساب اليوم" للمحل)
- + Pre-filled message محسّن (اسم المحل + استفسار افتراضي)
- **Pros:** أحسن analytics، يمكّن monetization لاحقاً (sponsored = أكتر clicks)
- **Cons:** complexity أكتر شوية

**الخيار C — WhatsApp Business API + Chatbot**
- WASALNI يكون chatbot رسمي على WhatsApp
- البحث، الـ discovery، التواصل كله من WhatsApp
- **Pros:** زيرو app friction، الـ users فالـ habit
- **Cons:** WhatsApp Business API مكلف ($0.01-0.05/message عند Meta)، policy risk عالي، complex setup

### توصيتي: **B (Hybrid) للـ MVP — لكن ابدأ بـ Option C كـ Pre-MVP Manual**

**ليه:**
- **Phase Manual (شهر 1-2):** WhatsApp Channel "وصلني كفر المقدام" يبدأ كـ broadcast — أنت تنشر المحلات يدوياً، الناس بيتواصلوا مع المحل مباشرة.
- **Phase MVP (شهر 3+):** Hybrid model فالـ app. زرار WhatsApp ضخم على كل صفحة. tracking للضغطات.
- **مفيش in-app chat فالـ MVP. أبداً.**
- **مفيش WhatsApp Business API automation فالـ MVP** — لاحقاً لما تثبت الـ value.

---

## القرار 5: الـ Existing Codebase — احذف، احفظ، أم سايدلاين؟

### Context
عندك دلوقتي:
- Flutter app كامل (auth + signup + signin + guest browsing + bloc structure)
- Supabase schema + RLS + migrations
- Next.js admin app
- 62 tests passing
- مكتوب فـ specs (1951 سطر)

السؤال: ايه نعمل بيه؟

### الخيارات

**الخيار A — Burn It All Down (نسخة جديدة من الصفر)**
- ابدأ مشروع جديد
- **Pros:** clean slate، مفيش tech debt، fresh thinking
- **Cons:** خسرت work قيّم، الـ Bloc + Clean Architecture اللي اتبنى ممكن يتعاد استخدامه

**الخيار B — Keep Foundation, Change Approach** 
- خلي الـ Bloc + Clean Architecture + Supabase
- غيّر: Auth (Email → Phone)، Models (Shop → Service Provider)، UI flow
- **Pros:** ما تحرقش العمل، الـ patterns صح
- **Cons:** الـ existing schema/models مبنية حوالين المحلات، الـ rebuild هيكون كبير

**الخيار C — Sideline During Manual MVP** ⭐
- التطبيق "موقّف" لمدة 60 يوم.
- مفيش commits، مفيش تطوير.
- الـ Manual MVP بيشتغل فالـ WhatsApp.
- لما ترجع، **تختار** بناءً على ايه اللي اتعلمته فالـ 60 يوم:
  - لو الـ scope الجديد مشابه للـ existing → restart from existing (Option B)
  - لو الـ scope مختلف جذرياً → fresh start (Option A)
- **Pros:** ما تتعجلش القرار، الـ learning من Manual بيوضّح ايه قابل لإعادة الاستخدام
- **Cons:** خسرت momentum على الـ existing code

### توصيتي: **الخيار C (Sideline)** ⭐

**ليه:**
1. القرار "burn or keep" مش لازم ياخد دلوقتي. الـ Manual هيوضّحه.
2. الـ existing code = sunk cost. تخليه على branch، تنساه، ترجع بعدين بإجابة واضحة.
3. **branch:** `001-authentication-profile` يفضل كما هو. كأنه archive.
4. **branch جديد** للـ rebuild لما يبدأ — `002-rebuild-from-zero`.
5. الـ specs الموجودة = مرجع تعلّمت منه. اقرأها للـ documentation، مش للتنفيذ.

---

# 🟠 TIER 2 — قرارات مهمة (خلال الـ MVP)

## القرار 6: الـ Categories الأولى — ايه نطلق بيهم؟

### Context
الـ MVP موجّه لـ Service Providers (لو اخترت Option B فالقرار #2). أنهي تخصصات نطلق بيهم أولاً؟

### الخيارات (multi-select)

**الفئة 1 — البيت (Home Maintenance)** ⭐
- سباك، كهربائي، نجار، حداد، نقاش، مكييفات
- **Pain frequency:** متوسط، بس عالي القيمة لما يحصل
- **Trust requirement:** عالي (يدخل بيتك)

**الفئة 2 — العناية الشخصية**
- حلاق، كوافير، مكياج، خياط، تدليك
- **Pain frequency:** عالي (شهري)
- **Trust requirement:** متوسط

**الفئة 3 — الخدمات الصحية**
- دكتور، صيدلية، تمريض منزلي، تحاليل، أشعة
- **Pain frequency:** عالي
- **Trust requirement:** عالي جداً
- **ملاحظة:** Vezeeta موجود — competition

**الفئة 4 — التعليم**
- مدرسين خصوصي، دروس قرآن، تعلم حرف
- **Pain frequency:** موسمي (مدرسي)
- **Trust requirement:** عالي

**الفئة 5 — المناسبات**
- مصور، DJ، طبّاخ، تجهيزات الأفراح
- **Pain frequency:** منخفض، بس عالي القيمة
- **Trust requirement:** عالي

### توصيتي: **الفئة 1 (البيت) فقط فالـ MVP** ⭐

**ليه:**
1. الـ pain متكرر و واضح.
2. **مفيش competition** (Facebook غير منظم تماماً للسباكين).
3. الـ portfolio = صور سابقة بسيطة (cheap to collect).
4. الـ verification = شهادة من جار سابق + صور للأدوات + ID.
5. التوسع لباقي الفئات سهل لاحقاً (نفس النموذج، categories جديدة).

> **ملاحظة:** الـ Vezeeta competition فالطب = مش worth it للـ MVP. اتركها لاحقاً لو في فرصة فالقرى تحديداً.

---

## القرار 7: متى يبدأ الـ Monetization؟

### Context
([research_05]) Premature monetization = killer. ([research_01]) Khatabook + OkCredit بدأوا free لسنين.

### الخيارات

**الخيار A — مجاني تماماً لـ 12 شهر، monetize 2027**
- 2026: مجاني للـ users و الـ providers
- 2027 Q1-Q2: نضيف sponsored placements ("احسن النتائج" مدفوع)
- 2027 Q3+: نفكّر فـ subscriptions (لو في scale)
- **Pros:** أكبر acquisition، أعلى trust
- **Cons:** runway يحتاج funding

**الخيار B — مجاني 6 شهور، monetize H2 2026** ⭐
- يونيو-ديسمبر 2026: مجاني تماماً
- يناير 2027: sponsored placements (ليه؟ لأن لو المحلات/الحرفيين لقوا قيمة، هيدفعوا).
- **Pros:** أسرع revenue، التوقيت مناسب لـ Q1 budgets للمحلات
- **Cons:** ممكن يكسر momentum

**الخيار C — Hybrid: مجاني، بس sponsored اختياري من اليوم الأول**
- كل واحد free
- بس فيه option للـ premium listing مدفوع من اليوم الأول
- **Pros:** بيختبر willingness to pay early
- **Cons:** distraction من الـ MVP

### توصيتي: **الخيار A (Free لـ 12 شهر)** ⭐

**ليه:**
1. لو نجح، الـ monetization بييجي طبيعياً من الـ shops/providers اللي حصّلوا قيمة.
2. لو فشل، الـ monetization كان مش هيوصّل لـ revenue كافي على أي حال.
3. **Khatabook + Vezeeta + Fawry** كلهم free لسنين قبل ما يبدأوا monetization.
4. **سؤال محتاج تجاوب عليه:** هل عندك runway لـ 12 شهر بدون revenue؟ لو لأ، نناقش Phase 0 funding/sustainability.

---

## القرار 8: التوسع الجغرافي — متى نضيف قرى تانية؟

### Context
الـ memory بيقول "كفر المقدام + القرى المجاورة". research_03 + research_05 ضد ده.

### الخيارات

**الخيار A — كفر المقدام فقط لـ 6-12 شهر** ⭐
- صبر على قرية واحدة
- الـ kill criteria محددة قبل ما نوسع
- التوسع = قرية واحدة جديدة كل 3 شهور

**الخيار B — كفر المقدام + 2-3 قرى مجاورة فالـ launch**
- شبكة من 4 قرى
- **Cons:** الـ field team متشتت، الـ density ضعيفة

**الخيار C — كفر المقدام + ميت غمر (الـ center)**
- القرية + المدينة الكبيرة اللي بتتبعها
- **Cons:** ميت غمر سوقها مختلف (280k نسمة، أكتر تنظيماً)

### توصيتي: **الخيار A (كفر المقدام فقط)** ⭐

**ليه:** density > coverage. الـ Bootstrap research قاطع فده.

**Kill criteria قبل التوسع:**
- 30+ مزود خدمة active فالقرية
- 200+ DAU
- 30%+ retention فـ 30 يوم
- $X+ revenue منفعّل (لو monetization بدأ)

لو فالشهر السادس مفيش الـ metrics دي → التوسع مش هيحلّ المشكلة، الـ product محتاج pivot.

---

# 🟡 TIER 3 — قرارات Process / Design

## القرار 9: Spec Kit — نكمّل ولا نوقف؟

### Context
([anti-pattern #16]) Spec Kit ceremony بدون فريق = إضاعة وقت.

### توصيتي: **أوقف Spec Kit لـ 90 يوم** ⭐

- الـ existing specs (`specs/001-authentication-profile/`) = archive
- البديل: ملف واحد `current_plan.md` يتحدث كل أسبوع
- لما يبقى عندك engineer مشارك، نرجعله
- الـ commit messages + الـ git log = الـ documentation الكافية للـ solo founder

---

## القرار 10: Web Fallback — نبنيه ولا لأ؟

### Context
([anti-pattern #6]) Mobile-only بدون web = خسارة جمهور.

### الخيارات

**الخيار A — Mobile only**
- نفس الـ existing direction
- **Cons:** الـ user اللي ضغط link فواتساب ميقدرش يفتحه على الـ web

**الخيار B — Mobile + Web Profile Pages (Read-only)** ⭐
- الـ app الأساسي = Flutter
- بس كل صفحة محل/حرفي ليها URL على الويب (Next.js admin بتقدر تعمل ده)
- مفيش web app كامل، بس "صفحة عرض" تشتغل فالـ browser
- **Pros:** Google search يلاقي المحلات، WhatsApp links تفتح كل مكان
- **Cons:** شغل إضافي

### توصيتي: **الخيار B (Mobile + Web Profile Pages)**

**ليه:**
- Justdial كانت web أولاً، app ثانياً. مفيش سبب نخسر web traffic.
- الـ Next.js admin اللي عندك ممكن يعمل profile pages بسهولة.
- SEO قيمة طويلة المدى.

---

## القرار 11: الـ Field Team — نختبره ولا نعتمد عليه؟

### Context
([anti-pattern #18]) الـ memory بيقول "field team جاهز" — بدون اختبار حقيقي.

### توصيتي: **نزل بنفسك قبل ما تعتمد على الفريق** ⭐

**Plan:**
1. **أسبوع 1:** نزل كفر المقدام بنفسك، اعمل 5 onboardings مع 5 سباكين/كهربائيين.
2. وثّق كل حاجة: الوقت، الاعتراضات، الأسئلة، ايه شغّال، ايه فشل.
3. اكتب **Field Playbook** بناءً على التجربة (مش بناءً على تخيّل).
4. **أسبوع 2:** درّب agent واحد على الـ playbook، اعمل 5 onboardings تانية، شاهده.
5. **أسبوع 3:** الـ agent يشتغل لوحده، إنت بتشاهد و تحسّن.
6. **أسبوع 4+:** scale.

---

## القرار 12: Reviews/Ratings — مؤجّلة، صح؟

### Context
([anti-pattern #4]) Reviews فالـ MVP = خطر قانوني + social drama فالقرية.

### توصيتي: **مؤجّلة 100%. اتمسك بالقرار ده.**

- Phase 1 (MVP): مفيش reviews، مفيش stars.
- Phase 2 (بعد 12 شهر): نفكر فـ "Endorsements" (شارة "موصى به من 3 جيران") — مش Yelp-style.

---

# 📋 ملخص الـ 12 قرار + توصياتي

| # | القرار | توصيتي |
|---|---|---|
| 1 | المسار قبل MVP | **Manual MVP (60 يوم WhatsApp قبل أي كود)** |
| 2 | نوع الـ Supply الأول | **Services / حرفيين** (مفاجأة — اقرأ ليه) |
| 3 | الـ Auth | **Phone + OTP فقط** (مش Email) |
| 4 | WhatsApp Integration | **Hybrid في الـ MVP، Manual فالـ pre-MVP** |
| 5 | الـ Existing Codebase | **Sideline (branch منفصل، نقرر بعد Manual)** |
| 6 | الـ Categories الأولى | **البيت فقط (سباك، كهربائي، نجار، حداد، نقاش)** |
| 7 | متى يبدأ الـ Monetization | **مجاني لـ 12 شهر** |
| 8 | التوسع الجغرافي | **كفر المقدام فقط لـ 6-12 شهر** |
| 9 | Spec Kit | **أوقف لـ 90 يوم** |
| 10 | Web Fallback | **Mobile + Web Profile Pages (read-only)** |
| 11 | Field Team | **نزل بنفسك قبل ما تعتمد عليه** |
| 12 | Reviews | **مؤجّلة 100%** (يتفق مع الـ existing decision) |

---

## ⚠️ القرارات اللي أكتر تأثيراً (لو ضغط الوقت)

لو محتاج تركّز على 3 قرارات فقط دلوقتي، هي:

1. **القرار 1 (Manual أم Code):** هيحدد كل الـ timeline.
2. **القرار 2 (Services vs Shops):** هيحدد كل الـ product direction.
3. **القرار 5 (Existing codebase):** هيحدد ايه نعمل بالـ work السابق.

الباقي يستنى أنت تتفق على دول الأول.

---

> الخطوة التالية: ارجع لي بإجاباتك على الـ 12 قرار. هنناقش أي قرار محتاج تفصيل أكتر، و بعدها هنعمل [`recommendations.md`](./recommendations.md) (خطة استراتيجية كاملة بناءً على اختياراتك).
