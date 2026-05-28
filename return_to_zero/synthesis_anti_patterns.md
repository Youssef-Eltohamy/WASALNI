# ☠️ Synthesis — الـ Anti-Patterns: ايه اللي بيقتل التطبيقات المشابهة

> **التركيب من 9 أبحاث.** كل anti-pattern هنا قتل ٢-٥ تطبيقات حقيقية. لما حاجة بتقتل أكتر من تطبيق، **مش "صعوبة"، هي قاعدة**.
> **تاريخ:** 2026-05-26

---

## 🔴 المنطقة الحمراء (تجنّب 100%)

### Anti-Pattern 1: بناء Backend معقد قبل Validation

**اللي بيموته:** Path، Vine، Citysearch، Foursquare consumer، عشرات الـ Egyptian startups

**القصة:**
- تطبيقات بنت Clean Architecture + microservices + scalable infra **قبل ما يكون عندها 100 user**.
- لما اكتشفوا الـ product wrong، كانوا متغلين فالـ tech debt.
- "Premature scaling" = أكبر سبب وفاة فالـ startups المبكرة ([Sequoia فشل analysis]).

**حالة WASALNI:**
> ⚠️ **إنت دلوقتي فالمنطقة دي تماماً.**
> - Supabase + RLS + pgcrypto + scheduled deletion + Custom SMTP + Flutter Clean Architecture + 92 task + 1951 سطر spec
> - **عدد المستخدمين الحقيقيين:** صفر.
> - **عدد مقابلات customer discovery:** صفر.
> - عملت كل بنية ضخمة قبل ما تتأكد إن في طلب على الفكرة أصلاً.

**القانون:** **حتى لو الـ tech "جاهز"، لا تكمّل بناء فيه قبل ما يكون عندك 50 محل و 100 user حقيقيين على نسخة manual.**

---

### Anti-Pattern 2: نموذج اشتراك Free/Basic/Pro/Premium من اليوم الأول

**اللي بيموته:** كل marketplace بيحاول monetize قبل الـ PMF، Jumia Food (خسر 10 سنين)، Grofers (انكمش من 26 إلى 9 مدن)، Brimore (حرق $30M)

**القصة:**
- المؤسس بيخطّط لـ 4 شرائح اشتراك "علشان يكون فيه scale economics".
- الواقع: **مفيش حد بيدفع لمنصة فيها ٥ محلات.**
- الـ shop owner بيقول "أنا في فيسبوك ببلاش، ليه أدفع لك؟"
- النتيجة: لا users، لا dollars، تطبيق ميت.

**حالة WASALNI:**
> ⚠️ الـ business model الحالي فالـ memory:
> - Free Store / Basic / Pro / Premium = 4 شرائح
> - "Cold Start بيتم بفترة مجانية أول"
>
> **المشكلة:** المنطق ده مبني على افتراض الـ scale بييجي. **هو ميجيش بدون قيمة مثبتة.** عرض 4 شرائح من اليوم الأول بيخوّف المحلات حتى لو الـ tier الأولى مجاني — بيحسوا إن "ده تطبيق هياكل منهم بعدين".

**القانون:**
- **سنة 1: مجاني تماماً.** بدون أي ذكر لشرائح.
- **سنة 2:** sponsored placements + transaction fees (لو في معاملات).
- **سنة 3+:** اشتراكات (لو وصلنا scale يبررها).

---

### Anti-Pattern 3: نموذج Lead-Gen Middleman ("نبيع الـ leads للمحلات")

**اللي بيموته:** Justdial (بعد 2015)، HomeAdvisor، Thumbtack (في الـ rural)، CitySearch

**القصة:**
- المنصة بتاخد رقم تليفون من اليوزر + بياناته
- بتبيع الـ lead للمحلات
- المحلات بتشتكي إن الـ leads "وهمية" أو ميتة
- اليوزرز بيشتكوا إنهم بياخدوا مكالمات spam من 10 محلات
- النتيجة: trust collapse. **Justdial Trustpilot دلوقتي = 1.4/5**.

