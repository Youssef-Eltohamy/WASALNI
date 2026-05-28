# بحث سوقي #01 — منافسو WASALNI في السوق المصري وMENA

> **الغرض:** فهم منصات الاكتشاف المحلي والدلائل التجارية والـ classifieds في مصر والشرق الأوسط، واستخراج دروس قابلة للتطبيق على WASALNI (منصة اكتشاف للقرى المصرية، مجانية للمستخدمين، مدفوعة للمحلات لاحقاً).
> **التاريخ:** 2026-05-26
> **المنهج:** WebSearch + WebFetch على مصادر primary (MENAbytes, Wamda, TechCrunch, DataReportal, Opensignal, CAPMAS) + reports خاصة بالشركات.

---

## 1. الإطار العام: لماذا هذا البحث مهم؟

WASALNI ليست food delivery، ولا e-commerce، ولا classifieds عام. هي **discovery layer** للقرى المصرية (بداية من كفر المقدام) — اكتشاف محل/منتج/خدمة/حِرفي، ثم تواصل مباشر بالواتساب/الموبايل. لذلك كل منافس أدرسه أسأل عنه سؤالين:
1. كيف تعامل مع مشكلة الـ **discovery** قبل أن يقفز إلى الـ transaction؟
2. ماذا فعل بشأن **الجمهور غير المتمرس تقنياً** (وكثير منهم ريفي)؟

---

## 2. تحليل المنافسين

### Otlob — أول منصة اكتشاف مطاعم عربية، انتهت إلى delivery
- **الحالة الحالية:** ماتت كعلامة تجارية في سبتمبر 2020، وأعيدت تسميتها إلى Talabat تحت Delivery Hero. (المصدر: MENAbytes)
- **الجمهور:** بدأت 1999 على يد Ayman Rashed كـ **دليل مطاعم urban** للقاهرة والجيزة فقط، طبقة متوسطة وعليا تستخدم الإنترنت في وقت كانت penetration فيه أقل من 5%.
- **نموذج العمل:** بدأ كـ **directory listing مجاني**، ثم ITWorx اشترتها، ثم LinkdotNet، ثم A15، وفي 2015 بيعت لـ Rocket Internet مقابل ~$12M (بسعر "bargain" حسب Wamda)، ثم Delivery Hero. التحول إلى **commission على الـ orders (15–35%)** هو ما أنقذها من الموت كـ directory.
- **مميزاتهم:** الأقدمية (1999!) خلقت brand recognition قوي بين أصحاب المطاعم. أول مَن أقنع المطاعم المصرية برقمنة قائمة الطعام.
- **عيوبهم/فشلهم:** ظل directory ثابتاً لـ16 سنة دون monetization حقيقي. حتى عام 2015 لم يحقق scale نتيجة عدم وجود delivery integration. تم بيعه بسعر زهيد لأن الـ pure directory model لم ينجح اقتصادياً.
- **الدرس لـ WASALNI:**
  - **الـ directory البحت لا يُموَّل بسهولة** — يجب التفكير من اليوم في طبقة monetization واضحة (اشتراك المحلات + sponsored placements) وإلا تصبح "asset bargain" بعد 15 سنة.
  - **الأقدمية أصل ثمين** — كوْنُك أول من يدخل قرية كفر المقدام يُنشئ moat من الـ relationships مع أصحاب المحلات لا يمكن للمنافس استنساخه بسهولة.
  - لا تقفز إلى الـ transactions قبل أن تُتقن الـ discovery (Otlob قفزت متأخراً واضطرت للبيع). WASALNI صحيح أنها لن تعمل transactions، لكن يجب أن تظل الـ discovery قوية جداً قبل التفكير في أي توسعة.

