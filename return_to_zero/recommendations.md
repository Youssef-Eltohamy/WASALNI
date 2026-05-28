# 🚀 توصياتي الاستراتيجية — لو إنت أنا، هعمل ايه

> **الغرض:** بعد ما درست 9 abreasts و حالات شبيهة، ده ايه هعمله لو WASALNI مشروعي.
> **مش "خطة نهائية"** — مش هتبدأ تنفذ قبل ما تختار من [`decisions_needed.md`](./decisions_needed.md). بس ده الأقرب لخطة كاملة بناء على البحث.
>
> **تاريخ:** 2026-05-26

---

## 🧭 الـ Big Picture — التشخيص

### إنت دلوقتي فين؟
- ✅ **عندك رؤية واضحة** + اسم + هوية بصرية + جمهور محدد + قرية انطلاق
- ✅ **عندك تيم ميداني محتمل + شراكات إقليمية**
- ✅ **عندك مهارات تقنية و أدوات (Claude Code + الـ AI tools)**
- ⚠️ **عندك code كتير اتعمل بدون validation** = sunk cost
- ❌ **مفيش customer discovery** = أكبر فجوة
- ❌ **مفيش distribution plan** = الفجوة التانية
- ❌ **عندك تخطيط تقني أكتر بكتير من تخطيط commercial**

### إنت محتاج توصل لفين؟
- خلال **6 شهور:** تطبيق نشط فكفر المقدام بـ 50+ مزود خدمة + 200+ DAU + retention > 25%
- خلال **12 شهر:** 5+ قرى، early revenue، product-market fit واضح
- خلال **24 شهر:** التوسع الإقليمي + monetization مفعّل + funding round (لو محتاج)

### الفرق بين "ايه عندك" و "ايه محتاج":
> **مش code إضافي. هو validation و distribution.**

---

## 🎯 المخطط الأكبر — 4 مراحل

```
[الآن]
   │
   ├── Phase 0: المنحنى الميداني (60 يوم) ◄── إنت هنا بعد القراءة
   │   • Manual MVP على WhatsApp
   │   • 50 مزود + 200 user
   │   • Validate / Pivot / Kill
   │
   ├── Phase 1: MVP الحقيقي (3-6 شهور)
   │   • App بسيط جداً (4 شاشات بس)
   │   • Service-first
   │   • Mobile + Web Profile Pages
   │
   ├── Phase 2: التوسع المحلي (6-12 شهر)
   │   • 3-5 قرى
   │   • Sponsored placements (monetization start)
   │   • Categories أكتر
   │
   └── Phase 3: Regional (12-24 شهر)
       • محافظة كاملة
       • Subscription tier للمحلات
       • Funding round
```

---

# Phase 0 — المنحنى الميداني (الـ 60 يوم القادمين)

> **القاعدة:** صفر سطر كود جديد. كل الوقت فالـ field + Manual MVP.

## أسبوع 1-2: الاستكشاف العميق

### الأهداف
- اكتشف كفر المقدام **بنفسك**.
- اعمل **20 مقابلة بـ "Mom Test"** (10 users + 10 محتمل مزوّد خدمة).
- اطّلع على شبكات الـ trust الموجودة (الإمام، العمدة، أكبر محل).

### الفعليات

**اليوم 1-3: التحضير**
- اقرأ [`research_07_bootstrap_playbook.md`](./research_07_bootstrap_playbook.md) — الـ Mom Test framework.
- اكتب **20 سؤال** بصيغة "آخر مرة احتجت X، عملت ايه؟".
- جهّز Google Form أو ورقة لتسجيل الإجابات.

**اليوم 4-10: المقابلات مع الـ Users**
- نزل كفر المقدام (يومين فالأسبوع).
- 10 مقابلات مع users (نساء، رجال، شباب، كبار) — مزيج.
- **أسئلة gold:**
  - "آخر مرة احتجت سباك، عملت ايه؟ كم دفعت؟ كم استنى؟ كنت راضي؟"
  - "آخر مرة سألت حد عن محل، السؤال كان فين؟ (واتساب، فيسبوك، شخصياً)"
  - "أكتر مشكلة لما بتدوّر على خدمة فالقرية، ايه هي؟"
  - "لو في تطبيق يعرّفك على سباك ثقة، ايه أكتر سؤال هتسأله عليه؟"