**حالة WASALNI:**
> الـ existing memory ما فيهاش الفخ ده مباشرة، **بس في احتمال نقع فيه:**
> - لو حدّدنا "اليوزر يطلب خدمة، WASALNI يبعت الطلب لكل السباكين فالقرية" → نفس الفخ.
> - **بدلاً من ذلك:** الـ user يشوف السباك مباشرة، يضغط واتساب، يكلمه شخصياً.

**القانون:**
- **عرض رقم الـ WhatsApp مباشرة** على كرت المحل/الحرفي.
- **مفيش "request a quote" form يبعت لـ N مزوّد**.
- **WASALNI = directory + discovery، مش broker**.

---

### Anti-Pattern 4: Reviews System من اليوم الأول

**اللي بيموته:** Yelp (extortion lawsuits 2011-2013)، Tabelog (Tokyo court ruling 2024 — $260K damages)، Citysearch (deleted negative reviews for advertisers)

**القصة:**
- الـ reviews بتعمل engagement لكن:
  - بتشجّع المحلات على defraud (fake reviews)
  - الـ platform بيقع فمواقف قانونية (لو تخفي review = manipulation)
  - **فالقرية الصغيرة:** كل واحد بيعرف الكل. Review سلبية على محل عم سيد = حرب أهلية.

**حالة WASALNI:**
> الـ memory بيقول "تقييمات + تعليقات مؤجّلة لـ Phase 2" — ده **قرار صح، اتمسك بيه.**

**القانون:**
- **مفيش reviews فالـ MVP**. أبداً.
- **مفيش star ratings** فالـ Phase 1.
- Phase 2 ممكن نعمل "verified purchase" تقييم بشكل مختلف (مش Yelp-style).
- Phase 2: نفكّر فـ "Endorsements" بدل reviews (شارة "موصى به من 3 جيران").

---

### Anti-Pattern 5: Algorithmic Feed قبل ما يكون فيه content كافي

**اللي بيموته:** Foursquare (consumer pivot)، Path، Yik Yak (نسخته الثانية)

**القصة:**
- المؤسس بيحلم بـ "For You algorithm" زي TikTok.
- بس فالـ MVP في 20 محل بس.
- الـ algorithm starved — مفيش variety كافية للـ ranking.
- الـ user بيشوف نفس الـ 5 محلات كل مرة.
- يهجر التطبيق.

**حالة WASALNI:**
> ⚠️ مفيش feedback مباشر فالـ memory عن الـ algorithm، **بس لو قررنا "personalization" من اليوم الأول، هنقع فالفخ.**

**القانون للـ MVP:**
- **مفيش ML/AI ranking**. أبداً.
- Sort = `proximity ASC, is_open DESC, recency DESC`.
- Featured row = manual curation أسبوعياً (الـ admin يختار 3 محلات يبرزهم).

---

## 🟠 المنطقة البرتقالية (تجنّب، لكن استثناءات ممكنة)

### Anti-Pattern 6: تصميم Mobile فقط بدون Web fallback

**اللي بيموته:** بعض الـ Indian local apps، apps for elderly

**القصة:**
- التطبيق فقط على Play Store.
- الـ user الريفي مش بيقدر يدخل Play Store، أو دخل و التطبيق مش لاقي عشان مفيش marketing.
- لو فيه web fallback (مجرد listing pages)، الـ Google search بيكتشف التطبيق.

**حالة WASALNI:**
> النية الحالية تركيز Mobile فقط. **مفيش web presence مخطط له فالـ MVP.**

**القانون:**
- **MVP يبقى فيه basic web profile pages للمحلات** (read-only).
- اللي ميقدرش يحمّل التطبيق، يقدر يفتح link و يشوف.
- ده **بياخد المسار من Justdial** — كان عندهم directory web منذ سنوات قبل الـ app.

---

### Anti-Pattern 7: Onboarding Flow طويل + مطلوب signup قبل البحث

**اللي بيموته:** المشروعات اللي عملت "Email + Phone + Profile + Photo + بيانات" قبل أي شيء.

**القصة:**
- اليوزر فاتح التطبيق علشان "يلاقي سباك دلوقتي".
- اللي شافه = شاشة signup + 5 خانات لازم تملأها.
- خرج فالثانية.
- **UNESCO research:** الـ low-literacy users بيهجروا أول شاشة فيها form.