### Talabat — اللاعب المهيمن إقليمياً، نموذج marketplace متعدد الجوانب
- **الحالة الحالية:** حيّة وتسيطر. 55–60% حصة سوقية في GCC. 7.5M MAU في Q3 2025، إيرادات Q1 2025 = $846M (+34% YoY). تعمل في 8 دول منها مصر والأردن والعراق. (المصدر: IR.talabat.com, Statista)
- **الجمهور:** urban + suburban في المقام الأول. مصر تمثل سوقاً ضخماً لكن **متمركزاً في القاهرة والإسكندرية والمدن الكبرى**.
- **نموذج العمل:** عمولات 15–35% على الطلبات + Talabat Pro (اشتراك شهري للمستهلكين أُطلق في مصر 2025) + رسوم delivery + **إعلانات وplacements مدفوعة من المطاعم**.
- **مميزاتهم:**
  - **Talabat Mart** و dark stores تختصر الـ discovery → 15 min delivery.
  - **تكامل عمودي**: ينطلق من اكتشاف → طلب → دفع → توصيل في تجربة واحدة.
  - إعلانات داخلية تجعل الـ visibility منتجاً يدفع له صاحب المطعم (هذا ما يُعرف بـ ads-on-marketplace flywheel).
- **عيوبهم/فشلهم:**
  - **محصور في urban density** — لا يعمل في قرية فيها 12 مطعم بدون delivery riders.
  - عمولات 15–35% تخنق صاحب محل صغير في القرية (متوسط ربحية محل البقالة في الريف <20%).
- **الدرس لـ WASALNI:**
  - **النموذج المختلط (free directory + paid visibility) يعمل** — لكن طبَّقه Talabat بعد ما حقق scale. WASALNI يجب أن تبني أولاً قاعدة محلات قوية مجاناً قبل البدء في sponsored placements.
  - **لا تنافس Talabat في القاهرة** — اللعب في المساحات التي لا يخدمها (القرى، المحلات الصغيرة، الحرفيين، الباعة الجائلين) هو الـ blue ocean الحقيقي.
  - "Ads-on-marketplace" هو نموذج monetization أنجح من الاشتراكات الشهرية في الأسواق منخفضة الـ ARPU.

### Hatla2ee — سوق سيارات مصري ناجح يستحوذ عليه Dubizzle
- **الحالة الحالية:** حيّة، استحوذ عليها Dubizzle Group في فبراير 2025، 2M زائر شهري. تأسست 2016 على يد Samy Swellam. (المصدر: Wamda, Disrupt Africa)
- **الجمهور:** vertical-focused (سيارات فقط) — مزيج urban/suburban، male-skewed.
- **نموذج العمل:** classifieds مجانية + listings مدفوعة للـ dealers + إعلانات.
- **مميزاتهم:**
  - **التخصص العمودي** بدلاً من الـ horizontal classifieds جعلها أقوى من OLX في فئة السيارات.
  - بنوا **trust signals** قوية: مراجعات للموديلات، أخبار السيارات، أسعار indicative.
- **عيوبهم/فشلهم:** خرجت بـ exit متوسط (سعر غير مُعلن لكن يُقدَّر دون $20M) — ربما لأن الـ vertical الواحد ليس واسعاً بما يكفي للـ scale المستقل.
- **الدرس لـ WASALNI:**
  - **التخصص يربح** — Hatla2ee تغلبت على OLX في السيارات لأنها متخصصة. WASALNI تخصصها هو **القرية + الحِرفي + الباعة الصغار**، وهذا تخصص لا يمكن لـ Dubizzle أو Talabat لمسه بسهولة.
  - الـ vertical exits تتم بأسعار متواضعة → يجب التفكير في التوسع الجغرافي (قرى أخرى) أو الـ vertical expansion (خدمات تعليمية، طبية، زراعية) قبل أن تصبح too narrow.

### OLX / Dubizzle Egypt — أكبر classifieds مصري
- **الحالة الحالية:** OLX Egypt أصبحت Dubizzle Egypt (إعادة تسمية)، +200,000 إعلان نشط، ملايين المستخدمين. الشركة الأم Dubizzle Group هي **classifieds unicorn** الوحيد في MENA. (المصدر: dubizzle.com.eg, dubizzlegroup.com)
- **الجمهور:** عابر للطبقات والجغرافيا، لكن **urban-heavy**. 13 فئة رئيسية، +60 فرعية.
- **نموذج العمل:** listings أساسية مجانية + premium listings مدفوعة + اشتراكات للـ dealers والوكلاء (عقارات، سيارات) + إعلانات. (المصدر: BusinessModelHub, Vizologi)
- **مميزاتهم:**
  - **Network effects ضخمة**: المشتري يأتي للبائعين، والبائعون يأتون للمشترين.
  - **interface عربي بسيط** — يدعم العربية المصرية بشكل جيد.
  - **chat داخلي** يحمي رقم الهاتف من الـ spam.
