# بحث #04 — أنماط الـ Visual & Social Discovery لـ WASALNI

**التاريخ:** 2026-05-26
**السياق:** WASALNI — منصة اكتشاف محلية لقرى مصر، نبدأ بكفر المقدام. جمهور قرى ريفية، أعمار متنوعة، معرفة تقنية محدودة، هواتف Android متوسطة.
**السؤال الأساسي:** هل الـ "Pinterest-style grid" هو الاختيار الصح؟ ولو لأ، إيه البدائل؟

---

## القسم الأول: منصات الـ Visual Discovery

### Pinterest — الأب الروحي للـ Visual Discovery

- **النمط:** Masonry grid (شبكة بأعمدة ثابتة وارتفاعات متغيرة). الصور هي البطل، النص ثانوي. الـ Feed بيشتغل على نية "الاكتشاف" مش "البحث".
- **ليه بيشتغل:**
  - الـ Masonry بيقلل الـ "wasted space" ويعمل rhythm بصري طبيعي (الـ engagement أعلى بنسبة 47% من الـ uniform grid حسب أبحاثهم).
  - متوسط مدة الجلسة أطول 39% من المنصات البصرية التانية.
  - الدماغ بيعالج الصورة في 13ms — قبل ما يقرا أي كلمة. ده بيخلي الـ Pinterest يعمل "load instant" حسياً حتى لو الـ network بطيء.
  - 90%+ من البحث "unbranded" — الناس بتدور على فكرة مش على ماركة. ده مثالي لجمهور "مش عارف يدور إزاي".
  - الـ "Pin → Board" بيخلق curation بشري بدون algorithm معقد.
- **الجمهور المناسب:** نساء (60%+ من المستخدمين)، فئة "التخطيط" (الزواج، الديكور، الطبخ، الأطفال) — مش مستعجلين، بيدوروا على إلهام.
- **التطبيق المحتمل على WASALNI:**
  - فكرة "البحث بالـ intent المبهم" مناسبة جداً — أهل القرية مش هيكتبوا "محل بقالة شارع X" هيدوسوا على صورة لمنتج عجبهم.
  - الـ visual-first بيتجاوز محدودية القراءة.
  - **بس:** الـ Masonry محتاج صور عالية الجودة. لو صاحب المحل صور بموبايل رخيص في إضاءة وحشة، الـ Masonry هيبان "موزع". (تفاصيل في القسم الأخير).

---

### Instagram Explore + Shop — Discovery لكن للمحتوى الجاهز

- **النمط:** Algorithmic grid (3 أعمدة عادة) مع Reels و Carousels. الـ Explore بيشتغل على ثلاث مراحل: retrieval → early ranking → late ranking (multi-task neural net).
- **ليه بيشتغل:**
  - الـ Algorithm بيتعلم من "early engagement" (أول ساعة-ساعتين). محتوى Visually striking بيكسب.
  - الـ Performance-based مش Relationship-based — يعني محل صغير ممكن يوصل لجمهور كبير لو محتواه قوي.
  - 80%+ من مستخدمي الإنترنت في مصر بيوصلوا عبر السمارت فون، و60%+ من السكان تحت 30 سنة — Instagram موجود فعلاً عند الجمهور.
- **الجمهور المناسب:** الشباب الحضري، الـ creators، المحلات اللي عندها استعداد تنتج محتوى مستمر.
- **التطبيق المحتمل على WASALNI:**
  - **خطر:** الـ algorithmic feed محتاج آلاف المنشورات يومياً علشان يشتغل صح. في كفر المقدام عندنا 50-100 محل بحد أقصى. الـ algorithm هيتخنق.
  - **مفيد:** الـ Reels-style "محتوى قصير عن منتج" ممكن يلهمنا feature "فيديو 15 ثانية للمحل".
  - **مفيد:** فكرة الـ "thumbnail must stand out" — تعلمنا لازم نسوي تحسين تلقائي للصور (auto-enhance).

---

### TikTok For You / Shop — أكل الـ Local Discovery

- **النمط:** Full-screen single-column video. Interest graph (مش social graph). الـ algorithm بيتعلم من الـ "hesitation" (الوقفة قبل ما تـsswipe) أكتر من الـ like.
- **ليه بيشتغل:**
  - "260 video form a habit" — وكل فيديو 8 ثواني. يعني في 35 دقيقة المستخدم بقى متعود.
  - Variable reward schedule (نفس مبدأ القمار) — الـ dopamine بيتفجر مع كل swipe.
  - الـ swipe-up gesture أبسط حاجة ممكن تتعلمها — أمي 65 سنة تعرف تعمله.
  - بيدخل random content من categories ما اتفاعلتش معاها — discovery حقيقي.
