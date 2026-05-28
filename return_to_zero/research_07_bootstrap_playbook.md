# Research 07: Bootstrap Playbook — From Zero to 100 Users / 50 Shops in One Egyptian Village

> **السياق:** WASALNI الآن عند الصفر. فيه backend مبني بالكامل، بدون مستخدم واحد ولا محل واحد. الهدف من البحث ده: استخراج playbook عملي وقابل للنسخ من اللي نجحوا في cold-start في أسواق ناشئة وقرى، عشان نطبقه على كفر المقدام.
>
> **المبدأ الحاكم (من Paul Graham):** *"The things that get you from 0 to 100 users are fundamentally different from the things that get you from 100 to 10,000."* — اللي ينفع في الـ100 الأولى هو شغل يدوي مش قابل للتوسع، والصح إننا نعمله بإيدنا.

---

## 1. الإطار النظري — Andrew Chen & Lenny Rachitsky

### الـ Atomic Network (الشبكة الذرية)
- **القصة:** Andrew Chen (a16z, ex-Uber) في كتاب *The Cold Start Problem* بيقول إن أي network product لازم يبدأ بـ**أصغر شبكة ممكنة تقدر تعيش وتولّد قيمة لوحدها**. مش "Egypt". مش "Cairo". حتة صغيرة جدًا، dense وcomplete.
- **التكتيك المحدد:** عرّف الـatomic network بأضيق حدود ممكنة: كام محل + كام مستخدم في كام شارع لازم يكونوا موجودين عشان المنتج يبقى مفيد فعلًا؟ Tinder بدأت في جامعة واحدة (USC). Uber بدأت في حي واحد بسان فرانسيسكو. Facebook بدأت في Harvard بس.
- **التطبيق على WASALNI كفر المقدام:** الـatomic network = **شارع رئيسي واحد في كفر المقدام + 30-50 محل عليه + 100-200 ساكن في دائرة 1 كم حوليه**. مش "كل القرية". لو نجح الشارع ده، اتنقل لشارع تاني. الكثافة أهم من التغطية.
  - مقياس "الكثافة الكافية": لو ساكن فتح التطبيق ولقى ≥80% من المحلات اللي بيتعامل معاها أصلًا → atomic network "اشتغلت".

### الـ Hard Side vs Easy Side
- **القصة:** كل marketplace ليها طرف صعب وطرف سهل. Chen بيقول: ركّز على الـhard side أولًا. على Airbnb الـhard side = المضيفين (Hosts)، مش الضيوف. على Uber الـhard side = السواقين. على Tinder الـhard side = البنات (لأن الولاد بيدخلوا لو فيه بنات).
- **التكتيك المحدد:** اسأل: "مين اللي لو ميجيش، التطبيق ميبقاش له معنى؟" واصرف 80% من مجهودك على الطرف ده.
- **التطبيق على WASALNI كفر المقدام:** الـhard side = **المحلات** بدون شك. ساكن القرية لو فتح تطبيق فاضي بدون محلات، هيقفله ومش هيرجع. لكن صاحب المحل لو سُجِّل ومفيش زباين، ممكن يستنى أسبوع أو اتنين قبل ميقفله. **يبقى أول 60 يوم: 90% من الوقت على المحلات، 10% على الساكنين.**

### الـ Tipping Point (نقطة التحول)
- **القصة:** Lenny Rachitsky (ex-Airbnb) في playbook الـmarketplace بتاعه: في الـhyperlocal، الـtipping point في مدينة معيّنة بيحصل لما توصل لـ**50-100 supplier مركّز في رقعة جغرافية واحدة**. تحت كده الـconsideration set للمستخدم ضعيف، وبعد كده النمو بيبقى ذاتي.
- **التكتيك المحدد:** ميقاسش بعدد التحميلات. اقيس بـ**عدد المحلات النشطة في رقعة جغرافية واحدة** + **نسبة المستخدمين اللي رجعوا فتحوا التطبيق تاني الأسبوع اللي بعده (W1 retention)**.
- **التطبيق على WASALNI كفر المقدام:** هدف الـtipping point = **50 محل نشط (≥1 تحديث في الأسبوع) داخل دائرة 1.5 كم في كفر المقدام، مع 30% من سكان الدائرة عاملين فتح للتطبيق مرتين في الأسبوع على الأقل**. تحت كده الأرقام دي → لسه pre-tipping → لازم نفضل manual.