- وثّق كل إجابة. **مفيش رأي شخصي منك فالمقابلة.**

**اليوم 11-14: المقابلات مع المزودين المحتملين**
- 10 سباكين/كهربائيين/نجارين/خياطين فالقرية.
- **أسئلة gold:**
  - "ازاي بيوصلوا لك العملاء حالياً؟"
  - "أكتر مشكلة عندك مع العملاء؟"
  - "لو تطبيق هيوصّل لك عملاء من قرية مجاورة، ايه هتدفع له؟"
  - "محتاج إيه عشان تثق فتطبيق جديد؟"

### الـ Output
- ملف `field_notes_week_1_2.md` فيه:
  - أكتر 5 pain points متكررة من الـ users
  - أكتر 5 pain points من المزودين
  - فهم واضح لـ "مين بيدور على ايه"
  - قائمة الـ trust nodes (أسماء حقيقية: العمدة فلان، الإمام علان، أكبر سباك ابو فلان)

### Kill Signal فالأسبوع 1-2
- لو الـ 20 مقابلة ما طلعتش pain point واحد متكرر = الفكرة مش solving real problem. **توقف، أعد التفكير.**

---

## أسبوع 3-4: الـ Manual MVP يطلق

### الأهداف
- يلق "وصلني كفر المقدام" Channel على WhatsApp.
- ابدأ تجمّع المزودين (المستهدف: 15-20 فالأسبوع).
- ابدأ تنشر "محتوى" يستفيد منه الـ users.

### الفعليات

**اليوم 15-17: الإعداد**
- اعمل **WhatsApp Channel** (مش جروب، Channel — broadcasting one-way).
- الاسم: "وصلني كفر المقدام 📍"
- الوصف: "كل خدمات و حرفيين القرية فمكان واحد. مجاني تماماً."
- اعمل **Facebook Page** بنفس الاسم (للجمهور اللي مش على الـ Channel).
- اعمل **Google Sheet** كـ database للمزودين (Name, Phone, Category, Photos, Trust signals).

**اليوم 18-21: الـ "أنبوب الذهب" (Anchor Strategy)**
- روح للسباك الأشهر فالقرية بنفسك.
- قول له: "أنا بحاول أعمل حاجة تساعد القرية. هل تقبل تكون أول واحد فالخدمة؟ بدون فلوس، بس صور لشغلك السابق."
- صوّر شغله (5-8 صور أعمال سابقة).
- اطلع منه إجابات على: الخدمات اللي بيقدمها، الأسعار، ساعات العمل، رقم WhatsApp.
- اعمل أول "post" على الـ Channel: صور + اسم + تخصص + رقم.
- ⚠️ **هذا الشخص = الـ Anchor.** لو اقتنعت اللي بعده، إنت كسبت.

**اليوم 22-28: الـ Snowball**
- روح للكهربائي الأشهر، النجار، الحداد، النقاش... كل تخصص.
- "السباك ابو فلان جربها — تيجي تجرّب؟"
- المستهدف: **10-15 مزود فالأسبوع الأول من الـ active outreach**.

**اعمل Posts يومية على الـ Channel:**
- اليوم: مزود جديد
- بكرا: "كل سباكين كفر المقدام — قائمة"
- بعده: tip "ازاي تختار سباك ثقة"
- بعده: مزود جديد
- إلخ.

### الـ Distribution Hacks (مش Marketing فلوس)

1. **خطبة الجمعة:** كلّم الإمام، اشرح، اطلب 30 ثانية فالخطبة "في تطبيق للقرية".
2. **القرى المجاورة:** المزود فالـ Channel لما يقتنع، هيشير الـ link.
3. **مدرس البلد:** بعت الـ link لمجموعة أولياء الأمور.
4. **TikTok قصيرة:** فيديو 30 ثانية فالقرية، التاج جغرافي.
5. **QR على كل محل مسجل:** "شوف صفحتي على وصلني".