- **الجمهور المناسب:** كل الأعمار، حتى أمي القرية. الـ swipe-up + الصوت + الفيديو = صفر حاجز قراءة.
- **التطبيق المحتمل على WASALNI:**
  - الـ **full-screen single-column** ممكن يكون أنسب من الـ 2-column grid لجمهور أقل تقنياً — حاجة واحدة على الشاشة، قرار واحد (شوف أكتر / كمل).
  - **بس:** محتاج محتوى فيديو كثيف. صاحب محل البقالة مش هيصور فيديو يومياً. ده دور **WASALNI** نوفر template/auto-capture.
  - فكرة "hesitation as signal" مفيدة لاحقاً للـ analytics — لو المستخدم وقف على بطاقة محل x ثواني، نسجلها.
  - **خطر أخلاقي:** WASALNI مش TikTok. الـ variable reward addictive لكن مش مناسب لـ "بحث عن محل بقالة قريب". الـ utility بياكل الـ entertainment.

---

### Xiaohongshu / RED (小红书) — الملك الحقيقي للـ Visual Local Commerce

- **النمط:** **Double Waterfall** (شلال مزدوج) — 2-column masonry بارتفاعات متغيرة. كل عمود بيـ scroll بشكل مستقل بصرياً. يعتبر الـ "gold standard" اللي Taobao و Xianyu و Jingdong قلدوها.
- **ليه بيشتغل:**
  - الـ "种草" (zhongcao = زراعة العشب) — مفهوم إن المستخدم بيحب منتج من خلال محتوى عضوي (UGC) مش إعلان.
  - 300 مليون مستخدم نشط، ربح صافي 500 مليون دولار 2023.
  - User-generated content + algorithmic personalization + e-commerce = حلقة كاملة.
  - الـ minimalist UI (Don Norman's three levels of emotional design): visceral (جميل) + behavioral (سهل) + reflective (بيخلي المستخدم يحس إنه ذكي).
- **الجمهور المناسب:** نساء صينيات 18-35 في المدن — لكن المبدأ ينطبق على أي community بـ peer trust عالي.
- **التطبيق المحتمل على WASALNI:**
  - **ده النموذج الأقرب لـ WASALNI** أكتر من Pinterest. ليه؟
    - الـ trust بيجي من الـ peers (أهل القرية يعرفوا بعض) مش من brand.
    - الـ "زراعة العشب" بالضبط هو اللي بيحصل في القرى — "فلان قاللي إن محل x عنده فول كويس" — احنا بنرقمن ده.
  - الـ **double waterfall** (2-column masonry) ممكن نفكر فيه كـ alternative للـ uniform 2-column. **بس** بشرط جودة صور.
  - الـ UGC pattern مهم — لازم نخلي العميل (مش بس صاحب المحل) يقدر يضيف صورة.

---

### Houzz — Visual Discovery للخدمات

- **النمط:** Grid من صور مساحات كاملة، مع "Visual Match" (deep learning بيـ tag المنتجات داخل الصورة فتبقى clickable).
- **ليه بيشتغل:**
  - الـ aspirational imagery (صورة لغرفة كاملة جميلة) أقوى من صورة منتج معزول.
  - الـ "click-to-buy" داخل الصورة بيـ collapse الـ discovery-to-purchase funnel.
- **الجمهور المناسب:** مالكي بيوت، فئة الديكور — high-intent بس مش high-frequency.
- **التطبيق المحتمل على WASALNI:**
  - فكرة "صورة سياقية" (الفول في الطبق، مش الفول في كيس) أقوى من الـ catalog shot.
  - الـ Visual Match مش لازم في MVP لكن مفيد للمستقبل.

---

## القسم الثاني: Social Commerce في MENA والأسواق الناشئة

### Meta Marketplace — الـ C2C العالمي

- **النمط:** Browse-by-category + location filter. بسيط، نصي أكتر من بصري. الـ Local Tab الجديدة بتجمع events + marketplace + groups + recommendations.
- **ليه بيشتغل:**
  - موجود جوه Facebook اللي كل حد عنده — صفر friction.
  - الـ trust بيجي من إن الـ seller ليه profile بـ history.
- **الجمهور المناسب:** كل الفئات — لكن المعاملات بتفضل peer-to-peer (المشتري بيـmessage البائع).
- **التطبيق المحتمل على WASALNI:**
  - **درس مهم:** الناس في القرى دلوقتي بيستعملوا Facebook Marketplace + جروبات الـ "بيع وشرا" — احنا منافسنا الحقيقي.
  - الـ messaging-driven discovery (الصورة → اضغط → اكتب) هو سلوك متأصل. لازم WASALNI تكون "زر الواتس" واضح جداً.

---

### Snapchat Spotlight + Map — الـ Local الحقيقي في MENA

- **النمط:** Spotlight = TikTok-style vertical video. Map = صور وأماكن على خريطة جغرافية. **Promoted Places** (2026) بيحول الـ Map لـ discovery engine.
- **ليه بيشتغل:**
  - 75 مليون مستخدم في MENA، 400 مليون عالمياً على الـ Map شهرياً.
  - مستخدمي الخليج بيفتحوا Snapchat **45+ مرة يومياً**.
  - الـ Map بـ heat-map شكل، بيخلي الـ "وين الناس دلوقتي" واضح بصرياً.
  - الـ AR Lenses (85% من مستخدمين MENA بيتفاعلوا معاها يومياً) بتدمج الـ digital بالـ physical.
- **الجمهور المناسب:** شباب MENA — لكن الـ Map concept ينطبق على كل عمر.
- **التطبيق المحتمل على WASALNI:**
  - **الـ Map-first view ممكن يكون أقوى من الـ feed-first** لقرية صغيرة. كفر المقدام جغرافياً صغيرة — خريطة بـ pins للمحلات أوضح من feed.
  - الـ "Promoted Pin على الـ Map" نموذج monetization مستقبلي ممتاز لـ WASALNI (المحل المدفوع يـappear أكبر).

---

### Instagram Business في مصر

- **النمط:** Profile + Highlights + Shop tab + DM-driven purchase. المحلات الصغيرة بتستعمل الـ Stories كـ catalog يومي.
- **ليه بيشتغل:**
  - الـ "Stories as catalog" بتخلي المنتج "طازة" — لو المنتج من امبارح، اتشاف.
  - الـ DM للشراء بيشغل الـ trust الشخصي ("بكلم صاحب المحل مباشرة").
  - 83% من المصريين مستعدين يدفعوا أكتر للمنتجات المحلية (PwC 2022).
- **الجمهور المناسب:** المحلات في المدن. **في القرى أقل** — Facebook أكتر من Instagram في الريف.
- **التطبيق المحتمل على WASALNI:**
  - الـ "Stories as catalog" نمط ذكي جداً — مش لازم صاحب المحل يبني catalog كامل، يكتفي بـ"عرض اليوم".
  - الـ DM-to-buy هو السلوك الطبيعي — احنا نتأكد إن الـ "Contact via WhatsApp" زر بارز جداً.

---

### WhatsApp Business Catalog — الـ Catalog جوه الـ Chat

- **النمط:** Catalog مرتبط بـ profile الـ business. كل منتج: صورة + اسم + سعر + وصف. المستخدم بيـ browse داخل WhatsApp بدون ما يخرج.
- **ليه بيشتغل:**
  - WhatsApp موجود فعلاً عند 100% من جمهور MENA الـ smartphone.
  - **صفر تعلم** — لو تعرف تبعت رسالة، تعرف تتصفح catalog.
  - الـ checkout بيحصل في chat مباشرة — ده الـ MO الطبيعي للقرى.
- **الجمهور المناسب:** **كل القرى المصرية** — ده الـ baseline تجربة الـ commerce الرقمي.
- **التطبيق المحتمل على WASALNI:**
  - **هذا منافسنا الأكبر، مش Pinterest.** أي محل عنده WhatsApp catalog مش محتاج WASALNI.
  - **التميز:** WASALNI لازم يقدم حاجة WhatsApp مبيقدمهاش = **discovery**. WhatsApp بيحتاج إنك تعرف رقم المحل مسبقاً. WASALNI بيحل ده.
  - **التكامل:** كل بطاقة محل في WASALNI لازم يكون فيها "Open in WhatsApp" زر — مش نحاول نـ replace الـ chat.

---

### Faire / Etsy — Discovery للـ Product

- **النمط:** Etsy عمل rebrand 2025 حوالين الـ **square motif** — كل شيء مربع (containers، thumbnails، categories).
- **ليه بيشتغل:**
  - الـ square = consistency + symbolic entry point (إطار للمحتوى).
  - بيواجه مشكلة "product grids feel interchangeable" — لما كل بطاقة شكلها واحد، المستخدم بيـzone out.
- **التطبيق المحتمل على WASALNI:**
  - الـ uniform square grid (اللي المستخدم اختاره) هو نفس اللي Etsy رجعت له — يعني الاتجاه صح.
  - **بس** Etsy حلت مشكلة الـ "interchangeable" بـ glyphs + colors + motion. WASALNI لازم يعمل نفس الشيء — مش بس صورة + اسم.

---

## القسم الثالث: أنماط الـ Algorithmic Discovery

### إيه اللي بيخلي الـ Discovery Feed شغال؟

- **النمط:** Freshness + Novelty + Engagement loop. الـ feed بيخلط:
  - محتوى متوقع (بناءً على history) — يخلي المستخدم مرتاح
  - محتوى مفاجئ (random injection) — يخلي الـ exploration مستمرة
  - Social proof signals (الناس اللي زيك شافت إيه)
- **ليه بيشتغل:**
  - الـ predictability + variability = حلقة dopamine (Skinner's variable reward).
  - الـ "engagement loop": كل تفاعل بيحسن التوصية اللي بعدها.
- **التطبيق على WASALNI:**
  - **مشكلة WASALNI الحقيقية:** عندنا ~50-100 محل. مفيش "engagement loop" حقيقية. المستخدم في 10 دقايق شاف كل المحلات.
  - الـ algorithm محتاج volume احنا مش هنوفره. لازم نلجأ لـ **curation بشرية + chronological لمحتوى جديد + map-based للاستعراض**.

---

### فخ الـ Infinite Scroll — إمتى بيفشل؟

- **النمط:** Endless content loading، بدون footer، بدون "وصلت لآخر النتائج".
- **ليه بيشتغل (للمنصات):** Retention، Variable reinforcement schedule.
- **إمتى بيفشل:**
  - لما المحتوى محدود — المستخدم بيكتشف الـ repeat بعد دقايق.
  - لما الهدف utility مش entertainment — البحث عن محل مش "نشاط مفتوح".
  - لما الجمهور بيـ zoom out كل شوية (الكبار في السن) — الـ infinite scroll بيـ disorient.
  - **مهم:** الـ scroll بدون "save position" بيخلق قلق ("هضيع مكاني").
- **التطبيق على WASALNI:**
  - **منعمل infinite scroll.** نعمل **pagination بسيطة** أو **"كل المحلات في القرية: 47"** عداد واضح من البداية.
  - المستخدم لازم يحس إن "ده كل اللي عندنا" مش "ده جزء من البحر".

---

### 2-Column vs Masonry vs Single-Column — لمين يناسب مين؟

| النمط | الجمهور المناسب | المشكلة في سياق WASALNI |
|---|---|---|
| **Single column (TikTok-style)** | أقل تقنياً، أكبر سناً، شاشات صغيرة | بطيء جداً للاستعراض. 10 محلات = 10 swipes. |
| **2-column uniform** | متوسط — clear، predictable، Etsy-style | ممكن يبان "interchangeable" |
| **Masonry (Pinterest)** | شباب، high-visual-literacy | يحتاج صور عالية الجودة، يبان "موزع" مع صور ضعيفة |
| **Map view** | كل الأعمار، خاصة في القرى الصغيرة جغرافياً | يحتاج geocoding دقيق |

- **التطبيق على WASALNI:**
  - **القرار المبدئي (2-column uniform) صح لـ MVP** للأسباب دي:
    - Predictability (مهم لجمهور أول مرة)
    - Forgiving للصور السيئة (الـ uniform بيخفي الفروق في الجودة)
    - Easier RTL implementation
    - مش بيحرج صاحب المحل بصورة "أكبر" من جاره
  - **لكن** نضيف **Map view كـ tab تاني** — للقرى الصغيرة الـ Map ممكن يكون الأقوى.

---

### Image-First vs Text-First في سياق محدود القراءة

- **النمط:** Microsoft Research India + UNESCO أبحاث: textual interfaces "unusable" لـ first-time low-literacy users. الـ graphical + voice + local language هي الـ solution.
- **ليه بيشتغل:**
  - الصورة بتـ communicate الوظيفة فوراً (placeholder للـ schema mental).
  - الـ voice annotation بتشتغل لجمهور أمي بشكل جزئي.
  - **المحفز قوي** — جمهور أمي بيتعلم 19 خطوة علشان يوصل لمحتوى ترفيهي.
- **التطبيق على WASALNI:**
  - الـ **icons + photos لازم تكون الـ primary** — النص ثانوي.
  - الـ category icons لازم تكون **representational** (طبق فول علشان "مطعم"، علبة دواء علشان "صيدلية") مش **abstract** (utensils icon لـ "مطعم").
  - فكرة **voice search** ممتازة (لكن مش في MVP).
  - الأسماء بالعامية المصرية مش الفصحى — "صيدلية" مش "صيدليّة".

---

### Card Design — إيه اللي بيخلي البطاقة "Tappable"؟

- **النمط (Material Design + research):**
  - Tap target ≥ 44px (≥ حجم الإصبع).
  - 8px+ padding حوالين الـ target.
  - Elevation shadow (عمق بصري) = "ده قابل للضغط".
  - Rounded corners (4-12px) = "ودود".
  - Contrast واضح (الـ card فوق الـ background).
- **التطبيق على WASALNI:**
  - الـ tap target الفعلي = البطاقة كلها (مش زر صغير جواها).
  - Shadow خفيف + rounded corners 12px = "حديث وودود".
  - **مهم:** أي زر CTA على البطاقة (مثلاً "WhatsApp") لازم يكون 48px+ — أصابع كبار السن أعرض.

---

## القسم الرابع: Design للـ Low-Literacy / First-Time Users

### Google Bolo + Internet Saathi — درس من الهند

- **النمط:** Voice-first + offline-first + character mascot (Diya في Bolo) + train-the-trainer (Saathi).
- **ليه بيشتغل:**
  - الـ offline بيشتغل في مناطق مفيش فيها انترنت مستمر — **بالضبط ظروف الريف المصري**.
  - الـ mascot بيخلق علاقة شخصية (مش app، صديق).
  - الـ train-the-trainer = كل امرأة بتعلم 5-10 جيرانها → نمو organic.
- **التطبيق على WASALNI:**
  - **Offline-first**: الـ feed لازم يـ cache آخر state. لو الانترنت قطع، المستخدم لسة شايف المحلات.
  - **Field team strategy** (الموجود فعلاً في خطة الإطلاق) = نسخة من Internet Saathi. كل عضو في الفريق يـ onboard صاحب محل + يعلمه يستعمل الـ admin.
  - **Mascot/Personality**: ممكن نفكر في "WASALNI helper character" بدل error messages معقدة.

---

### WhatsApp — ليه الجدات بتستعمله؟

- **النمط:** Uncluttered landing (أبيض، minimal)، مشابه لـ SMS، contact list بدل feed.
- **ليه بيشتغل:**
  - Familiarity (شبه phone book).
  - أقل عدد ممكن من القرارات في كل شاشة.
  - الـ default سلوك واضح (الـ green send button).
- **التطبيق على WASALNI:**
  - الـ home screen لازم يكون **شاشة واحدة بقرار واحد** ("شوف محلات القرية" زر كبير).
  - مفيش tabs كتيرة في البداية — Discover + Search + Profile كفاية.
  - الـ CTA primary لازم يكون لونه واحد متسق (زي الـ green في WhatsApp).

---

### JioMart + الـ Indian First-Time Internet Users

- **النمط:** Bottom-heavy nav (سهل الوصول بالإبهام). Categories بـ icons كبيرة. Search prominent بس مش obligatory.
- **التطبيق على WASALNI:**
  - Bottom nav (مش top) — أهم درس.
  - Categories grid في الـ home (4x2 أو 3x3 icons كبيرة) قبل ما تظهر المحلات نفسها.

---

## خلاصة — أنماط الـ Discovery اللي تنفع WASALNI

بعد المراجعة، دي التوصيات الملموسة، مرتبة بالأولوية:

### 1. الـ Grid: ابدأ بـ Uniform 2-column، أضف Map View tab

القرار المبدئي (uniform 2-column) **صح لـ MVP**. أسباب:
- Predictability لجمهور أول مرة
- بيخفي اختلاف جودة الصور بين المحلات
- بسيط في الـ RTL implementation
- مش بيحرج محل عن محل (الـ Masonry بيدي أهمية لصور أكبر = ظلم اجتماعي في قرية صغيرة)

**لكن** أضف **Map View كـ tab موازي** — لقرية ~5km² زي كفر المقدام، الخريطة ممكن تكون أوضح من الـ feed. مستفيدين من نموذج Snap Map.

### 2. Image-first + Iconography محلية

- كل بطاقة محل: صورة كبيرة (60-70% من ارتفاع البطاقة) + اسم بالعامية + 1-2 سطر فقط.
- Categories بـ **representational icons** (صورة فعلية لمنتج)، مش abstract.
- العامية المصرية مش الفصحى (`صيدلية` مش `صيدليّة`).
- صور الـ category placeholder للمحلات اللي مفيهاش صور (auto-generated by category).

### 3. Auto-enhance الصور (تجاوز جودة المحل)

محتم. صاحب محل البقالة موبايله Redmi 9 وإضاءته مصباح فلورسنت. لازم:
- Auto-crop + brightness + contrast على كل upload (TFLite model on-device).
- صورة فاشلة بشكل صريح → نقترح إعادة الالتقاط بـ tips بسيطة ("صور في النهار").
- Background subtle gradient placeholder لو الصورة مش متوفرة.

### 4. Chronological + Hand-Curated أحسن من Algorithmic

في قرية بـ 50-100 محل، الـ algorithm هيتخنق. الحل:
- **Default feed** = "محلات مفتوحة دلوقتي" + "محلات قريبة منك" (geo-sort).
- **Featured row** يدوي من فريق WASALNI (تتغير أسبوعياً).
- **Recent activity**: محلات نزلت محتوى/منتج جديد (يحفز التحديث).
- **بدون** "for you" algorithm في MVP — مفيش data.

### 5. WhatsApp Integration كـ Primary CTA

الـ destination الطبيعي للجمهور هو WhatsApp. كل بطاقة محل لازم يكون فيها:
- زر **"تواصل واتس"** بارز جداً (>= 48px، لون مميز).
- **مش** نحاول نـ replace الـ chat. نحن نخدم الـ discovery، WhatsApp تخدم الـ transaction.
- يفضل deep link مع رسالة جاهزة ("اتفرجت على محلك في WASALNI، عايز أسأل عن...").

### 6. Offline-First Cache

الانترنت في الريف غير مستقر. لازم:
- آخر feed محفوظ → يظهر لما الـ network قطع.
- صور cached بحجم محسوب (WebP + lazy load).
- "وضع توفير البيانات" زر واضح في الـ settings.

### 7. حل مشكلة "الـ Empty Feed" بصراحة

لو القرية فيها 12 محل بس، لا تخفي الحقيقة. **Embrace it:**
- اعرض العداد بوضوح: **"كل المحلات في كفر المقدام (12)"**.
- اعرض **"محلات قريبة"** من قرى مجاورة كـ section ثانوي.
- اعرض **"ساعدنا نضيف محلك"** كـ empty-state CTA.
- **لا تستعمل** infinite scroll اللي يخفي الـ scarcity.

### 8. Bottom Navigation، 3 Tabs بالكثير في MVP

من JioMart + WhatsApp pattern:
- Tab 1: **Discover** (الـ feed)
- Tab 2: **خريطة** (Map view)
- Tab 3: **حسابي**
- (Search كـ action في الـ top bar، مش tab).

### 9. Card Design Tokens

- Border radius: 12-16px
- Shadow: subtle (elevation 2 in Material)
- Image aspect ratio: 4:3 (أحسن لصور الموبايل من 1:1 أو 16:9)
- Min tap target للزر الـ CTA: 48dp
- Padding داخل البطاقة: 12dp
- Spacing بين البطاقات: 8-12dp

### 10. RTL Done Right (مش بس mirror)

- Test على أكتر من device size.
- Font Arabic أكبر 2-3pt من الـ English.
- الـ numbers تبقى LTR حتى داخل text عربي.
- Icons الـ directional (سهم رجوع) تنعكس، Icons الـ neutral (home, search) لا تنعكس.

---

## تحذير — حاجات تبدو مغرية بس مش هتشتغل لجمهورنا

### 1. Pinterest-style Masonry Grid في MVP

**ليه مغري:** بصرياً ساحر، بيحس "premium"، الـ engagement أعلى في الأبحاث.

**ليه مش هيشتغل:**
- الصور هتكون متفاوتة الجودة بشكل صادم (محل x صور بـ DSLR، محل y صور موبايل بإضاءة وحشة). الـ Masonry بيـ amplify الـ inconsistency.
- بيحرج صاحب المحل بصورة "أصغر" من جاره — في القرية ده ممكن يخلق توتر اجتماعي حقيقي.
- المستخدم الجديد بيحس بالـ "موزع" — مش بيعرف يـ scan grid غير منتظم.
- في قرية بـ 50 محل، الـ visual rhythm اللي بيخلي الـ Masonry جميل مش هيتكون.

**البديل:** Uniform 2-column. لو في الـ V2 لقينا الصور بقت متسقة، نعيد التقييم.

### 2. Infinite Scroll بدون Pagination

**ليه مغري:** كل التطبيقات الكبيرة بتعمله، الـ engagement metrics بتتحسن.

**ليه مش هيشتغل:**
- مفيش محتوى كافي يـ fill الـ infinite — هتتكرر المحلات.
- جمهور غير معتاد على scroll طويل بيـ disorient بسرعة.
- بيخفي الـ scarcity (12 محل) واللي ده هيخلق توقعات خاطئة.
- "ضيعت مكاني" anxiety عالية في جمهور أكبر سناً.

**البديل:** Pagination واضحة + counter من البداية.

### 3. Algorithmic "For You" Feed

**ليه مغري:** Industry standard، شخصية، "ذكي".

**ليه مش هيشتغل:**
- محتاج بيانات سلوك. عندنا 0 مستخدم في الـ launch.
- محتاج catalog كبير (آلاف). عندنا 50-100.
- الـ training set هيكون biased جداً (أول 100 مستخدم = الـ default للناس بعدهم).
- في قرية، كل المحلات "قريبة". الـ personalization variable الوحيد المعقول.

**البديل:** Chronological + geo-sort + hand-curated rows (Featured, New, Open Now).

### 4. Voice/Video-First Discovery (TikTok style) في MVP

**ليه مغري:** يتجاوز محدودية القراءة، الـ engagement عالي.

**ليه مش هيشتغل:**
- المحلات الصغيرة مش هتنتج فيديو يومياً.
- استهلاك البيانات في الـ video عالي (الجمهور هيـ uninstall لما الـ data bundle يخلص).
- محتوى video محتاج editing/captions/templates — تعقيد إضافي لصاحب المحل.

**البديل:** صورة + 1-2 سطر. لاحقاً (V2) نضيف 15s video كـ optional.

### 5. Heavy Onboarding + Account Creation Required

**ليه مغري:** بيخليك تجمع بيانات قيمة، Push notifications, إلخ.

**ليه مش هيشتغل:**
- جمهور بيكره الـ forms (UNESCO research: low-literacy users بيـ abandon عند أول form).
- "إيميل" مش حاجة كل واحد في القرية عنده — التحقق بـ phone OTP أحسن (والـ pivot للـ guest-first في الـ spec الأصلي صح).
- "كلمة سر" cognitive load عالية — نفضل OTP each time.

**البديل:** Guest browsing default. Account لما المستخدم يحتاج (saved favorites, posting).

### 6. Dark Mode بـ Toggle مبكر

**ليه مغري:** Modern feel، يوفر بطارية.

**ليه مش هيشتغل:**
- صور المنتجات بتظهر بشكل أوحش في الـ dark mode (خاصة لو الـ background الأصلي للصورة مظلم).
- Cognitive overhead إضافي ("ليه الشاشة سودا؟ هل عطلت حاجة؟").
- Cultural: في الريف، الـ apps "البيضا" تحس بالنظافة.

**البديل:** Light mode فقط في MVP. Auto-dark بعدين بناءً على system.

### 7. Complex Filtering (price range slider, multi-select tags)

**ليه مغري:** Power-user feature، Etsy/Amazon-like.

**ليه مش هيشتغل:**
- Slider controls معقدة لجمهور غير معتاد على gestures دقيقة.
- Multi-select checkboxes كل واحدة 30px تـ overwhelm.
- الـ mental model مش موجود ("نطاق السعر" مفهوم سوق منظم، مش قرية).

**البديل:** Filter كـ pills بسيطة: [مفتوح دلوقتي] [قريب مني] [مأكولات] [ملابس]. كل واحدة tap toggle.

### 8. Gamification (Badges, Streaks, Points)

**ليه مغري:** بيرفع الـ retention في معظم الـ apps.

**ليه مش هيشتغل:**
- جمهور utility-driven مش entertainment-driven. هو بيدور على محل، مش بيلعب.
- ممكن يحس "طفولي" — رجل 50 سنة بيدور على ميكانيكي مش هياخد badge "زائر مغامر".
- Cultural friction: الـ achievement-based systems غربية الطابع.

**البديل:** Utility metrics واضحة ("صاحب المحل بيرد عادة في 10 دقايق").

---

## مراجع (Sources)

- [Pinterest: How Visual Discovery and Design Built a $20B Social Commerce Giant — Passionate Agency](https://passionates.com/pinterest-visual-discovery-social-commerce-giant/)
- [PINTEREST, INC. FY2025 SEC filings](https://www.sec.gov/Archives/edgar/data/0001506293/000150629325000228/q3-25xpressrelease.htm)
- [Pinterest vs Google: 6 Key Differences — Mary Lumley](https://marylumley.com/pinterest-vs-google-6-key-differences-for-business/)
- [Pinterest Expands to MENA — Swipe Insight](https://web.swipeinsight.app/posts/pinterest-expands-to-mena-8246)
- [Instagram Explore AI system — Meta Transparency Center](https://transparency.meta.com/features/explaining-ranking/ig-explore/)
- [The Instagram algorithm: How it works — Sprout Social](https://sproutsocial.com/insights/instagram-algorithm/)
- [Digital Marketing for Small Businesses in Egypt — UBD Egypt](https://ubdegypt.com/digital-marketing-for-small-businesses-in-egypt/)
- [Locally: From a Basement to a Hub for Local Shopping in Egypt — Egyptian Streets](https://egyptianstreets.com/2025/05/05/locally-from-a-basement-to-a-hub-for-local-shopping-in-egypt/)
- [The Dopamine Cycle: How TikTok's Recommendation Algorithm Shapes Minds — Politics Today](https://politicstoday.org/the-dopamine-cycle-how-tiktoks-recommendation-algorithm-shapes-minds/)
- [How the TikTok Algorithm Works in 2026 — Sprout Social](https://sproutsocial.com/insights/tiktok-algorithm/)
- [The Rise of China's Xiaohongshu — Medium](https://hellomgyworld.medium.com/the-rise-of-chinas-xiaohongshu-little-red-book-4ad2693aec67)
- [Chinese apps devour Xiaohongshu's double waterfall methodology — PingWest](https://en.pingwest.com/a/11673)
- [The Rise of Xiaohongshu — Chinafy](https://www.chinafy.com/blog/the-rise-of-xiaohongshu-chinas-hottest-social-commerce-platform)
- [Houzz Leverage Deep Learning — Harvard Digital Initiative](https://d3.harvard.edu/platform-rctom/submission/houzz-leverage-deep-learning-to-level-up-its-game-in-online-marketplace/)
- [Snap launches Promoted Places — Campaign Middle East](https://campaignme.com/snap-launches-promoted-places-transforming-the-snap-map-into-real-world-discovery/)
- [Snapchat's Spotlight arrives in MENA — Campaign Middle East](https://campaignme.com/snapchats-new-entertainment-platform-spotlight-arrives-in-the-middle-east-north-africa/)
- [WhatsApp Shop: Complete Guide for Retailers — Omnichat](https://blog.omnichat.ai/whatsapp-shop-catalog/)
- [Etsy's Brand Refresh Explained — ALM Corp](https://almcorp.com/blog/etsy-brand-refresh-explained/)
- [Etsy Rebrand Puts Discovery First — Design Rush](https://news.designrush.com/etsy-brand-refresh-sylvain-visual-identity-ecommerce-discovery)
- [Image centric UI for the low literate next billion users in India — Bootcamp](https://medium.com/design-bootcamp/image-centric-ui-for-the-low-literate-249b7c1be0bc)
- [UIs for Low-Literate Users — Microsoft Research](https://www.microsoft.com/en-us/research/project/uis-low-literate-users/)
- [Designing User Interfaces for Illiterate and Semi-Literate Users — SAGE Open](https://journals.sagepub.com/doi/full/10.1177/21582440231172741)
- [Five Traits of Low-literacy Technology Users — ICTworks](https://www.ictworks.org/traits-low-literacy-technology-users/)
- [Why did the 50+ generation fall in love with WhatsApp? — Medium](https://vikramgoyal2012.medium.com/why-did-the-50-generation-fall-in-love-with-whatsapp-4596977ecfbc)
- [Heuristic Evaluation of JioMart — Medium](https://medium.com/@vidhyagangula123/heuristic-evaluation-of-jiomart-website-9fec2d8e9ad9)
- [Beat the cold start problem in a marketplace — Reforge](https://www.reforge.com/guides/beat-the-cold-start-problem-in-a-marketplace)
- [Two-Sided Marketplace Cold Start 2026 Playbook — FORKOFF](https://forkoff.xyz/blog/founder-growth/two-sided-marketplace-cold-start-2026)
- [Autoplay and infinite scroll dark patterns — Medium](https://rene-otto.medium.com/autoplay-and-infinite-scroll-8607abe52bb7)
- [The Dark Side of UX Design: Dark Patterns — Karim Manaa](https://karimmanaa.medium.com/the-dark-side-of-ux-design-dark-patterns-infinite-scroll-fd4a8459d6da)
- [Cards — Material Design 3](https://m3.material.io/components/cards/specs)
- [Improving Tap Targets for Better Mobile UX — OpenReplay](https://blog.openreplay.com/improving-tap-targets-mobile-ux/)
- [Internet Saathi Program — Testbook](https://testbook.com/articles/internet-saathi-program)
- [Introducing Bolo — Google India Blog](https://india.googleblog.com/2019/03/introducing-bolo-new-speech-based.html)
- [Fundamentals of Right to Left UI Design — Blackboard Design](https://medium.com/blackboard-design/fundamentals-of-right-to-left-ui-design-for-middle-eastern-languages-afa7663f66ed)
- [Designing Arabic Interfaces: RTL UX Done Right — Code Guru](https://codeguru.ae/blog/designing-arabic-interfaces-right-to-left-ux-done-right/)
- [Why Chronological Feeds Matter — SureSpace](https://sure-space.com/why-chronological-feeds-matter/)
- [AI product photography tools for ecommerce — Claid](https://claid.ai/blog/article/ai-product-photo-tools)
- [What Meta's New Updates Mean for Local Discovery — Yext](https://www.yext.com/blog/2024/10/what-metas-new-updates-mean-for-marketers)