**المصادر:**
- [The Cold Start Problem by Andrew Chen](https://www.coldstart.com/)
- [Andrew Chen — Solve a Hard Problem (Tinder)](https://andrewchen.com/solve-a-hard-problem-cold-start-problem/)
- [Lenny Rachitsky — How to kickstart and scale a marketplace](https://www.lennysnewsletter.com/p/how-to-kickstart-and-scale-a-marketplace)
- [Lenny Rachitsky — Cracking the Chicken-and-Egg Problem](https://www.lennysnewsletter.com/p/how-to-kickstart-and-scale-a-marketplace-9ee)

---

## 2. قصص Bootstrap ناجحة — تحليل عميق

### Airbnb — الـ"10 in NYC"
- **القصة:** Brian Chesky وJoe Gebbia كانوا قابلين الإفلاس. Paul Graham قال لهم: مستخدميكم كلهم في New York، روحوا هناك. سافروا فعلًا، قعدوا أسابيع، قابلوا كل host واحد واحد. اكتشفوا إن المشكلة الكبيرة = **الصور وحشة**. أجّروا كاميرا بـ$500 وراحوا يصوروا الشقق بإيدهم. الحجوزات اتضاعفت في الأسبوع.
- **التكتيك المحدد:** *"Don't scale, fly."* — قابل أول 10-20 supplier وجهًا لوجه. شيل عنه أكبر barrier (الصور). لو محتاج تصرف فلوس أو وقت، اصرفهم على الـsupplier الواحد ده.
- **التطبيق على WASALNI كفر المقدام:** لكل محل من أول 20 محل: **روح المحل بإيدك، صوّر له صور احترافية بالموبايل لمنتجاته الأكثر مبيعًا، اكتب الوصف معاه، اعرضه على التطبيق وريهوله جاهز.** الـbarrier الأكبر لصاحب المحل = "أنا مش فاهم في الموبايل + الصور وحشة". شيل البارير ده.
- **بونص — قصة الـCereal Boxes:** الموسسين باعوا علب كورن فليكس مرسومة بـObama وMcCain بـ$40 العلبة عشان ييجبوا فلوس يعيشوا بيها. الدرس: **الفلوس بتيجي من حاجة مش متوقعة. الموسس اللي بيعمل أي حاجة عشان يعيش، هيلاقي حل.**

**المصادر:**
- [Airbnb doing things that don't scale](https://www.alexanderjarvis.com/airbnb-doing-things-that-dont-scale/)
- [Airbnb cereal box story — Fortune](https://fortune.com/2023/04/19/airbnb-ceo-cereal-box-investors-changed-everything-billion-dollar-company/)
- [How Two Designers Created Airbnb — Product Habits](https://producthabits.com/how-two-designers-created-airbnb-and-turned-it-into-a-30-billion-company/)

### DoorDash — PaloAltoDelivery.com
- **القصة:** أربع طلبة من Stanford عملوا موقع بسيط اسمه `PaloAltoDelivery.com`. مفيش backend، مفيش checkout. ضربوا PDFs لمنيوهات 8 مطاعم محلية من النت، وحطوا تليفون موسس عليه كـ"اتصل تطلب". أول طلبية جت من واحد قاعد بيدور على Google "palo alto delivery" — اتصل، طلب تايلندي، **الأربعة موسسين رحوا في عربية واحدة ووصّلوه بنفسهم**. مفيش سواقين، مفيش dispatch، حرفيًا الموسسين كانوا يوصّلوا بين المحاضرات.
- **التكتيك المحدد:** **Manual phone-based ordering + founder-as-driver.** ميحتاجش backend. ميحتاجش app. PDFs من النت + رقم تليفون = MVP.
- **التطبيق على WASALNI كفر المقدام:** قبل أي تطبيق، اعمل **WhatsApp Business واحد اسمه "وصلني — كفر المقدام"**. اجمع منيوهات/قوائم منتجات من 10 محلات في صور أو PDFs. أي حد يطلب → تكلم مع المحل بإيدك → نسّق التوصيل. الـbackend = ورقة + قلم. التطبيق يجي بعد ما تثبت إن في طلب فعلًا.

**المصادر:**
- [How DoorDash started with a Concierge MVP](https://builtbyorchid.com/doordash-concierge-mvp/)
- [How DoorDash got its first users](https://kickstartsidehustle.com/how-doordash-got-its-first-users/)

### Justdial (الهند) — الـOperator-Mediated Model
- **القصة:** V.S.S. Mani بدأ في جراج صغير في مومباي بـ50,000 روبية (~$600) سنة 1996. اشترى رقم تليفون أرضي حلو: `2888-8888`. خطّين تليفون، طلبة جامعة بيردوا على الناس وبيشوفوا محلات قريبة وبيوصّلوهم. كل البيانات اتجمعت **يدويًا door-to-door** من طلبة بيتحققوا من كل محل بالتليفون. وصلوا لمليون listing مُتحقَّق منه قبل أي موقع أو تطبيق.
- **التكتيك المحدد:** **رقم تليفون واحد + بنى أدمي يرد + كتالوج محلات يتم بناؤه يدويًا door-to-door.** المستخدم ميحتاجش يحمّل تطبيق. بيتصل، بيقول "عايز بقال جنب البيت بتاعي" → بنى أدمي يرد ويقول له اسم وعنوان.
- **التطبيق على WASALNI كفر المقدام:** الـMVP الأول ممكن يبقى **رقم WhatsApp واحد**: "كلّمنا، قول لنا محتاج إيه، هنبعتلك أقرب 3 محلات عندهم اللي إنت عايزه + رقمهم". انت بتعمل الـmatching يدويًا. **مفيش تطبيق. مفيش حتى موقع.** الـsearch engine = إنت.

**المصادر:**
- [Justdial Success Story — StartupTalky](https://startuptalky.com/justdial-success-story/)
- [Justdial Brief History](https://canvasbusinessmodel.com/blogs/brief-history/justdial-brief-history)

### Khatabook (الهند) — Word-of-Mouth بين أصحاب المحلات
- **القصة:** تطبيق دفاتر حسابات لأصحاب المحلات الصغيرة (kirana). أُسِّس أغسطس 2018. وصل **10 مليون تحميل في أقل من سنة، 9 مليون مستخدم نشط شهري، في 95% من مقاطعات الهند**. والمفاجأة: *"the start-up has not spent any money on marketing and all the downloads have come through organic searches."* النمو كله organic، بسبب: (1) Hindi-first + 12 لغة إقليمية، (2) word-of-mouth بين أصحاب المحلات نفسهم — صاحب محل بيقول لجاره، (3) حل مشكلة حقيقية مؤلمة (الديون والمحاسبة على ورق).
- **التكتيك المحدد:** **اللغة المحلية مش option، فرض.** + **الـB2B word-of-mouth بين أصحاب المحلات أقوى من أي إعلان**، لأن صاحب المحل بيصدّق جاره مش بيصدّق إعلان.
- **التطبيق على WASALNI كفر المقدام:** (1) كل حرف في التطبيق **عامية مصرية ريفية**، مش فصحى، مش "إنجليزي تم تعريبه". "اتسوق"، "هاتلي"، "محل عمو حسن". (2) لما توصل لـ5 محلات راضية، **اطلب منهم يكلّموا 5 محلات تانية كل واحد**. اكسر الـloop ده.

**المصادر:**
- [Khatabook 10M downloads in a year — Entrepreneur](https://www.entrepreneur.com/en-in/technology/this-fintech-app-has-10-million-plus-downloads-within-a/344167)
- [Khatabook — Inc42](https://inc42.com/startups/sequoia-surge-backed-khatabook-is-helping-indian-shopkeepers-get-cashback/)

### Meesho (الهند) — WhatsApp-First Marketplace
- **القصة:** Meesho بدأت كـ**WhatsApp group** عادي. الموسسون كانوا بيدّخلوا الـsellers والـbuyers يدويًا، وبيديروا كل transaction واحدة واحدة. **مفيش app في الأول.** بعدين بنوا الـapp بس عشان يأتمتوا اللي بقى متعب. النموذج كله مبني على **resellers (في الغالب ستات بيشتغلوا من البيت)** بياخدوا منتجات من Meesho ويعيدوا بيعها على WhatsApp/Facebook بسعر زيادة. Meesho بقت aggregator + لوجستيات بس. كومّيشن صفر للـsuppliers، بيدفعوا بس لما يبيعوا.
- **التكتيك المحدد:** **(1) ابدأ على WhatsApp قبل أي app.** (2) **استخدم resellers محليين كـdistribution layer** — مش لازم انت توصل لكل عميل، خلي محليين عندهم ثقة بمجتمعهم يفعلوا كده. (3) **صفر مخاطرة على الـsupplier** = صفر commission upfront، صفر inventory.
- **التطبيق على WASALNI كفر المقدام:** ابدأ **WhatsApp Business group** اسمه "وصلني كفر المقدام". لو لقيت 3-5 ستات بيوت/طلبة جامعة في القرية مستعدين يبقوا "ambassadors" — كل واحد(ة) عنده 50-100 جار/قريب في WhatsApp يبعتلهم العروض من المحلات، ده الـ"reseller layer". صفر فلوس على المحل، بس لو حصلت بيعة من الـambassador الـambassador بياخد عمولة صغيرة (5-10%).

**المصادر:**
- [Meesho doing things that don't scale](https://www.alexanderjarvis.com/meesho-doing-things-that-dont-scale/)
- [Meesho GTM Strategy Teardown — upGrowth](https://upgrowth.in/meesho-built-social-commerce-india-gtm-strategy-teardown/)
- [Meesho — Inc42](https://inc42.com/startups/meesho-revamps-indias-unorganised-retail-by-empowering-resellers/)

### ShareChat (الهند) — Vernacular-First للـtier 2/3
- **القصة:** الموسسون لقوا Sachin Tendulkar fan group على WhatsApp فيه آلاف الناس بيتكلموا **بلغاتهم الإقليمية**، مش إنجليزي. لاحظوا إن مفيش social media هندية بتخدم اللغات دي. أول منتج كان مجرد **أداة لمشاركة محتوى على WhatsApp groups**. نمت virally جوه آلاف الـWhatsApp groups قبل ما تبقى تطبيق. النهاردة 325 مليون مستخدم شهري، **95% منهم من مدن غير metropolitan**.
- **التكتيك المحدد:** **(1) WhatsApp groups هي قناة التوزيع الأولى، مش الـApp Store.** (2) المحتوى بلغة الناس الحقيقية — مش مجرد ترجمة. (3) كان "tool" قبل ما يبقى "platform".
- **التطبيق على WASALNI كفر المقدام:** قبل أي تطبيق، **انضم/ادخل في WhatsApp groups القرية الموجودة فعلًا**. مجموعة أهل القرية، مجموعة شباب الجامع، مجموعة جمعية كذا. مشاركة محتوى مفيد (مين بياع كذا، فين عرض كذا) بدون رابط للتطبيق في الأول. اكسب ثقة، بعدين قول "في تطبيق بيعمل ده بشكل أسهل".

**المصادر:**
- [ShareChat — Strategy Boffins](https://www.strategyboffins.com/start_up_strategy/sharechat-indias-linguistic-diversity/)
- [Twitter invests in ShareChat — KrASIA](https://kr-asia.com/twitter-invests-in-indias-sharechat-as-local-vernacular-market-burgeons)

### M-Pesa (كينيا) — الـAgent Network كـDistribution Backbone
- **القصة:** Safaricom كان عنده شبكة وكلاء بيبيعوا كروت شحن في كل ركن في كينيا. **بدل ما يبني شبكة جديدة، حوّل وكلاء الشحن لوكلاء M-Pesa.** يعني كل محل بقّال صغير في القرية بقى نقطة سحب وإيداع. التحدي الأكبر في الـpilot كان "كسب ثقة الوكلاء" نفسهم. حلوها بـincentive: 5% خصم لو اشتريت رصيد عن طريق M-Pesa. النهاردة 381 ألف وكيل + 82 مليون حساب.
- **التكتيك المحدد:** **متبنيش شبكة جديدة. ركب على شبكة موجودة.** أي حد عنده "feet on the ground" تجاري في القرى ممكن يبقى الـdistribution layer.
- **التطبيق على WASALNI كفر المقدام:** فيه شبكات موجودة في كفر المقدام ممكن نركب عليها: **محلات الشحن (Fawry, Vodafone Cash)** — كل قرية فيها. **محلات الموبايلات** — أصحابها فاهمين موبايل وعندهم سلطة فنية على القرية. **محلات البقالة الكبيرة** — مركز اجتماعي. اختار 3-5 محلات من دول كـ"super-nodes"، اعملهم training شخصي، وادفع لهم على كل محل/مستخدم بيدخلوه على التطبيق.

**المصادر:**
- [M-Pesa — Wikipedia](https://en.wikipedia.org/wiki/M-Pesa)
- [M-Pesa World Bank Case Study](https://documents1.worldbank.org/curated/en/832831500443778267/pdf/117403-WP-KE-Tool-6-7-Case-Study-M-PESA-Kenya-Series-IFC-mobile-money-toolkit-PUBLIC.pdf)

### Glovo (إسبانيا → إفريقيا)
- **القصة:** بدأت في برشلونة 2015 بـ€140,000 بس. خلال أول 8 شهور وصلت لـ50,000 مستخدم نشط و10,000 طلبية يوميًا، بس **عن طريق التركيز على مدينة واحدة قبل التوسع**. اختياراتهم للمدن دايمًا cosmopolitan + كثافة سكانية عالية + جمهور شبيه بالـcustomer profile.
- **التكتيك المحدد:** **مدينة واحدة لحد ما تشتغل، بعدين كرّر النموذج.** متعدّش لمدينة تانية قبل ما الأولى تبقى ربحية على وحدة (unit economics).
- **التطبيق على WASALNI كفر المقدام:** **متفكّرش في الزقازيق أو طنطا أو حتى قرى مجاورة لـ12 شهر على الأقل**. كفر المقدام لازم تبقى ناجحة 100% قبل أي توسع. والـ"نجاح" هنا = retention + revenue على الـunit، مش downloads.

**المصادر:**
- [Glovo success story — Santalucia Impulsa](https://www.santaluciaimpulsa.es/en/blog/el-caso-de-exito-de-la-startup-espanola-glovo)
- [Glovo — Wikipedia](https://en.wikipedia.org/wiki/Glovo)

### WhatsApp — الـViral via SMS Replacement
- **القصة:** Jan Koum وBrian Acton اترفضوا من Facebook، عملوا تطبيق صغير اسمه WhatsApp. الـbreakthrough جاء لما Apple طلعت push notifications يونيو 2009 — أصدقاء Koum الروس بدأوا يستعملوه بدل SMS. **viral growth جاء من إن المنتج كان أرخص من البديل (SMS غالي).**
- **التكتيك المحدد:** ابني منتج **أرخص بـ10x من البديل الحالي** للمستخدم. النمو يبقى inherent.
- **التطبيق على WASALNI كفر المقدام:** البديل الحالي للناس في كفر المقدام = **يمشوا للسوق + يسألوا + يجولوا**. الوقت = العملة. لو WASALNI بتوفر 30 دقيقة في الأسبوع، ده 10x أرخص. لكن لازم يكون فعلي، مش وعد.

**المصادر:**
- [Jan Koum — Wikipedia](https://en.wikipedia.org/wiki/Jan_Koum)
- [The WhatsApp Story — Digital One](https://digitaloneagency.com.au/the-whatsapp-story/)

### Truecaller (الهند) — Viral via Phone Book Sync
- **القصة:** Truecaller وصلت لـ350 مليون مستخدم في الهند عن طريق **استغلال phone book sync**. كل مستخدم بيحمّل التطبيق بيرفع كل arguments من telefonbuch بتاعه. الناس اللي مش حتى عندهم التطبيق بقى عندهم profiles في Truecaller. الـlist بقت crowdsourced لـspam identification.
- **التكتيك المحدد:** **استخدم data موجودة عند المستخدمين الأوائل لبناء قيمة للمستخدمين اللي ميجوا بعدهم.** كل مستخدم بيخلي التطبيق أحسن للي بعده.
- **التطبيق على WASALNI كفر المقدام:** ممكن WASALNI تستخدم نفس الفكرة لكن أخلاقيًا. لما ساكن يفتح التطبيق ويسجل، اطلب منه **يضيف 3 محلات هو بيتعامل معاها** + رأيه فيهم. كل user بيعمل enrichment للـcatalog. الميزة دي هي اللي تخلي WASALNI أحسن من Google Maps في كفر المقدام.

**المصادر:**
- [TrueCaller — Rest of World](https://restofworld.org/2022/how-truecaller-built-a-billion-dollar-id-data-empire-in-india/)

---

## 3. الـ Playbooks التكتيكية

### الـ"Door-to-Door Supply Onboarding"
- **مين عمله:** Khatabook, Meesho, Justdial, Khatabook — كل واحد فيهم كان عنده field force يدخل المحلات الواحدة الواحدة.
- **التطبيق على WASALNI:** **انت بنفسك = field force**. هدف 5 محلات في الأسبوع شخصيًا. تطبيق العنصر ده **مش option**. أي founder بيقول "بس هخليهم يسجلوا من الـPlay Store" هيفشل.

### الـ"Concierge MVP"
- **مين عمله:** Airbnb (photo service)، DoorDash (founder delivered)، Zappos (Nick Swinmurn كان يجري للمحل ويشتري الجزمة بعد كل طلب)، Seamless (موسسوها كانوا يجمعوا طلبات المحامين بإيدهم).
- **التطبيق على WASALNI:** لكل طلب في أول شهرين، **انت الـsystem**. الطلب يجيلك على WhatsApp، انت بتكلم المحل، انت بتنظم. لو ضحكت الموقف، ده دليل إنك بتحل مشكلة فعلية.

### الـ"WhatsApp-First"
- **مين عمله:** Meesho، ShareChat، عشرات الـcommunity startups في الهند وإفريقيا.
- **التطبيق على WASALNI:** الـMVP الأول لازم يكون WhatsApp Business مش app. التطبيق يجي بعد ما يبقى عندك 50+ تعامل WhatsApp في الأسبوع وتحس بالألم في الإدارة.

### الـ"Catalog/Listing Only" (نموذج Justdial الأصلي)
- **مين عمله:** Justdial، Yellow Pages قبل كده.
- **التطبيق على WASALNI:** **متفكرش في transactions أو payments أو delivery في الأول.** بس "fish فين، عنده إيه، رقمه إيه". ده الـMVP. الـtransactions زي ما Meesho بدأت بدون تشيك آوت، انت تكلّم المحل بـWhatsApp فاضي.

### الـ"Operator-Mediated"
- **مين عمله:** Justdial في 1996.
- **التطبيق على WASALNI:** قبل التطبيق، فيه رقم WhatsApp واحد + شخص (انت) يرد. "محتاج كذا في كفر المقدام" → ترد بـ3 محلات أقرب + رقمهم. هتعرف اللي الناس بتطلبه فعلًا قبل ما تكتب سطر كود.

### الـ"Single-Player Mode"
- **مين عمله:** Pinterest (collected pins solo قبل ما يبقى social)، Airbnb wishlists.
- **التطبيق على WASALNI:** الـapp لازم يبقى مفيد لمستخدم **حتى لو هو الوحيد فيه**. مثلًا: "احفظ المحلات اللي بتتعامل معاها"، "اعرف ساعات الفتح لكل محل في القرية". ده مفيد للمستخدم لوحده، بدون أي محل سجّل نفسه على التطبيق.

### الـ"Demand Aggregation"
- **مين عمله:** كل startup عمل waitlist landing page قبل الكود.
- **التطبيق على WASALNI:** **اعمل صفحة Facebook اسمها "وصلني — كفر المقدام"**. انشر "كل أسبوع: عرض خاص من 3 محلات في القرية". اجمع طلبات/تعليقات/messages. لو في 6 أسابيع جمعت 200 تعليق/message من ناس عايزة الخدمة دي، عندك demand موثّق.

**المصادر:**
- [Do Things That Don't Scale — Paul Graham](https://www.paulgraham.com/ds.html)
- [Zappos and the Wizard of Oz](https://medium.com/nikhilvarshneypandb/zappos-and-the-wizard-of-oz-a-relentless-customer-success-story-everyone-should-learn-3c7dd99fc97)
- [Marketplaces Zero Player Mode — Alex Macdonald](https://alexfmac.substack.com/p/-marketplaces-zero-player-mode)
- [How Did Successful Startups Use Do Things That Don't Scale — VC Jobs](https://www.venturecurator.com/p/how-did-successful-startups-use-paul)

---

## 4. الفشل اللي لازم نتجنبه

### "Build it and they will come"
- **القصة:** 90% من الـhyperlocal apps بتفشل لأن الموسسين بنوا تطبيق وانتظروا أصحاب المحلات يسجّلوا من Play Store. ده **مايحصلش**. صاحب المحل في القرية مش بيتفرّج على Play Store. هو محتاج حد يدخل المحل، يقعد معاه، يفتحله شاشة ويعدل له الـcatalog.
- **الدرس لـWASALNI:** أي مرحلة فيها "self-service onboarding للمحلات" قبل ما يبقى عندك 100+ محل = wishful thinking.

### Premature Feature Expansion
- **القصة:** Hyperlocal apps في الهند فشلت لأنها ضافت delivery + payments + reviews + reservations قبل ما تثبت الـlistings basic. زي الـ**unit economics** بتاع 5-8% margin على ASP منخفض في الهند، كانت قاتلة لمعظمهم.
- **الدرس لـWASALNI:** بعدد الـfeatures في الـ backend اللي اتبنى = warning sign، مش milestone.

### Multi-City Expansion Too Fast
- **القصة:** كتير من الـstartups نشروا أنفسهم على 5 مدن في 6 شهور وفقدوا التركيز. Glovo قعدت سنة كاملة في برشلونة قبل التوسع.
- **الدرس لـWASALNI:** كفر المقدام **بس** لـ12 شهر. لو في حد سأل "إمتى الزقازيق؟" الإجابة: "لما كفر المقدام تبقى ربحية".

### Premature Monetization
- **القصة:** OkCredit وKhatabook كانوا مجانيين 100% لسنوات. مفيش commission. مفيش subscription. ده اللي خلى المحلات تجرّب.
- **الدرس لـWASALNI:** **الـsubscription model اللي في الـspec الأصلي (Free/Basic/Pro/Premium) لازم يتأجل لـPhase 2.** في الـ12 شهر الأولى: مجاني 100%. لو سألت محل لفلوس قبل ما تثبت قيمة، هترجع المحل ميكلمكش تاني.

### App-First بدل WhatsApp/Web
- **القصة:** Meesho وShareChat بدأوا على WhatsApp وكسبوا ملايين قبل ما يبقى عندهم app. WASALNI عملت العكس: بنت app كامل مع backend قبل user واحد.
- **الدرس لـWASALNI:** **هنا الـpivot الحقيقي محتاج يحصل.** الـbackend اللي اتبنى ممكن يبقى على الرف لحد لما الـWhatsApp MVP يثبت في حاجة.

**المصادر:**
- [Hyperlocal Startups That Failed — Techstory](https://techstory.in/hyperlocal-startups-failure/)
- [Problems and Challenges For Hyperlocal Delivery App — Kody](https://kodytechnolab.com/blog/problems-challenges-hyperlocal-delivery-app/)
- [Why Hyperlocal Models May Fail in India — LinkedIn](https://www.linkedin.com/pulse/why-hyperlocal-models-may-fail-india-ankit-malhotra)
- [Digital Onboarding Mistakes African Startups — VoveID](https://blog.voveid.com/digital-onboarding-mistakes-african-startups-keep-making-in-2025/)

---

## 5. الـ"Manual MVP" قبل الكود

### أمثلة MVPs بدون كود
- **Airbnb:** صفحة سريعة + 3 مراتب هوا.
- **Zappos:** Nick Swinmurn كان يصوّر جزم من محلات محلية ويحطها على موقع، ولو حد يطلب يجري للمحل يشتريها ويبعتها.
- **Meesho:** WhatsApp group لشهور.
- **DoorDash:** PDFs + رقم موبايل.
- **Justdial:** خطين تليفون + طلبة بيردوا.
- **Buffer:** صفحة landing لمدة أسبوعين قبل أي كود — لو ضغطوا "Plans" يطلع "هنبعتلك لما يجهز".
- **Groupon:** WordPress + PDFs بـemail يدوي لكل صفقة.

### نمط الـ"Wizard of Oz"
- **التعريف:** المستخدم بيتعامل مع interface تبدو automated، لكن وراها بنى أدمي بيشتغل manual.
- **مثال WASALNI:** المستخدم يبعت WhatsApp message "محتاج لبن"، يلاقي رد سريع بـ"تمام، بعتنالك أقرب 3 محلات" — الرد ده انت اللي بعته يدويًا، لكن بالنسبة للمستخدم بقى شبه automated.

### الـMom Test (Rob Fitzpatrick) — إزاي تكلم الناس
- **المبدأ:** كل ما تسأل واحد عن فكرتك، حتى أمك هتقولك "حلوة". اسأل عن **سلوكه الفعلي**، مش عن رأيه في الفكرة.
- **أسئلة غلط:** "هتستخدم تطبيق لطلب من محلات كفر المقدام؟" → كله هيقولك "آه".
- **أسئلة صح:**
  - "آخر مرة احتجت حاجة من السوق، عملت إيه؟"
  - "كام دقيقة قعدت في السوق آخر مرة؟"
  - "في حاجة كنت محتاجها ومش لاقيها؟ اشتريتها منين في الآخر؟"
  - "ممكن تفتحلي WhatsApp/Facebook بتاعك وتوريني آخر مرة كلمت حد عشان تسأل عن منتج؟"
- **القاعدة الذهبية:** لو الواحد بيتكلم عن الـpast بدل الـfuture = أنت بتجمع data حقيقي. لو بيتكلم عن "هـ" و"ممكن" = anecdotes فاضية.

**المصادر:**
- [The Mom Test — UXtweak](https://blog.uxtweak.com/the-mom-test/)
- [Wizard of Oz Experiment — Learningloop](https://learningloop.io/plays/wizard-of-oz)
- [Zappos MVP Case Study](https://whatismvp.com/case-studies/zappos-mvp-case-study.html)
- [Do Things That Don't Scale — Paul Graham](https://www.paulgraham.com/ds.html)

---

## 6. السياق الريفي / منخفض التكنولوجيا

### Trust Nodes — مين بيفتح الباب في قرية مصرية
- **القصة:** في أبحاث technology adoption في المساجد ومجتمعات إسلامية، اللي بيقرر إن تكنولوجيا تنتشر في القرية مش "اللي معاه أحسن منتج"، بل **"اللي عنده ثقة الناس"**. الأئمة، شيوخ الجمعيات، عمدة، رجال السوق المعروفين.
- **التطبيق على WASALNI:**
  - **خد موعد مع عمدة كفر المقدام أو مأمور القسم.** اعرض المشروع، اطلب مباركة (مش فلوس). الـtrust transfer أهم من أي مارجن.
  - **خد المنتج الأول مجانًا للجامع الكبير أو الجمعية الخيرية:** "هنحط إعلانات تبرعات/مواعيد محاضرات على التطبيق". مفيش commission. ده بيخلق "social proof".
  - **اكتشف "محل السوق الأكبر" (اللي اللي كل القرية بتروحه):** صاحبه هو "super-node". لو هو على التطبيق، هو هيقول لـ20 محل تاني.

### قصص shop adoption في سياقات شبيهة
- **Pratilipi (الهند):** منصة قراءة بـvernacular content. بدأوا في tier 3 cities. اشتغلوا مع كتّاب محليين كـambassadors.
- **Mahindra Krishi-e:** تطبيق للفلاحين الهنود. عملوا offline kiosks في القرى عشان الناس اللي بدون smartphone يستفيدوا.
- **Tonse Wikipedia (Tonga):** بدأت بمحتوى من كاتب واحد قعد سنة كاملة يكتب بنفسه عشان يحفّز ناس تانية تكتب.

### Low-Tech UX Lessons
- **IRCTC (الهند):** UX سيئة، أنشأت كل سنة بضع مليارات دولار، لأن الـjob-to-be-done قوي جدًا (حجز قطار). الدرس: **الـUX مش هي القاتل في الأسواق منخفضة الـUX expectations، المحتوى والـrelevance همّ القاتل.**
- **Truecaller:** نجح في الهند مش بس بسبب الميزة، لكن لأن **install friction قليل + value فوري عند أول call**.

**المصادر:**
- [The Adoption and Utilization of Technology in the Mosques](https://policyjournalofms.com/index.php/6/article/download/281/274)
- [The Role of Mosques in Community Development — GlobalSadaqah](https://blog.globalsadaqah.com/he-role-of-mosques-in-community-development/)
- [Community Animators in Technology Adoption — arXiv](https://arxiv.org/pdf/1902.05630)

---

## القسم النهائي 1: خطة Bootstrap محتملة لـ WASALNI كفر المقدام — 90 يوم

### الأسبوع 1-2: الـDiscovery Phase (صفر كود)
- روح كفر المقدام شخصيًا 3 أيام على الأقل.
- اعمل **20 Mom Test interview** مع سكان عاديين (مش أصحاب محلات لسه). اسأل عن الـpast behavior. لا تذكر التطبيق.
- اعمل **10 interviews مع أصحاب محلات** عن مشاكلهم اليومية، بدون ذكر التطبيق.
- **خرجة الأسبوع:** قائمة بأكتر 3 مشاكل ذكروها (مش متخيلين)، + قائمة بـ20 محل في الشارع الرئيسي.

### الأسبوع 3-4: الـValidation Phase (ولا سطر كود)
- اعمل **صفحة Facebook اسمها "وصلني — كفر المقدام"**.
- اعمل **WhatsApp Business number** عليه نفس الاسم.
- ابدأ تنشر يوميًا: "محل كذا عنده كذا، رقمه كذا" (بإذن صاحب المحل). 5 محلات تجربها على نفقتك الخاصة.
- اطلب من الناس يبعتولك على الـWhatsApp لو محتاجين حاجة، انت هتلاقيلهم.
- **خرجة الأسبوع:** عدد الـmessages اللي جالك، عدد المحلات اللي قبلت تتعرض. **Kill criterion:** لو في 4 أسابيع جالك < 10 message عضوي → فيه مشكلة في الـdemand، توقف.

### الأسبوع 5-8: الـConcierge MVP
- زوّد لـ20 محل في كفر المقدام (Door-to-door manually).
- صوّر لكل محل **5 صور احترافية بالموبايل** لمنتجاته. (Airbnb model)
- خلي كل محل ينشر صوره على Facebook page بتاع "وصلني". انت اللي تنشر، مش هو.
- **متفكّرش في app لسه.** الواجهة = صفحة Facebook + WhatsApp.
- **خرجة المرحلة:** 20 محل، ≥50 طلب/استفسار على WhatsApp في الأسبوع. **Kill criterion:** لو < 20 طلب/أسبوع في الأسبوع 8 → تطبيق مش هيحل المشكلة. اللي ناقص هو الـvalue prop.

### الأسبوع 9-12: الـMinimal Web App (مش mobile)
- بعد ما الـWhatsApp MVP بيتعب فعلًا (>50 message/يوم)، ابني **web page بسيطة** = list of shops + photos + WhatsApp link.
- لا backend. لا login. لا profiles. **Static HTML أو Next.js basic.**
- خلي الـshops يعدّلوا بياناتهم عن طريق Google Form (انت تنقل البيانات للموقع).
- استمر في الـ"Wizard of Oz": كل طلب على WhatsApp انت بتديره يدويًا.
- **خرجة المرحلة:** ≥ 30 محل نشط، ≥ 100 user بيدخل الموقع/أسبوع. **Kill criterion:** لو الـrepeat user rate < 20% بعد 4 أسابيع من الموقع → الـvalue ضعيفة، اعيد تفكير.

### الأسبوع 13+ (بعد 90 يوم): قرار الـPivot or Continue
- لو الأرقام كويسة → **هنا ابتدي تفكر في mobile app**. الـbackend اللي اتبنى قبل كده هيبقى مفيد هنا، لكن بـscope أصغر جدًا (في الغالب 30% منه).
- لو الأرقام مش كويسة → **pivot أو وقف**. كل المعلومات اللي جمعتها في الـ90 يوم دي = كنز. اقرأها وفكر تاني.

---

## القسم النهائي 2: الـManual MVP المقترح قبل أي كود

**قبل أي سطر كود جديد، نفّذ بالترتيب ده على مدى 60 يوم:**

| الأداة | الغرض | التكلفة |
|---|---|---|
| **WhatsApp Business** | الواجهة الأساسية للمستخدمين والمحلات | مجاني |
| **Facebook Page** "وصلني — كفر المقدام" | الـpublic catalog، اكتشاف، demand validation | مجاني |
| **Google Sheet** | "قاعدة بيانات" المحلات والمنتجات والطلبات (انت بتعبّيه يدويًا) | مجاني |
| **Google Form** | "تسجيل محل جديد" (انت تنقل لـSheet) | مجاني |
| **Google Maps Pins** (My Maps) | خريطة المحلات | مجاني |
| **Canva** | تصميم posts (3 في الأسبوع لكل محل) | مجاني |
| **رقم موبايل + كاميرا موبايل** | تصوير المحلات بنفسك | عندك |

**القاعدة:** لو لقيت نفسك بتقول "الـSheet مش كفاية، محتاج database حقيقي" — ده signal إن **الـmanual MVP اشتغل** ووقت ما تبدأ تأتمت. مش قبل كده.

**المهام اليومية في الـ60 يوم دي:**
- **الصبح:** زيارة 2-3 محلات door-to-door. تصوير صورتين. رفعهم على Facebook.
- **الظهر:** الرد على WhatsApp messages. عمل matching بين الـrequests والمحلات.
- **العصر:** Mom Test interview واحد على الأقل (مستخدم أو محل).
- **بليل:** كتابة retrospective قصير: "ايه اللي حصل النهاردة، ايه pattern لاحظته".

---

## القسم النهائي 3: معايير القتل (Kill Criteria)

**كل criterion هو نقطة قرار صارمة. لو ميتحققش، توقف وفكر تاني، مكمّلش لمجرد إنك صرفت وقت.**

### Kill Criterion #1 — الـDemand Validation (نهاية أسبوع 4)
**إذا:** في 4 أسابيع كاملة من النشر اليومي على Facebook + WhatsApp، جالك **< 10 organic messages** من سكان (غير المعارف الشخصيين) بيسألوا عن منتج/محل.
**معناه:** الـdemand مش موجودة بالشكل اللي إنت متخيله. القرية بتشتري بطرق تانية إنت مش فاهمها.
**الإجراء:** قعدة عميقة مع 10 ساكنين تاني. اسأل ليه بالظبط مفيش حاجة جالك. ممكن الـvalue prop غلط.

### Kill Criterion #2 — الـSupply Onboarding (نهاية أسبوع 8)
**إذا:** بعد 8 أسابيع من الزيارات door-to-door (≥ 60 ساعة وقتك)، **< 15 محل قبل يتعاون معاك** (يديك صور + يرد على WhatsApp).
**معناه:** الـtrust مش موجودة، أو الـvalue مش واضحة للمحلات.
**الإجراء:** ابحث عن trust node (عمدة، إمام، صاحب محل كبير). لو موجدتش حد يفتح لك أبواب، الـbottleneck = ثقة، مش منتج.

### Kill Criterion #3 — الـRetention (نهاية أسبوع 12)
**إذا:** بين الـ100 user الأول، **< 20% رجعوا تاني** في الأسبوع اللي بعد أول استخدام.
**معناه:** المنتج بيحل مشكلة لمرة واحدة، مش habit. ده **مش marketplace**، ده "حاجة لطيفة جربتها مرة".
**الإجراء:** اسأل الناس اللي مرجعوش ليه. على الأغلب الإجابة هتدلك على اللي ناقص.

### Kill Criterion #4 — الـUnit Economics (نهاية أسبوع 16)
**إذا:** الوقت اللي بتاخده كل تعامل (founder time) **مش بينقص** مع الوقت. يعني الأسبوع الـ16 بياخد نفس وقت الأسبوع الـ8.
**معناه:** المنتج مش قابل للأتمتة. كل تعامل محتاج founder. مش marketplace ده، ده consulting.
**الإجراء:** فكّر في business model مختلف. أو وقف.

### Kill Criterion #5 — الـCash (دايمًا)
**إذا:** صرفت **> 30,000 جنيه من جيبك** بدون أي **revenue واحد** (مش "users"، revenue).
**معناه:** لا تستمر بدون validation مالية، حتى لو رمزية.
**الإجراء:** خد محل واحد بياع شغّال، اعرض عليه ينشر إعلان مدفوع بـ50 جنيه. لو رفض، الـvalue غير واضحة. لو وافق، عندك revenue واحد. ابني من هنا.

### الـMaster Kill Criterion (الأهم):
**إذا** بعد 6 أشهر من الـmanual MVP، **مفيش 10 محلات** بيشغّلوا WASALNI بـ**daily routine** (يعني بيدخلوا، بيحدّثوا، بيردوا على استفسارات) **بدون متطلبهم منهم** → **WASALNI كمنتج مش محتاجة**. القرية بتشتغل من غيرها.
**الإجراء:** Hard pivot أو shutdown. مش fail. ده **اللي بحثت عنه**: حقيقة بدل وهم.

---

## المراجع المُجمَّعة

### الإطار النظري
- [The Cold Start Problem — Andrew Chen](https://www.coldstart.com/)
- [Cold Start Problem Summary — Brian's Notes](https://www.briansnotes.io/book/the-cold-start-problem/)
- [How to Kickstart and Scale a Marketplace — Lenny Rachitsky](https://www.lennysnewsletter.com/p/how-to-kickstart-and-scale-a-marketplace)
- [Marketplace Cold Start Pattern](https://themarketplaceguide.com/patterns/cold-start/)
- [Do Things That Don't Scale — Paul Graham](https://www.paulgraham.com/ds.html)

### قصص Bootstrap
- [Airbnb doing things that don't scale](https://www.alexanderjarvis.com/airbnb-doing-things-that-dont-scale/)
- [DoorDash Concierge MVP — Orchid](https://builtbyorchid.com/doordash-concierge-mvp/)
- [Justdial Success Story — StartupTalky](https://startuptalky.com/justdial-success-story/)
- [Khatabook — Inc42](https://inc42.com/startups/sequoia-surge-backed-khatabook-is-helping-indian-shopkeepers-get-cashback/)
- [Meesho doing things that don't scale](https://www.alexanderjarvis.com/meesho-doing-things-that-dont-scale/)
- [Meesho GTM Strategy — upGrowth](https://upgrowth.in/meesho-built-social-commerce-india-gtm-strategy-teardown/)
- [ShareChat — Strategy Boffins](https://www.strategyboffins.com/start_up_strategy/sharechat-indias-linguistic-diversity/)
- [M-Pesa Wikipedia](https://en.wikipedia.org/wiki/M-Pesa)
- [Glovo Success Story — Santalucia](https://www.santaluciaimpulsa.es/en/blog/el-caso-de-exito-de-la-startup-espanola-glovo)
- [WhatsApp Founder Story — Founderoo](https://www.founderoo.co/playbooks/brian-acton-jan-koum-whatsapp-19-billion-business-that-started-with-rejection)
- [Truecaller — Rest of World](https://restofworld.org/2022/how-truecaller-built-a-billion-dollar-id-data-empire-in-india/)
- [Zappos Wizard of Oz MVP](https://whatismvp.com/case-studies/zappos-mvp-case-study.html)
- [OYO Success Story — OrangeOwl](https://orangeowl.marketing/unicorn-chronicles/oyo-success-story/)

### الفشل والـFrameworks
- [Hyperlocal Startups That Failed — Techstory](https://techstory.in/hyperlocal-startups-failure/)
- [Why Hyperlocal Models May Fail in India](https://www.linkedin.com/pulse/why-hyperlocal-models-may-fail-india-ankit-malhotra)
- [Digital Onboarding Mistakes African Startups — VoveID](https://blog.voveid.com/digital-onboarding-mistakes-african-startups-keep-making-in-2025/)
- [The Mom Test — UXtweak](https://blog.uxtweak.com/the-mom-test/)
- [Wizard of Oz Experiment — Learningloop](https://learningloop.io/plays/wizard-of-oz)
- [Marketplaces Zero Player Mode — Alex Macdonald](https://alexfmac.substack.com/p/-marketplaces-zero-player-mode)
- [How Smart Founders Know When to Pivot — Entrepreneur](https://www.entrepreneur.com/starting-a-business/how-smart-founders-know-when-to-pivot-or-shut-down-their/499280)
- [Adoption of Technology in Mosques](https://policyjournalofms.com/index.php/6/article/download/281/274)