### Kill Signal فالأسبوع 3-4
- **أقل من 10 مزود متعاون فالأسبوع 4** = الـ value prop مش واصل.
- **أقل من 50 follower على الـ Channel فالأسبوع 4** = الـ distribution مش شغال.
- لو الاتنين: **توقف، أعد التفكير.**

---

## أسبوع 5-8: التحسين + الـ Validation

### الأهداف
- 30-50 مزود نشط على الـ Channel.
- 200-500 follower للـ Channel.
- 20+ "تحويلات حقيقية" (Users بيكلموا المزودين بناءً على الـ Channel).
- فهم واضح: ايه السبب الحقيقي للناس بتستخدم الـ Channel؟

### الفعليات

**أسبوع 5-6:**
- ركّز على الـ retention: ايه الـ users بيشاركوا الـ Channel ولا لأ؟ ايه الـ posts بتاخد أكتر views؟
- **اعمل follow-up:** الـ users اللي اتواصلوا، اتصل بيهم بعد أسبوع و اسأل "وصلت لإيه؟"
- وثق كل تحويلة: من User → Provider → Outcome.

**أسبوع 7-8:**
- ابدأ تجرب feature صغيرة على الـ Channel:
  - "بحث": user بيبعت "محتاج سباك"، إنت ترد بأسماء.
  - "tag" للـ posts: #سباك #كهربائي عشان الـ users يقدروا يبحثوا.
- **خلي 5 users يساعدوا** فالـ moderation/curation (الـ Anchors من الـ users).

### الـ Output النهائي لـ Phase 0
ملف `phase_0_learnings.md` فيه:
- ايه الـ pain points الحقيقية للقرية؟
- ايه أكتر category بيتطلب؟
- ايه أكتر دافع للمزودين؟
- ايه أكتر معوق؟
- **القرار الكبير:** نكمل لـ Phase 1 (App build)، ولا pivot، ولا close؟

### Kill Criteria قبل Phase 1
نكمل لـ Phase 1 لو **و فقط لو:**
- ✅ 30+ مزود active
- ✅ 300+ Channel followers
- ✅ 20+ verified conversions (User → WhatsApp message → real meeting/transaction)
- ✅ 5+ unprompted shares (الناس بتشير الـ link بدون ما إنت تطلب)
- ✅ NPS قياسي بسيط: "من 1-10، تنصح صاحبك بـ وصلني؟" — متوسط 7+

لو 4 من 5 = نكمل بحذر. لو 3 أو أقل = **stop and reflect**.

---

# Phase 1 — الـ MVP الحقيقي (شهر 3-6)

> **الـ Trigger للبدء:** Phase 0 نجحت. عندك validation حقيقي.

## الـ MVP الفعلي — 4 شاشات فقط

> **مش 9 features. مش 92 task. 4 شاشات.**

1. **Splash + Onboarding (3 شاشات بسيطة)**
2. **الـ Home Feed** — كل المزودين فكفر المقدام، uniform 2-column + filter by category + Map view tab
3. **صفحة المزود** — Portfolio + بيانات + زرار WhatsApp ضخم
4. **بحث + filter**

### Auth
- Phone + OTP فقط
- Guest browsing بدون auth
- Auth بس عند "احفظ مفضلة" أو "سجّل مزود جديد"

### Backend
- Supabase (الـ existing setup يفضل، بـ schema جديد)
- Schema بسيط:
  - `villages` (نبدأ بـ Kafr El-Maqdam)
  - `providers` (mam, phone_e164, whatsapp_e164, category_id, village_id, status, ...)
  - `provider_photos` (portfolio)
  - `categories` (manual seed: سباك، كهربائي، نجار، حداد، نقاش، خياط)
  - `users` (phone-based)
  - `favorites` (user_id, provider_id)
- ⚠️ **مفيش shops table** فالـ MVP. (تأتي فـ Phase 2.)