**حالة WASALNI:**
> الـ Phase 5 (Guest Browsing) **صحيح**. يفضل.

**القانون:**
- Onboarding = 0 خانات قبل أول قيمة.
- Auth بس عند الحاجة (حفظ مفضلة، تسجيل محل، إلخ).

---

### Anti-Pattern 8: التوسع الجغرافي قبل validation

**اللي بيموته:** Grofers (انكمش من 26 لـ 9)، Jumia Food (شال من 7 دول)، Beebli، Yamsafer

**القصة:**
- المؤسس بيتحمّس، بيوسع لـ 3 محافظات فأول 6 شهور.
- الـ unit economics مكنتش proven فالأولى.
- التوسع = خسارة 3x أسرع.

**حالة WASALNI:**
> الـ memory بيقول "نقطة الانطلاق كفر المقدام". **القرار ده صح.** اتمسك بيه.

**القانون:**
- **كفر المقدام فقط حتى:**
  - عندك 50+ محل نشط (uploaded photos فالـ آخر 30 يوم)
  - 100+ DAU
  - 20%+ retention على 30 يوم
- **مش "كفر المقدام + القرى المجاورة"** فالـ launch — لما الـ كفر المقدام يبقى ناجح، نوسع لقرية واحدة مجاورة، نختبر.

---

### Anti-Pattern 9: Volunteer Moderation للمحتوى

**اللي بيموته:** Nextdoor ("toxic cesspool")، ShareChat (caught suppressing)، Facebook Buy Nothing groups

**القصة:**
- المؤسس بيقول "هنخلي users يبلّغوا عن المشاكل".
- النتيجة: volunteers بيـ abuse السلطة، الـ moderation بيبقى biased، الـ community بتتسمم.

**حالة WASALNI:**
> الـ memory ما فيهاش خطة moderation. **ده فراغ خطير.**

**القانون:**
- من اليوم الأول، **paid moderation هو cost line**.
- البداية: agent بشري واحد بيراجع كل محل قبل ما يظهر فالـ feed.
- Phase 2: hire 1-2 part-time moderators per قرى cluster.
- ❌ **لا تعتمد على AI moderation للعربي.** فيسبوك بنفسه بيفشل فيها.
- ❌ **لا تعتمد على volunteer moderators.**

---

### Anti-Pattern 10: ميزات Super-App قبل وقتها

**اللي بيموته:** Dunzo (مات لما حاول يكون super-app)، Path (حاول social + photos + music)، Beebli

**القصة:**
- المؤسس بيقول "نضيف delivery + payment + booking + reviews + posts + ads"
- كل feature بياخد engineering time
- الـ core value بيتشتت
- المستخدمين بيتلوهوا

**حالة WASALNI:**
> الـ memory الـ MVP فيه 9 features. **ده كتير**. الـ MVP الحقيقي = 2-3 features.

**القانون لـ WASALNI MVP الحقيقي:**
1. **Feed المحلات/الخدمات** (browse)
2. **بحث بسيط**
3. **زرار WhatsApp**
>
> ❌ Auth + Profiles + Sign up shop + Verification + Categories + Admin = **مش MVP. الـ admin manual فالـ phase الأول.**

---

## 🟡 المنطقة الصفراء (تنبه، استشير قبل القرار)

### Anti-Pattern 11: التركيز على الـ UI/UX قبل الـ Distribution

**اللي بيموته:** كل التطبيقات اللي اعتقدت "لو الـ UX حلو، الناس هتيجي".

**القصة:**
- المؤسس بيركّز على تفاصيل الـ palette و الـ animations و الـ component library.
- مفيش distribution plan.
- التطبيق ميجوب 50 user.

**حالة WASALNI:**
> ⚠️ إنت دلوقتي عملت `wasalni-design-spec.md` (350 سطر تصميم) + `design-brief.md` للمودل الخارجي. **التصميم مدروس.**
> **لكن:** ما فيش distribution plan موثّق. مين أول 10 محلات هتسجلهم؟ إزاي؟ مين أول 50 user؟ من فين؟

**القانون:**
- **قبل ما تكتب سطر UI تاني**، اكتب **distribution plan** بأسماء و أرقام.
- الـ UI الحالي كفاية لـ MVP. التركيز ينتقل للـ acquisition.