- **عيوبهم/فشلهم:**
  - **مشكلة ثقة مزمنة**: spam، إعلانات وهمية، أسعار مبهمة. كل مَن يستخدم OLX المصرية يعرف هذه المشكلة.
  - **ليس hyperlocal** — لا يميز قرية كفر المقدام عن قرية مجاورة. البحث بـ "محافظة المنوفية" يعطي آلاف النتائج بدون فلترة فعلية على مستوى القرية.
  - **انعدام context للحِرفيين والمحلات الصغيرة الدائمة** — هو مصمم للـ ad-hoc transactions، ليس للعلاقات التجارية المستدامة.
- **الدرس لـ WASALNI (الأهم):**
  - **الـ trust هو الـ moat** — حيث يفشل OLX في الثقة، يمكن لـ WASALNI أن تنجح عبر: التحقق من المحل بزيارة ميدانية (ID + موقع جغرافي)، عرض اسم صاحب المحل، عرض سنوات الخبرة، شهادات الجيران.
  - **الـ hyperlocal precision** — البحث "نجار في كفر المقدام" يجب أن يرجع 3–5 نتائج موثوقة، لا 200 نتيجة عشوائية من 3 محافظات.
  - **classifieds للسلع، WASALNI للعلاقات** — OLX عن transaction، WASALNI عن المحل الذي تذهب إليه أسبوعياً. هذا فارق positioning حاسم.

### Souq.com → Amazon.eg — قصة الـ exit الكبير
- **الحالة الحالية:** Souq.com أُعيدت تسميتها Amazon.eg في سبتمبر 2021. الشركة الأم استحوذت عليها Amazon في مارس 2017 مقابل $580M (CNBC). (المصدر: DailyNewsEgypt)
- **الجمهور:** urban consumers، طبقة متوسطة وعليا، **بطاقات ائتمانية أو cash on delivery**.
- **نموذج العمل:** marketplace + first-party retail + logistics.
- **مميزاتهم:** Amazon قدمت Prime، Same-day، Customer Service تحفظ القيمة. logistics infrastructure ضخمة في 10 رمضان.
- **عيوبهم/فشلهم:**
  - في القرى الريفية لا تزال Amazon.eg ضعيفة الاختراق (delivery costs + cash on delivery friction + عدم وجود addresses دقيقة).
  - **الـ search bias نحو السلع الجاهزة** — لا يفيد مَن يبحث عن سباك في قريته.
- **الدرس لـ WASALNI:**
  - **حتى Amazon لم تحل مشكلة العنوان في الريف المصري**. WASALNI لا تحتاج عناوين دقيقة — تحتاج "اسم المحل + اسم القرية + landmark"، وهذا entry barrier منخفض جداً لصاحب المحل.
  - **e-commerce ≠ discovery**. الشخص في القرية لا يبحث عن سلعة يشحنها له Amazon — يبحث عن "مين بيصلح موبايلات هنا".

### Jumia Egypt — لاعب أفريقي يحاول الوصول للريف
- **الحالة الحالية:** حيّة، خفضت العمليات. 60% من orders Q3 2025 من **secondary cities** خارج العواصم الكبرى (نمو من 54% YoY). تستهدف الربحية 2027. (المصدر: Jumia IR, TechCabal)
- **الجمهور:** mass-market، **يميل للتوسع في المدن الصغيرة** عبر JForce agents و pickup stations.
- **نموذج العمل:** marketplace + 1P + JumiaPay + agent network.
- **مميزاتهم:**
  - **JForce**: شبكة وكلاء ميدانيين يأخذون الطلبات نيابة عن العملاء غير المتمرسين تقنياً. هذا نموذج فعّال للريف.
  - **Cash on delivery + pickup stations** يحلّان مشكلة عدم وجود بطاقات ائتمانية في الريف.
- **عيوبهم/فشلهم:**
  - **خسائر مستمرة** — Q1 2025 شهد انخفاضاً في الإيرادات بـ26% في مصر بسبب macro pressures.
  - **logistics في الريف مكلفة جداً** — تكلفة توصيل طلب لقرية قد تتجاوز هامش الربح.