### Admin Panel
- Next.js admin (موجود) يشتغل لـ:
  - مراجعة مزودين جدد
  - upload photos نيابة عن المزود
  - manual feature/unfeature
- ⚠️ **مفيش admin features معقدة** فالـ MVP.

### Web Profile Pages
- Next.js generates `/p/kafr-el-maqdam/abu-ahmed-plumber` لكل مزود
- Read-only
- بـ Open Graph image علشان WhatsApp shares تبان حلوة

### تكاملات
- WhatsApp deep-link مع pre-filled message
- Phone call deep-link
- Google Maps deep-link لموقع المزود

### الإحصائيات اللي بنتتبعها (Internal)
- DAU / WAU
- Click-through rate من المزود لـ WhatsApp
- Repeat sessions per user
- Time to first WhatsApp click

### Tech Stack النهائي
- **Mobile:** Flutter (يفضل) — بس بـ scope بسيط
- **Backend:** Supabase (الـ existing — بس schema جديد)
- **Admin:** Next.js (الـ existing)
- **SMS:** Vodafone Business أو Twilio
- **Storage:** Supabase Storage (للصور)
- **Analytics:** PostHog (مجاني tier)، Mixpanel، أو حتى Supabase queries مباشرة

### تكلفة Phase 1 (شهور 3-6)
- SMS OTP: ~$50/month
- Supabase: $0-25/month (Free tier ممكن يكفي)
- Vercel: $0 (Free tier)
- Domain + SSL: $20/year
- Field agent (لو موظف): $300-500/month
- **Total monthly burn: ~$400-600**

---

# Phase 2 — التوسع المحلي (شهر 6-12)

## Triggers للدخول
- 50+ مزود active فكفر المقدام
- 200+ DAU
- 25%+ retention على 30 يوم
- 5+ verified weekly transactions (people meeting providers)

## الاستراتيجية
1. **توسع لقرية مجاورة واحدة فقط.** نموذجياً قرية بنفس الـ profile لكفر المقدام.
2. **أضف category تانية:** "العناية الشخصية" (حلاق، خياط، إلخ) أو "المناسبات" (مصور، طبّاخ).
3. **ابدأ Sponsored Placements:**
   - مزود بيدفع 50-100 جنيه/شهر يبقى فأعلى الـ feed لقسمه.
   - **مش لكل المزودين** — فقط اللي عايز يدفع.
4. **أضف نوع supply تاني محدود:** المحلات (شوب owners). بس categories محدودة (مأكولات، عطارة).

### قياسات النجاح
- Revenue: 1000-3000 جنيه/شهر sponsored
- Total active providers: 100-150
- Total DAU: 500-1000
- Geographic coverage: 2 قرى

---

# Phase 3 — Regional (شهر 12-24)

## Triggers
- 150+ active providers
- 1000+ DAU
- Sponsored revenue $200-500/month
- 30%+ retention

## الاستراتيجية
1. **توسع لمدينة ميت غمر** (الـ center) — وحدة جغرافية اقتصادية كاملة.
2. **Subscription tier للمحلات:**
   - Basic: 50 جنيه/شهر — 5 منتجات + بيانات أساسية
   - Pro: 200 جنيه/شهر — منتجات unlimited + sponsored placements + analytics
3. **Funding round** (لو محتاج للتوسع للمحافظة):
   - 50,000-100,000 USD pre-seed
   - Egyptian VC أو MENA-focused

---

# 💰 Budget & Runway

## Phase 0 (60 يوم)
- WhatsApp Business app: مجاني
- Google Workspace: $6/شهر
- مواصلات + توصيل للقرية: 1000-2000 جنيه/شهر
- Anchor incentives (شاي + crowd-funding غداء): 500-1000 جنيه/شهر
- **Total: ~$50-100/month**

## Phase 1 (شهر 3-6)
- SMS + Supabase + tools: ~$100/month
- Field agent (optional): $300-500/month
- Marketing/content (TikTok ads test): $50-100/month
- **Total: $500-700/month**

## Phase 2 (شهر 6-12)
- Tools scaling: $200/month
- 2 field agents: $700/month
- Marketing: $200/month
- Customer support: $200/month
- **Total: $1,500-2,000/month**