---

### Anti-Pattern 12: استخدام Email signup للريف

**اللي بيموته:** أي تطبيق اعتمد على email auth فجمهور بدوي/ريفي/فلاحي.

**القصة:**
- الريفيون أغلبيتهم **مفيهمش email** فالـ habit الأساسي.
- لو فيه email، بيكون مرة كل 6 شهور.
- Email verification = هجران.

**حالة WASALNI:**
> ⚠️ **خطأ استراتيجي حالي.** الـ existing Spec 1 = "Email + Email Confirmation" كـ default. + Custom SMTP عبر Resend اتعمل.

**القانون:**
- **Phone + OTP** = الـ default.
- Email = optional، fallback لو الـ user عايز.
- نقدر نحذف الـ Resend SMTP setup فالـ rebuild.

---

### Anti-Pattern 13: التركيز على Featurees الـ "نخبة" (تقييمات، إحصائيات، إلخ)

**اللي بيموته:** التطبيقات اللي حاولت تكون "complete" قبل ما تكون "useful".

**القصة:**
- "احنا محتاجين إحصائيات، baseline، charts، analytics..."
- اليوزر الريفي مايعرفش يقرا الـ charts و مهتمش.
- الـ engineering hours ضاعت.

**حالة WASALNI:**
> الـ memory بيقول "إحصائيات للمحلات مؤجلة لـ Phase 2+". **ممتاز. اتمسك بيه.**

---

### Anti-Pattern 14: محاولة "نحل كل المشاكل" فمنصة واحدة

**اللي بيموته:** Path، WeChat فأمريكا، Sharechat (الـ pivot لـ commerce)

**القصة:**
- "WASALNI = اكتشاف + بحث + توثيق + تواصل + ثقة + ..."
- التطبيق بيبقى متشتت.
- الـ users مش بيفهموه فثانية.

**حالة WASALNI:**
> الـ wasalni-overview بيقول: "هو: اكتشاف + بحث + وصول + تواصل مباشر + ثقة". **ده 5 حاجات.** الـ user الريفي ميقدرش يهضم 5.

**القانون:**
- الـ One-Line value prop لازم يبقى:
  - ✅ "وصلني = اعرف كل محلات قريتك"
  - ❌ "وصلني = منصة اكتشاف محلي + بحث + توثيق + ثقة"

---

### Anti-Pattern 15: الـ Founder بيدير الـ tech بدل ما يدير الـ business

**اللي بيموته:** عدد لا يحصى من الـ technical founders

**القصة:**
- الـ founder بيقعد 12 ساعة يوميا فالكود.
- مفيش وقت للـ customer discovery، الـ partnerships، الـ field work.
- التطبيق بيبقى "عظيم تقنياً" و ميت تجارياً.

**حالة WASALNI:**
> ⚠️ الـ session history واضح إن إنت بتقضي 95% من الوقت فالـ code/spec و 5% فالـ market/customers. **ده نسبة معكوسة لـ pre-PMF.**

**القانون:**
- **سنة 1 لـ pre-PMF: 80% time فالـ market، 20% فالـ build.**
- الـ Claude Code + الـ agents هيشتغلوا الـ coding لك. **استخدم وقتك للناس، مش للـ files.**

---

## 🔵 الـ Anti-Patterns الخاصة بـ WASALNI تحديداً

بناءً على تحليل الـ existing state:

### Anti-Pattern 16: الاحتفاظ بـ Spec Kit للمرحلة الحالية

**القصة:** Spec Kit أداة قوية لـ team large + complex enterprise. لـ solo founder + pre-PMF + village product = ceremony بدون قيمة.