- **الدرس لـ WASALNI:**
  - **نموذج JForce قابل للتكيف**: WASALNI تستخدم **field team door-to-door** لتسجيل المحلات (هذا موجود فعلياً في MEMORY) — هذا نفس فلسفة JForce لكن من الجانب الـ supply.
  - **Cash & pickup mentality** = WASALNI لا تحتاج payment integration. الـ phone/WhatsApp contact يكفي.
  - **خسائر Jumia تثبت أن الـ delivery economics في الريف صعبة جداً** → WASALNI خيار حكيم بتجنبها (no logistics, no delivery).

### Yellow Pages Egypt (YelloMedia) — الدليل القديم
- **الحالة الحالية:** حيّة لكن **متجمدة**. تأسست 1988، +250,000 شركة مسجلة. متاحة كموقع ويب وApp أندرويد. (المصدر: yellowpages.com.eg)
- **الجمهور:** B2B في معظمه + بعض المستخدمين الذين يبحثون عن شركات راسخة.
- **نموذج العمل:** **اشتراكات سنوية للمحلات/الشركات** للظهور في الدليل + premium placements + إعلانات.
- **مميزاتهم:**
  - **brand recognition** عند الجيل الأكبر سناً.
  - **بيانات كبيرة** (الكمية، ليست الجودة).
- **عيوبهم/فشلهم:**
  - **UX قديم جداً** — لا يصلح للموبايل، تصنيفات mode 1990s.
  - **لا يوجد user-generated content** — لا مراجعات، لا تقييمات، لا صور.
  - **محصور في المدن الكبرى** — تغطية القرى تكاد تكون معدومة.
  - **لا hyperlocal search**.
- **الدرس لـ WASALNI (الأهم):**
  - **النموذج الاشتراكي يعمل في مصر** — اشتراكات سنوية للمحلات. Yellow Pages أثبتت ذلك منذ 38 سنة. هذا يدعم خطة WASALNI الـ Free/Basic/Pro/Premium subscriptions للمحلات (Phase 2).
  - **لكن النموذج بدون UX حديث = موت بطيء**. WASALNI يجب ألا تكون "Yellow Pages بـ skin أحدث" — يجب أن تكون **mobile-first بحت** + **reviews لاحقاً** + **صور** + **خرائط**.
  - **الفجوة في القرى ضخمة** — Yellow Pages لم تدخل القرى في 38 سنة. WASALNI أول من يدخل.

### Carrefour Egypt / Talabat Mart — توصيل البقالة
- **الحالة الحالية:** Carrefour يعمل عبر app خاص + Talabat. توصيل 60 دقيقة في القاهرة.
- **الجمهور:** urban exclusively. لا يصل لكفر المقدام.
- **الدرس لـ WASALNI:** غير منافس مباشر. الـ supermarket apps لا تستهدف القرى وتعتمد على infrastructure غير موجودة في الريف.

### Daleeli (السعودية) — دليل أعمال خليجي قديم
- **الحالة الحالية:** حيّة منذ 2010، تابعة لـ Al Wahda Express. تركز على المملكة العربية السعودية. (المصدر: daleeli.com)
- **نموذج العمل:** directory مع GPS + خرائط + اشتراكات للشركات.
- **مميزاتهم:** integration مع GPS من البداية، يدعم البحث بالـ category والـ proximity.
- **عيوبهم/فشلهم:** **brand recognition ضعيف** خارج السعودية، UX قديم نسبياً، لا community features.
- **الدرس لـ WASALNI:**
  - **النموذج "directory + GPS + اشتراك"** نجح في الخليج لمدة 15 سنة → دليل صلاحية النموذج في MENA.
  - لكن **بدون community features (مراجعات، صور من العملاء، شات) يبقى الـ engagement ضعيفاً**.

### Elmenus — منصة اكتشاف مطاعم مصرية بدأت كـ pure discovery
- **الحالة الحالية:** حيّة، 1.5M MAU+، Series A بـ $1.5M في 2017 من Algebra Ventures، investors من Just Eat. تحولت من discovery إلى ordering في 2018. (المصدر: MENAbytes, Wamda)
- **الجمهور:** middle-class urban، Cairo+Alex+Giza.
- **نموذج العمل:** بدأت كـ menu directory مجاني → ads → online ordering → عمولات.
- **قصة التأسيس المهمة:** Amir Allam بدأ بـ **جمع قوائم الطعام من الشوارع شخصياً** ودخلها في الموقع. مثال كلاسيكي على **manual bootstrapping** في sourcing البيانات.
- **مميزاتهم:**
  - **قوائم طعام مفصلة + صور** — لم يكن متوفراً قبل Elmenus.
  - **مراجعات + تقييمات + بيانات اجتماعية**.