### السؤال المهم لك
**هل عندك runway لـ 12 شهر بـ $20,000-25,000 total burn؟**
- لو آه: ممتاز، نمشي بالخطة.
- لو لأ: نناقش الـ funding/sustainability options:
  - Self-funded من شغل يومي (slower)
  - Early Egyptian angel ($5-15k)
  - Flat6Labs / Falak Startups / EFG-EV Fintech
  - Grants (MIT Pan Arab Competition، MCIT initiatives)

---

# 🚨 Kill Criteria — متى تقفل

تجنّب الـ "founder بيكمل بالأمل" trap. **اقفل لو:**

### Phase 0 (60 يوم)
- ❌ أقل من 20 مزود active فنهاية Phase 0
- ❌ أقل من 200 channel follower
- ❌ صفر unprompted shares
- ❌ مزودك الأول قال "مش هكمل"

### Phase 1 (6 شهور)
- ❌ DAU سقف عند 100 لمدة شهرين
- ❌ Retention 30-day أقل من 15%
- ❌ صفر paid sponsored signups فالشهر 6
- ❌ Field agent cost-per-acquired-provider > 200 جنيه

### Phase 2 (12 شهر)
- ❌ Total burn > revenue × 50
- ❌ No clear path to break-even
- ❌ Founder time still 80% in tech, not market

---

# 🎁 الـ Quick Wins — الـ 30 يوم القادمين

لو محتاج تبدأ **بكرا** بدون انتظار قرارات:

## اليوم 1-3
1. **اعمل Google Sheet "WASALNI Kafr El-Maqdam Providers"** بـ columns:
   - Name | Phone | Category | Address | Portfolio Photos URL | Trust Notes | Status
2. **اعمل WhatsApp Channel** بالاسم.
3. **اقرأ Rob Fitzpatrick's "Mom Test"** (كتاب 100 صفحة، يقرأ فـ 3 ساعات).

## اليوم 4-10
1. **روح كفر المقدام يومين فالأسبوع** (لو ميت غمر قريبة منك).
2. **اعمل 5 مقابلات** يومياً بـ Mom Test.
3. **سجل النتائج** فالـ Google Sheet.

## اليوم 11-30
1. **حدد الـ Anchor:** الـ سباك الأشهر فالقرية.
2. **اقنعه** يكون أول مزود فالـ Channel.
3. **انشر post واحد كل يومين** على الـ Channel.
4. **track**: views، messages، shares.

> **بدون أي كود إضافي. صفر سطر Dart. كل التركيز على الـ field.**

---

# 🔑 الـ 7 Insights الكبرى من البحث (تذكير)

1. **المنافس الحقيقي = HABIT (فيسبوك + واتساب)، مش app آخر.**
2. **WhatsApp = طبقة التواصل. WASALNI = طبقة الاكتشاف فوقه.**
3. **قرية واحدة، شارع واحد، 50 مزود = الـ Atomic Network.**
4. **Manual MVP أولاً. Code تيجي تاني.**
5. **Service Providers ≠ Shop Owners. اختر واحد فقط للـ MVP.**
6. **Free لـ 12 شهر. Monetization تيجي مع الـ scale.**
7. **Field Team Door-to-Door = الـ Acquisition الوحيد الفعّال للريف.**

---

## 🤝 الخطوة التالية معاي

1. اقرأ هذا الـ document + [`decisions_needed.md`](./decisions_needed.md).
2. ارجع لي بـ **إجاباتك على الـ 12 قرار** فالـ decisions file.
3. هنناقش أي قرار محتاج تفاصيل أكتر.
4. بعد ما نتفق، **هنعمل Plan تنفيذي محدد للـ 60 يوم القادمين** + cleanup للـ repo (سايدلاين الـ existing code، setup الـ Phase 0 infrastructure).

> **هدفنا:** WASALNI يكون **اللي مفيش حد عمل زيه فمصر**. مش لأن الـ code أحسن، **لأن الـ approach أحسن**.