**الدليل من البحوث:** Bootstrap research (#7) بيتحدث صراحة عن الـ "premature ceremony" كقاتل.

**القانون:**
- **اوقف Spec Kit لمدة 90 يوم.**
- ارجعله لما يبقى عندك مؤسس مشارك أو engineer أول.
- فالـ 90 يوم: ملف واحد `current_plan.md` كفاية.

---

### Anti-Pattern 17: التركيز على "نحل لـ كل أنواع المستخدمين"

**القصة:** الـ memory بيحدد 3 أنواع: مستخدم، مزوّد خدمة، صاحب محل. **3 types = 3 onboardings = 3 monetization = 3 UI variants = مستحيل تخدمهم كلهم بنفس الجودة فالـ MVP.**

**القانون لـ MVP (مقترح):**
- **MVP يخدم نوع واحد فقط من supply:** أصحاب المحلات.
- مزودي الخدمة = Phase 2 (مع UI مختلف، بحث مختلف، monetization مختلف).
- **أو العكس** — يبدأ بمزودي الخدمة فقط (لو الـ pain أوضح).
- **لكن مش الاتنين معاً فالـ MVP**.

> 🔥 **هذا قرار كبير محتاج نقاش مع المستخدم. راجع `decisions_needed.md`.**

---

### Anti-Pattern 18: اعتقاد إن الـ Field Team "جاهز" بدون اختبار

**القصة:** الـ memory بيقول "تيم الدعم و التيم الميداني جاهز". **لكن مفيش إثبات** إنه نزل أرض الواقع فعلاً. Field teams بتفشل فالعموم لو:
- مفيش manager متخصص لهم
- مفيش KPIs محددة (محلات/يوم، success rate)
- مفيش playbook (ايه يقولوا، ايه يطلبوا)
- مفيش حافز واضح (commission)

**القانون:**
- قبل ما تعتمد على الفريق الميداني، **اختبره بنفسك فأسبوع واحد.**
- نزل كفر المقدام بنفسك مع agent واحد، اعمل 5 onboardings.
- وثّق ايه شغّال، ايه فشل، كم وقت أخد، ايه الاعتراضات.
- **مفيش planning بنبني عليه قبل ما تختبر بنفسك.**

---

# 📋 جدول الـ 18 Anti-Pattern

| # | Anti-Pattern | حالة WASALNI الحالية |
|---|---|---|
| 1 | Backend معقد قبل validation | ⚠️ موجود — لازم rebuild |
| 2 | اشتراك 4-tier من اليوم الأول | ⚠️ مخطط — لازم يلغى |
| 3 | Lead-Gen middleman | ✅ مفيش (بس فيه احتمال نقع) |
| 4 | Reviews System فالـ MVP | ✅ مؤجّل (صح) |
| 5 | Algorithmic feed | ❌ مفيش قرار — لازم نتفق "مفيش algo فالـ MVP" |
| 6 | Mobile-only بدون web | ⚠️ مخطط Mobile only |
| 7 | Onboarding طويل قبل قيمة | ✅ مؤجّل (Guest mode) |
| 8 | توسع جغرافي قبل validation | ✅ كفر المقدام أولاً (صح) |
| 9 | Volunteer moderation | ⚠️ مفيش خطة moderation |
| 10 | Super-app features | ⚠️ MVP فيه 9 features (كتير) |
| 11 | UI قبل distribution plan | ⚠️ مفيش distribution plan |
| 12 | Email signup للريف | ⚠️ Email = الـ default الحالي |
| 13 | Features نخبوية | ✅ مؤجّل (صح) |
| 14 | "نحل كل المشاكل" | ⚠️ value prop 5 أمور |
| 15 | Founder بيدير tech بدل business | ⚠️ نسبة الوقت معكوسة |
| 16 | الاحتفاظ بـ Spec Kit | ⚠️ موجود — يُوقف مؤقتاً |
| 17 | 3 user types فالـ MVP | ⚠️ قرار كبير |
| 18 | اعتماد على Field team بدون اختبار | ⚠️ غير مختبر |

---

## 🎯 الخلاصة الأقسى

من 18 anti-pattern، **WASALNI الحالي بيقع فـ 11 منهم.**

ده مش حكم على المؤسس — ده دليل إن الـ rebuild الجذري **ضرورة، مش رفاهية**.

**الخبر الجيد:**
- الـ 7 المتبقية صح (Guest mode، Reviews مؤجّلة، الكفر المقدام أولاً، إلخ).
- الـ 11 اللي فيها مشكلة، أكتر من نصها قابل للإصلاح بـ "stop doing X" أكتر من "rebuild Y".

---

> الخطوة التالية: راجع [`decisions_needed.md`](./decisions_needed.md) — قرارات محددة محتاج تختار فيها مع شرح للخيارات.