- **عيوبهم/فشلهم:**
  - **اضطرت للتحول إلى ordering** للبقاء — pure discovery لم يكن sustainable financially.
  - Talabat هيمنت على الـ ordering فأصبحت Elmenus #2.
- **الدرس لـ WASALNI (الأهم جداً):**
  - **النموذج الذي ابتدأت به Elmenus = هو نموذج WASALNI تماماً** (discovery + reviews، بدون transactions).
  - **التحدي الذي واجهته Elmenus**: pure discovery لا يولد revenue كافياً. التحول إلى ordering كان necessity.
  - **بالنسبة لـ WASALNI: monetization من المحلات (اشتراكات) أفضل من المستخدمين** — Elmenus حاولت أن تأخذ commission من المطاعم بنسب صغيرة، لكن الـ commission تتطلب transactions. WASALNI ستأخذ subscription، وهو مدفوع بصرف النظر عن transactions.
  - **بداية manual sourcing مثل Amir Allam = صحيحة**: field team door-to-door في WASALNI = نفس الفكرة.

### Filkhedma — منصة خدمات منزلية مصرية
- **الحالة الحالية:** حيّة لكن استُحوِذ عليها من SweepSouth (تابعة لـ Naspers). تأسست 2014. (المصدر: Wamda, DisruptAfrica)
- **الجمهور:** urban middle-class في القاهرة والجيزة والإسكندرية. سباكين، نجارين، كهربائيين، عمال نظافة.
- **نموذج العمل:** marketplace للخدمات المنزلية + booking + ضمان جودة + commission على الـ service providers.
- **مميزاتهم:**
  - **التحقق من العامل (background check)** — trust signal مهم جداً.
  - **ضمان الجودة + price quotation قبل الخدمة**.
- **عيوبهم/فشلهم:**
  - **محصور في 3 مدن** فقط — لم يصل للقرى.
  - **الـ commission تقلل من اشتراك العمال** — هامش العامل الواحد ضيق.
  - **عدم الـ scalability في المدن الصغيرة** بسبب صعوبة الـ supply.
- **الدرس لـ WASALNI:**
  - **WASALNI = Filkhedma بدون commission وبدون booking** = أبسط وأرخص للحرفي.
  - الحرفي في القرية لا يريد منصة تأخذ نسبة من شغله. يريد فقط "وصلني عميل، أنا أتفاوض معاه على الفلوس بنفسي".
  - **WASALNI تركز على الـ discovery + contact، تترك التفاوض/الدفع للطرفين** — هذا الـ positioning هو الميزة.

### MaxAB — منصة B2B تخدم محلات البقالة الصغيرة في القرى
- **الحالة الحالية:** حيّة وقوية. اندمجت مع Wasoko (Kenya) 2024. تخدم +450,000 تاجر عبر مصر والمغرب وكينيا. (المصدر: TechCrunch, African Business)
- **الجمهور:** **محلات البقالة الصغيرة في القرى والأحياء الشعبية** — exactly WASALNI's audience but from the supply side.
- **نموذج العمل:** B2B e-commerce: المحل يطلب بضاعته من MaxAB بدلاً من الموزع التقليدي.
- **مميزاتهم:**
  - **WhatsApp ordering option** — يدركون أن صاحب البقالة في الريف لا يستخدم app بسهولة، يكفي رسالة واتساب.
  - **شبكة logistics ضخمة تصل للقرى**.
  - **price transparency** — يحارب الـ informal markup.
- **الدرس لـ WASALNI (الأهم):**
  - **MaxAB أثبتت أن الـ rural shop owner mobile-literate enough to use a basic app or WhatsApp** — هذا يدعم فرضية WASALNI.
  - **WhatsApp as primary interface** = pattern مكرر. WASALNI يجب أن تجعل التواصل عبر WhatsApp **الـ default action** عند الـ shop card.
  - **MaxAB ⊕ WASALNI complementary**: MaxAB تحل supply لصاحب المحل. WASALNI تحل demand. **شراكة محتملة في المستقبل**.

### haader (حاضر) — منافس Talabat ناشئ
- **الحالة الحالية:** حيّة، #1 في iOS Food & Drink في مصر (Similarweb). تأسست حديثاً في القاهرة.
- **الجمهور:** urban Egyptian users يبحثون عن بديل لـ Talabat.
- **الدرس لـ WASALNI:** يظهر أن المستخدم المصري **ما زال منفتح على بديل محلي للاعب الكبير** — قابلية الاكتشاف وقبول العلامات المحلية الجديدة موجودة.

---

## 3. السياق السوقي والديموغرافي

### إحصائيات الاختراق الرقمي في الريف المصري (2025)

- **اختراق الإنترنت في الريف:** 63% مقابل 84% في الحضر = **فجوة 21 نقطة مئوية** = ~24.5 مليون مصري ريفي خارج الإنترنت. (DataReportal Digital 2025 Egypt)
- **توزيع السكان:** 56.6% ريفي / 43.4% حضري. = **WASALNI تستهدف الـ majority demographic**.
- **عدد الأسر الريفية:** 14.7 مليون أسرة (55.6% من إجمالي 26.5 مليون أسرة، CAPMAS 2025).
- **اختراق الإنترنت الإجمالي:** 81.9% (96.3 مليون مستخدم) — نمو من 72.2% في 2024.
- **مبادرة حياة كريمة:** 6 مليار جنيه مخصصة لتحسين الاتصالات. الفايبر الضوئي يصل لـ1.5 مليون منزل في 1500 قرية مستهدفة. هذا يعني **infrastructure tailwind قوية لـ WASALNI في الـ 3–5 سنوات القادمة**.

### جودة الإنترنت الموبايل في الريف

- 4G coverage **مقبولة في المدن، تتدهور في الريف** (Opensignal March 2025).
- WE = أسرع download/upload؛ e& = الأكثر reliability.
- 5G مقصورة على المدن الكبرى — لا اعتبار لها في خطة WASALNI الحالية.
- **تطبيق WASALNI يجب أن يعمل على 3G/4G ضعيف** = صور compressed، caching قوي، payload صغير، offline mode للقوائم الأساسية.

### WhatsApp في مصر

- **55 مليون مستخدم WhatsApp في مصر** (2023+). (TechRT, BusinessOfApps)
- 75% من سكان مصر والإمارات والسعودية يستخدمون WhatsApp بانتظام.
- 80% من مستخدمي WhatsApp Business عالمياً هم SMEs.
- **التضمين العميق لـ "تواصل عبر WhatsApp" في WASALNI = decision موفقة** — هو القناة الأكثر استخداماً وألفة لكلا الطرفين (صاحب المحل + المستخدم).

### Facebook في مصر

- Facebook Marketplace أُطلقت في مصر ضمن **أول دول MENA**.
- مجموعات Facebook المحلية ("بيع وشراء في [قرية/مدينة]") هي **القناة الرئيسية الحالية للـ informal commerce** في الريف المصري.
- المنافسة الحقيقية لـ WASALNI ليست تطبيقاً، بل **Facebook Groups + WhatsApp Groups**.

### سلوك البحث العربي المصري

- **العربية المصرية colloquial تطغى على الـ MSA** في البحث (أكثر من باقي الدول العربية).
- المستخدم المصري يكتب: "فيه نجار قريب مني"، "أنا عاوز محل عيش"، "إزاي ألاقي سباك".
- استخدام **Franco-Arabic ("ezzay", "fen", "3agez")** شائع في الـ younger demographics.
- **WASALNI search يجب أن:**
  1. يقبل العربية المصرية كاملة (ليس MSA فقط).
  2. يدعم synonyms (نجار/معلم خشب/نجار موبيليا).
  3. يفهم typos وأخطاء إملائية شائعة.
  4. (مستقبلاً) يدعم voice search لأن الـ literacy في الريف منخفضة نسبياً.

### عوامل الثقة في B2C المصري

من دراسة Ain Shams حول B2C trust في مصر:
1. **سمعة البائع (vendor reputation)** = العامل الأقوى.
2. **التأثير الاجتماعي (social influence)** = من يستخدمه الأقارب/الجيران.
3. **الردع (deterrence)** = وجود قنوات شكوى فعالة.
4. **الخبرة الشخصية والمعرفة**.
- الـ "privacy" و"website quality" أقل أهمية مما يُتوقع.

**ترجمة هذا لـ WASALNI:**
- اعرض اسم صاحب المحل، صورته (اختياري)، سنوات الخبرة.
- **Social proof**: "X من جيرانك زاروا هذا المحل" أو "Y جار رشحه".
- قناة شكوى فعالة مع field team.
- **Word-of-mouth = أقوى marketing channel في القرية**. الفريق الميداني المسجِّل للمحلات يجب أن يكون قوياً ومحلياً.

---

## 4. خلاصة السوق المصري/MENA — 7 أنماط شاملة

### النمط 1: **الـ Discovery البحت لا يُموَّل بسهولة، لكن discovery + light monetization يعمل**
Otlob و Elmenus بدأتا كـ pure discovery واضطرتا للقفز إلى transactions. Yellow Pages بقيت كـ pure directory لـ38 سنة لكن دون نمو. **WASALNI يجب أن تخطط لـ Phase 2 (اشتراكات المحلات + إعلانات مدفوعة) من اليوم الأول حتى لو لم تُطلَق الآن** — لتجنب مصير Otlob ولتفادي ركود Yellow Pages.

### النمط 2: **الـ Hyperlocal precision = أكبر فرصة غير مستغلة في مصر**
OLX/Dubizzle، Talabat، Amazon.eg، Jumia — **كلهم يفشلون في تمييز قرية عن قرية**. WASALNI تنطلق من قرية واحدة (كفر المقدام) وتبني hyperlocal precision لا يستطيع أي منهم استنساخها. هذا هو الـ **defensible moat**.

### النمط 3: **WhatsApp هو الـ default contact channel — يجب التضمين الأصلي**
MaxAB، Facebook، التجار الصغار، WASALNI — جميعهم يتقاطعون عند WhatsApp. WASALNI يجب أن تجعل WhatsApp message = الـ primary CTA، أكثر بروزاً من الـ phone call. (الـ deep link `wa.me/...` مع رسالة preset باسم المحل).

### النمط 4: **الـ Field Team Door-to-Door هو الـ acquisition engine الصحيح للريف**
Jumia (JForce)، MaxAB (mandoubs)، Elmenus (manual menu collection)، WASALNI (field registration team) — كل القصص الناجحة في المساحات low-tech-literacy تتقاطع عند **manual high-touch onboarding**. الـ pure digital marketing لا يعمل في الريف. أرسل بشراً.

### النمط 5: **الثقة تُبنى عبر التحقق الميداني + المراجع الاجتماعية**
دراسة الثقة في B2C المصري + قصة OLX/Dubizzle تثبت أن **سمعة البائع + التأثير الاجتماعي** يفوقان في أهميتهما "جودة الموقع". WASALNI يجب أن تستثمر في:
- **التحقق الميداني** (الفريق يزور المحل، يصور، يأخذ ID).
- **اسم صاحب المحل + سنوات الخبرة** = trust signals بسيطة وقوية.
- لاحقاً: **مراجعات الجيران** (مع الحذر من spam — تأكيد عبر OTP محلي).

### النمط 6: **التحلل من Transaction overhead = ميزة استراتيجية**
Filkhedma تأخذ commission من العامل، Talabat تأخذ 15–35% من المطعم، Jumia تأخذ عمولة + delivery fees. **WASALNI لا تأخذ شيئاً من الـ transaction** — فقط اشتراك ثابت من المحلات لاحقاً. هذا:
- يقلل الـ friction على صاحب المحل (لا يحتاج محاسبة، لا أرقام مالية يخفيها).
- يجعل onboarding أسهل بعشرة أضعاف.
- يلائم ثقافة الريف حيث **القبول الاجتماعي للوسطاء الرقميين الذين يأخذون نسبة من الربح ضعيف**.

### النمط 7: **الـ Brand recognition في الريف يُبنى بـ partnerships محلية، ليس بإعلانات**
Yellow Pages تعرفها أمي. Talabat تعرفها بنت أختي. لكن WASALNI لن يعرفها أحد في كفر المقدام إلا إذا:
- شاركت مع **شيخ الجامع، مدرسة القرية، الجمعية الزراعية**.
- وضعت ملصقات في المحلات نفسها.
- استخدمت **حياة كريمة** كقناة توزيع رسمية محتملة (التوافق الحكومي).
- لاحقاً: شراكة محلية مع **مبادرات تعليم رقمي ريفي** لتعليم القرويين كيفية الاستخدام.

---

## 5. توصيات استراتيجية مباشرة لـ WASALNI

1. **اربط WhatsApp كـ primary CTA**: زر "تواصل عبر WhatsApp" أكبر وأبرز من "اتصال هاتفي".
2. **اعرض اسم صاحب المحل + سنوات الخبرة + صورة المحل** كـ default trust signals من اليوم الأول.
3. **ابدأ بقرية واحدة (كفر المقدام) وأتقن hyperlocal precision قبل التوسع**.
4. **منع الـ commission model مرفوض كلياً** — اشتراك ثابت فقط في Phase 2.
5. **Field team هو الـ acquisition engine** — لا تعتمد على digital marketing في البداية.
6. **App يجب أن يعمل على 3G ضعيف** — صور compressed، caching، offline mode للقوائم الأساسية.
7. **اطلب من المستخدم اللهجة المصرية في البحث** — اقبل "عاوز نجار" بنفس قبول "أبحث عن نجار".
8. **لاحقاً (Phase 2): اشتراكات Free/Basic/Pro/Premium** = نموذج Yellow Pages معدَّل + sponsored placements style Talabat، لكن **بدون commission**.
9. **شراكة محتملة مع MaxAB** — هم يعرفون نفس صاحب المحل من الجانب الـ supply.
10. **تجنب delivery، tjnb e-commerce، تجنب payments** — هذه fields محروقة ومكلفة، والـ moat الحقيقي هو في الـ pure discovery + trust + hyperlocal.

---

## المصادر الرئيسية

- [MENAbytes — Otlob to Talabat rebrand](https://www.menabytes.com/talabat-otlob-rebrand/)
- [Wamda — Otlob bargain sale](https://www.wamda.com/2015/10/rocket-internet-buys-otlob-)
- [Wamda — Dubizzle acquires Hatla2ee](https://www.wamda.com/2025/02/dubizzle-acquires-egypts-online-car-marketplace-hatla2ee)
- [Talabat IR Q4 FY24 earnings](https://ir.talabat.com/wp-content/uploads/2025/02/20250213_talabat-Q4-FY24-earnings-call-presentation.pdf)
- [DataReportal Digital 2025 Egypt](https://datareportal.com/reports/digital-2025-egypt)
- [Opensignal Egypt March 2025](https://insights.opensignal.com/reports/2025/03/egypt/mobile-network-experience)
- [CAPMAS Egypt 2025](https://www.capmas.gov.eg/)
- [TechCrunch — MaxAB $40M raise](https://techcrunch.com/2022/10/19/maxab-an-egyptian-b2b-e-commerce-platform-for-food-and-grocery-supplies-nabs-40m/)
- [MENAbytes — Elmenus Series A](https://www.menabytes.com/elmenus-1-5-million/)
- [DailyNewsEgypt — Souq to Amazon.eg](https://www.dailynewsegypt.com/2021/09/02/after-over-10-years-souq-com-in-egypt-rebrands-into-amazon-eg/)
- [Jumia Q3 2025 results](https://investor.jumia.com/news/news-details/2025/Jumia-Reports-Third-Quarter-2025-Results/default.aspx)
- [Yellow Pages Egypt](https://yellowpages.com.eg/en/)
- [Dubizzle Egypt](https://www.dubizzle.com.eg/en/)
- [Filkhedma](https://www.filkhedma.com/)
- [Haya Karima Digital Initiative](https://www.itu.int/itu-d/sites/digital-impact-unlocked/from-pledges-to-action-egypts-decent-life-initiative/)
- [Ain Shams Journal — B2C Trust in Egypt](https://ajccr.journals.ekb.eg/article_348226.html)
- [Egyptian Streets — Social commerce growth](https://egyptianstreets.com/2024/12/25/social-media-ads-fuel-egypts-growing-online-shopping-habit/)
- [Arabic Chat Alphabet (Franco-Arabic)](https://en.wikipedia.org/wiki/Arabic_chat_alphabet)
- [NAOS Solutions — Egyptians and Digital 2025](https://naos-solutions.com/egyptians-and-digital-2025-report/)
