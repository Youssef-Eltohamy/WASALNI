# 🧬 Synthesis — الأنماط اللي اشتغلت فمنصات كتيرة

> **التركيب من 9 أبحاث + بحثي المباشر.** الأنماط دي اتكررت بشكل **مستقل** فأكتر من تطبيق و دراسة. لما حاجة تظهر فـ 5+ مصادر مختلفة، دي مش "فكرة"، دي **قانون يجب اتباعه**.

**التاريخ:** 2026-05-26

---

## التصنيف
- 🥇 **قانون قوي** — يظهر فـ 5+ مصادر، لا يُتنازل عنه
- 🥈 **نمط مهم** — يظهر فـ 3-4 مصادر، يُتبع باستثناءات محدودة
- 🥉 **فكرة قيّمة** — يظهر فـ 2 مصادر، يُدرس و يقرر

---

# الجزء 1 — قوانين البناء (المبادئ المعمارية)

## 🥇 قانون 1: ابدأ بالـ Demand، مش بالـ Supply

**يظهر فـ:** Vezeeta، Airbnb، DoorDash، Justdial، Khatabook، Meesho

**القاعدة:** الـ two-sided marketplaces بيموتوا لما يبدأوا بالـ supply side (تجميع المحلات/الأطباء/الخدمات) قبل ما يتأكدوا إن في demand حقيقي. الـ supply مش هيستمر لو الـ users مش بيستخدموا.

**أمثلة:**
- **Vezeeta** بدأت كـ EMR للأطباء (supply-first) — فشلت. عملت pivot لـ patient-booking → 10M مريض.
- **DoorDash** بدأت بـ PDFs من النت + رقم تليفون المؤسس — كانوا بيتأكدوا الـ demand قبل أي تكنولوجيا.
- **Airbnb** سافروا NYC و صوروا الشقق بنفسهم — but only after demand was proven.

**التطبيق لـ WASALNI:**
- **مش تسجل محلات قبل ما تتأكد إن في users بيبحثوا.**
- ابدأ بـ "اسأل القرية: انت بتدوّر على ايه؟" — قبل أي signup.
- اعمل قائمة الـ pain points الحقيقية (تصليح، خدمات، طلبات معينة) قبل ما تروح للمحل.

---

## 🥇 قانون 2: ابدأ Manual / Wizard of Oz، Tech تيجي تاني

**يظهر فـ:** Airbnb، DoorDash، Justdial (سنينه الأولى)، Meesho، Dunzo، Zappos

**القاعدة:** أنجح الـ marketplaces ابتدت **بدون أي تطبيق**. WhatsApp group + Google Form + Excel sheet + المؤسس بنفسه بيرد. ده "Wizard of Oz" — اليوزر بيشوف "تطبيق"، بس فالحقيقة في founder بيشتغل ٢٤ ساعة.

**أمثلة:**
- **DoorDash:** founder phone number + manual delivery + PDFs.
- **Justdial:** كانوا مجرد رقم تليفون + ناس بترد + كتالوج ورقي لمدة سنوات.
- **Meesho:** بدأت كـ WhatsApp group، الـ founders بيديروا transactions يدوياً.
- **Dunzo:** سنة كاملة على WhatsApp manual، 700k user قبل أي app.
- **Zappos:** صوروا أحذية من محلات تانية، اشتروا و ارسلوها لما طلب يجي.

**التطبيق لـ WASALNI:**
- **اول 30-60 يوم:** WhatsApp Channel "وصلني كفر المقدام" + Google Sheet للمحلات + إنت بترد بنفسك.
- ⚠️ **مش تكتب سطر Flutter قبل ما تبيت 50 محل و 100 user على WhatsApp.**
- ال app يجي لما الـ manual ما يقدرش يكمل، مش قبل.

---

## 🥇 قانون 3: WhatsApp = طبقة التواصل، WASALNI = طبقة الاكتشاف

**يظهر فـ:** كل الـ 9 أبحاث بدون استثناء.

**القاعدة:** فمصر و الـ MENA، WhatsApp مش "feature" — هو الـ **OS للأعمال الصغيرة**. أي تطبيق بيحاول يبني messaging داخله بيموت. النجاح = WhatsApp هو القناة، WASALNI هو الـ discovery layer فوقه.

**أمثلة:**
- **Hatla2ee، OLX Egypt، Dubizzle، Aqarmap** — كلها deep-link لـ WhatsApp، مفيش chat داخلي.
- **MaxAB** بتدير علاقاتها مع المحلات الريفية على WhatsApp.
- **Egyptian Facebook Marketplace** — تواصل كله بيتم خارج فيسبوك، على WhatsApp.

**التطبيق لـ WASALNI:**
- **CTA الرئيسي على كل كرت محل = "تواصل واتساب" (مش "اتصل")** — أكبر من زرار الاتصال.
- WhatsApp deep-link بـ pre-filled message (اسم المحل + استفسار افتراضي).
- **مفيش in-app chat فالـ MVP**. أبداً.
- **عرض رقم الـ WhatsApp مباشرة** (مش "click to reveal" زي Justdial — ده trap).

---

## 🥇 قانون 4: قرية واحدة، شارع واحد، ٥٠ محل

**يظهر فـ:** Lenny Rachitsky، Andrew Chen، Airbnb، DoorDash، Glovo، Justdial

**القاعدة:** الـ "Atomic Network" — أصغر مجموعة بتشتغل بمفردها بدون باقي الشبكة. لو حاولت تكون فـ 5 قرى من اليوم الأول، **هتفشل فالـ 5**. الـ density أهم من الـ coverage.

**أمثلة:**
- **Airbnb** = "10 أماكن فـ NYC".
- **Glovo** = مدينة واحدة لـ 12 شهر قبل التوسع.
- **DoorDash** = حي واحد فـ Palo Alto.
- **Justdial** بدأت بـ Bombay فقط.

**التطبيق لـ WASALNI:**
- **كفر المقدام فقط** لمدة 6-12 شهر.
- داخل كفر المقدام، **شارع تجاري واحد** (الشارع الرئيسي) + **30-50 محل**.
- **مش "كفر المقدام + القرى المجاورة"** فالـ launch — ده فخ.
- لما تثبت إن النموذج بيشتغل فالشارع ده، توسع لشارع تاني فنفس القرية، بعدها قرية مجاورة، إلخ.

---

## 🥇 قانون 5: الـ Free Layer أكبر بكتير من الـ Paid Layer

**يظهر فـ:** Vezeeta، Khatabook، OkCredit، WhatsApp Business، Pinterest، Justdial (الـ MVP)، Vezeeta

**القاعدة:** **مجاني للـ users + مجاني لمعظم الـ supply فالبداية.** الـ monetization بييجي من شريحة صغيرة (≤20%) لما الـ scale يبقى موجود.

**أمثلة:**
- **Vezeeta:** مجاني للمرضى دايماً. الأطباء بيدفعوا transaction fee لما يبقى عندهم demand.
- **Khatabook:** مجاني لكل المحلات. الفلوس بييجي من loans + payments services لاحقاً.
- **WhatsApp Business app:** مجاني تماماً.

**التطبيق لـ WASALNI:**
- **سنة 1 (2026):** **مجاني 100%** لكل الأطراف. صفر اشتراكات. صفر إعلانات.
- **سنة 2 (2027):** إعلانات mid-feed مدفوعة (sponsored placements) + transactional fees لو في معاملات.
- **سنة 3+ (2028+):** اشتراكات للمحلات (لو وصلنا scale يستحق).
- ❌ **لا تطلق أربع شرائح اشتراك من اليوم الأول. ده بيقتل.**

---

## 🥇 قانون 6: Field Team Door-to-Door = الـ Acquisition الوحيد اللي بيشتغل

**يظهر فـ:** Khatabook، Meesho، Jumia (JForce)، MaxAB (mandoubs)، Elmenus (founder personally collected menus)، Vezeeta (early doctors)

**القاعدة:** للأسواق منخفضة-التقنية (rural، tier-3 cities)، **self-signup فالـ Play Store بيفشل**. الـ acquisition الحقيقي = شخص بشري بيقعد جنب صاحب المحل و يساعده يسجّل و يرفع الصور و يفهّمه.

**أمثلة:**
- **Khatabook** = field agents فـ kirana shops.
- **Vezeeta** = الـ founders كانوا بيكلموا الأطباء واحد-واحد.
- **MaxAB** mandoubs بيدخلوا المحلات شخصياً.

**التطبيق لـ WASALNI:**
- التيم الميداني = الـ asset الأساسي. مش الـ app.
- **معدل اقتراح:** agent يسجل 3-5 محلات/يوم. مع agent واحد، تقدر تسجل 50 محل فأول شهر.
- الـ agent ميشتغلش "sales" — يشتغل "مساعد setup": يصور المحل بكاميرته، يسجل بياناتهم، يبني الـ profile كامل.

---

## 🥇 قانون 7: Trust > Technology — استخدم Trust Nodes موجودة بالفعل

**يظهر فـ:** Fawry (البقّال)، M-Pesa (بائعي الرصيد)، Truecaller (دفتر الهاتف)، Khatabook (شوب-تو-شوب word of mouth)

**القاعدة:** الناس فالقرى مش بيثقوا فتطبيقات جديدة. لكنهم بيثقوا فأشخاص محددين — العمدة، الإمام، صاحب أكبر محل، مدرّس البلد. **استخدم الـ trust الموجود، مش حاول تبني trust من الصفر.**

**أمثلة:**
- **Fawry** ربط نفسه بالبقّال — "ادفع عند عم محمود اللي بقى لي 20 سنة بشتري منه".
- **M-Pesa** ربط نفسه ببائعي رصيد الموبايل اللي كانوا موجودين بالفعل.
- **Truecaller** استخدم دفتر الهاتف اللي كل واحد عنده — كل user جديد يثرى التطبيق للباقي.

**التطبيق لـ WASALNI:**
- **اول واحد تكلمه فالقرية = العمدة أو إمام المسجد أو أكبر صاحب محل.** للموافقة، مش للفلوس.
- **استخدم خطبة الجمعة + الـ WhatsApp groups الموجودة** كقنوات تعريف.
- **شارة "موصى به من إمام المسجد"** ممكن تكون أقوى من "موثّق رسمياً".

---

# الجزء 2 — قوانين المنتج (التصميم)

## 🥇 قانون 8: Guest-First Browsing، Auth عند الحاجة فقط

**يظهر فـ:** Pinterest، Instagram، Yelp، Justdial، Google Maps

**القاعدة:** أي حاجة قبل الـ login = friction = هجران. الـ user الريفي بـ الذات بيخاف من النماذج. **خليه يبص و يتفرج، اطلب الـ login بس لما يحاول يعمل حاجة محتاجة حساب** (تحفظ مفضلة، تعمل comment، تسجل محل).

**التطبيق لـ WASALNI:**
- ✅ الـ Feed يتفتح بدون أي شاشة auth.
- ✅ البحث يشتغل بدون auth.
- ✅ صفحة المحل + زرار WhatsApp يشتغلوا بدون auth.
- ⛔ Auth بس عند: "احفظ كمفضلة"، "سجّل محل"، "تواصل من جوّا التطبيق".

> ملحوظة: الـ existing implementation عاملة ده فعلاً فـ Phase 5 — ده قرار صحيح، يفضل.

---

## 🥇 قانون 9: Phone Number > Email (للجمهور الريفي)

**يظهر فـ:** كل بحوث الـ rural emerging markets، Truecaller، WhatsApp، Vodafone Cash

**القاعدة:** فالريف، **رقم التليفون هو الـ ID الفعلي**. الإيميل = نخبة. الـ auth بـ Phone OTP، مش email.

**أمثلة:**
- **WhatsApp** كله Phone-based.
- **Vodafone Cash, InstaPay** Phone-based.
- **Truecaller** قدّس رقم التليفون.

**التطبيق لـ WASALNI:**
- ❌ الـ Email signup الحالي **خطأ استراتيجي**. لازم يتغير.
- ✅ **Phone + OTP** هو الـ default.
- (التكلفة للـ OTP: الـ SMS providers المصرية بيكلفوا ~0.10-0.30 جنيه لكل OTP — مش غالي مقارنة بفقدان نصف الجمهور).

---

## 🥇 قانون 10: Uniform Grid + Map View — مش Pinterest Masonry

**يظهر فـ:** research_04، تجارب Egyptian Facebook Marketplace UX، Justdial mobile

**القاعدة:** الـ Pinterest masonry بيبرز فروق جودة الصور بشكل اجتماعي محرج (المحل اللي صورته أصغر بيبان "أقل"). **Uniform 2-column أحسن للقرية الصغيرة**. زائد **Map view** عشان القرية صغيرة بما يكفي إن الـ map يكون أهم من الـ feed.

**التطبيق لـ WASALNI:**
- ✅ القرار الحالي بـ uniform 2-column **صحيح**. يفضل.
- ➕ **أضف Map view tab** — صور كل محلات القرية على map صغير.
- ➕ صور الكروت **يتم تعديلها auto** (brightness +10%, contrast +5%) عشان الفروق ما تبقاش كبيرة.

---

## 🥇 قانون 11: عامية مصرية، مش فصحى. صور أولاً، نص ثاني.

**يظهر فـ:** Khatabook (13 لهجة هندية)، ShareChat (الـ vernacular دفع 90% من النمو)، WhatsApp، Pinterest icons-first

**القاعدة:** **25.2% من ريف مصر أمي** ([CAPMAS])، بس بيشاهدوا ٧ ساعة فيديو يومياً. ده يعني: **الـ icons + الصور + الـ voice** مهمين أكتر من الـ text. + الـ text لازم يكون **عامية مصرية ريفية**، مش فصحى أكاديمية.

**التطبيق لـ WASALNI:**
- ✅ القرار بـ Cairo font + عامية مصرية فالـ design spec **صحيح**. يفضل.
- ➕ **كل قسم له icon واضح** (أكل = طبق، ملابس = قميص، إلخ) — قبل اسمه النصي.
- ➕ **Voice search** — الـ user يضغط مفتاح و يقول "ابحث عن سباك" بدل ما يكتب.
- ➕ **شارات مرئية لـ "موثّق"، "مفتوح دلوقتي"، "قريب منك"** — صور، مش كلام.

---

## 🥇 قانون 12: محتوى ميزة الـ Discovery = "ايه القريب مني" + "ايه المفتوح دلوقتي" + "ايه الجديد"

**يظهر فـ:** Snap Map، Google Maps، Yelp، Foursquare (نسخته الأولى)، Naver Place

**القاعدة:** **مش algorithmic feed**. مع 50-100 محل، الـ algorithm ميقدرش يشتغل ("starved"). الترتيب الصحيح:
1. **قريب مني** (geographic proximity)
2. **مفتوح دلوقتي** (based on opening hours)
3. **الجديد** (recency)
4. **يدوي - Featured** (الـ admin بيختار كل أسبوع)

**التطبيق لـ WASALNI:**
- **مش "For You" algorithm**. أبداً.
- الـ Feed = `(ABS(distance_meters) ASC, is_open DESC, last_updated DESC)` + featured row فالأعلى.
- **عداد ظاهر:** "كل محلات كفر المقدام (47)" — استخدم الـ scarcity كقوة، مش تخفيها.

---

# الجزء 3 — قوانين الـ Bootstrap (الانطلاق)

## 🥇 قانون 13: ابدأ بـ "Mom Test"، مش بـ "Would you use this?"

**يظهر فـ:** Rob Fitzpatrick، Paul Graham، Lean Startup methodology

**القاعدة:** ❌ "هل هتستخدم تطبيق كده؟" — السؤال ده **بيكذب**. الناس بتقول "آه" عشان مش عايزة تجرحك.
✅ **"آخر مرة احتجت X، عملت ايه؟"** — السؤال ده **بيقول الحقيقة**.

**التطبيق لـ WASALNI — 20 مقابلة قبل أي كود:**
1. "آخر مرة احتجت سباك، عملت ايه؟" → اكتب الإجابات.
2. "آخر مرة دوّرت على محل جديد فالقرية، إزاي لقيته؟" → اكتب.
3. "ايه آخر محل اشتريت منه؟ ليه ده بالذات؟" → اكتب.
4. "ايه آخر مرة اتنصبت أو خدت حاجة سيئة؟" → اكتب.

**القاعدة:** **مفيش سؤال يبدأ بـ "هل ممكن" أو "لو".** كله "آخر مرة".

---

## 🥇 قانون 14: Distribution Insight > Feature Insight

**يظهر فـ:** M-Pesa، Truecaller، WhatsApp، Khatabook، Saavn، JioSaavn

**القاعدة:** المنصات اللي نجحت فالأسواق الناشئة كان عندها **insight ذكي عن إزاي توصل**، مش عن feature معين فالـ product. الـ App Store مش distribution channel فعّال.

**أمثلة:**
- **M-Pesa** = بائعي رصيد الموبايل = شبكة موجودة بالفعل.
- **Truecaller** = دفتر الهاتف = كل user يضيف 3 contacts.
- **Saavn/JioSaavn** = مكافأة بيانات من Jio = توزيع مجاني.
- **Khatabook** = شوب-تو-شوب word of mouth = trust transfer.

**التطبيق لـ WASALNI:**
- **خطبة الجمعة فأكبر مسجد فكفر المقدام** — الإمام بيقول "في تطبيق جديد للقرية".
- **مدرس البلد** يبعت الـ link فجروب أولياء الأمور.
- **شارة QR على كل محل مسجّل** — أي حد يدخل المحل يشوف "شوف الصفحة على وصلني".
- **TikTok فيديو بسيط من القرية** + التاج جغرافي = ممكن viral فالـ neighborhood.

---

## 🥇 قانون 15: Kill Criteria محددة — مش "هنشوف"

**يظهر فـ:** Lenny Rachitsky، Andrew Chen، Sequoia "Failure analysis"، Y Combinator advice

**القاعدة:** قبل ما تبدأ، حدد **بالأرقام** متى تقفل المشروع. **بدون kill criteria، الـ founders بيكملوا على الأمل لـ سنين بعد فوات الأوان.**

**Kill criteria محددة لـ WASALNI (مقترحة من research_07):**
- **أسبوع 4:** أقل من 10 رسائل WhatsApp organic فالـ channel → إعادة تقييم.
- **أسبوع 8:** أقل من 15 محل متعاون → غيّر النهج.
- **أسبوع 12:** أقل من 20% retention للـ users → الـ product مش رد على pain حقيقي.
- **أسبوع 16:** وقت الـ founder مش بيقل (لسه بتعمل كل حاجة manually) → النموذج مش scalable.
- **أكتر من 30,000 جنيه مصاريف + صفر إيراد فعلي:** قفل.

---

# الجزء 4 — قوانين الاحتفاظ (Retention)

## 🥈 قانون 16: قيمة من اليوم الأول، حتى لو الـ network لسه ضعيف

**يظهر فـ:** Pinterest (collections single-player)، Instagram (filters single-player)، Airbnb (wishlists)

**القاعدة:** الـ user الأول لازم يحصل على قيمة حتى لو هو الـ user الوحيد. لو الـ product بيشتغل بس بـ network effects، الـ user الأولين هيشيلوه.

**التطبيق لـ WASALNI:**
- **حفظ كمفضلة** يشتغل من اليوم الأول.
- **بحث** يشتغل حتى بـ 5 محلات فقط.
- **عرض الـ Map** يشتغل لو محل واحد بس.
- **شارة "آخر تحديث منذ X يوم"** = قيمة فردية للـ user.

---

## 🥈 قانون 17: WhatsApp Sharing > Notifications

**يظهر فـ:** WhatsApp viral patterns، Truecaller، Pinterest pin sharing

**القاعدة:** فالقرى، Push Notifications بتتشال أو ما بتترفض. الـ WhatsApp shares بيتم في الجروبات و بتنتشر natively.

**التطبيق لـ WASALNI:**
- **كل صفحة محل** = "شارك على واتساب" زرار واضح.
- الشير يبعت **رسالة جاهزة:** "شوف كل تفاصيل [اسم المحل] على وصلني: [link]".
- **Deep linking** من واتساب يفتح الـ app مباشرة على الصفحة.

---

## 🥉 قانون 18: User-Generated Photos (موضع تجريبي)

**يظهر فـ:** Xiaohongshu (RED) — discovery كله مبني على UGC، Yelp photos

**القاعدة:** صور المستخدمين بتزيد الثقة و الاكتشاف. **بس فالقرى الصغيرة فيه مخاطر:** review wars بين الجيران ممكن تخرّب علاقات اجتماعية.

**التطبيق المحتمل لـ WASALNI — مؤجّل لـ Phase 2:**
- الـ MVP: محتوى من أصحاب المحلات فقط.
- Phase 2: ممكن نفتح للمستخدمين يضيفوا صور بشروط (مش reviews نصية، صور فقط، فلترة مسبقة).

---

# الجزء 5 — قوانين الـ Moat (الحماية من المنافسة)

## 🥇 قانون 19: Ground-Truth Data = الـ Moat ضد Google

**يظهر فـ:** Naver Place (Korea)، Dianping (China)، Justdial (India)

**القاعدة:** Google Maps قوي جداً، **بس مفيش حد عند Google رايح كفر المقدام يصور محل عم سيد**. الـ ground-truth data — الـ verified offline-collected data — هو الشيء الوحيد اللي Google ميقدرش يعمله.

**التطبيق لـ WASALNI:**
- **كل محل = صور حقيقية من field team** (مش owner-uploaded ضعيف).
- **رقم WhatsApp verified** (وكيلنا اتصل به فعلاً).
- **حالة "مفتوح دلوقتي"** مبنية على ساعات حقيقية محدّثة.
- **التحقق:** بطاقة + selfie مع المحل + شهادة من جار/شيخ.

---

## 🥇 قانون 20: Hyperlocal Precision = الـ Moat ضد فيسبوك

**يظهر فـ:** كل الأبحاث

**القاعدة:** Facebook ميقدرش يميّز "محل فكفر المقدام" من "محل فميت غمر" بشكل دقيق. WhatsApp ميقدرش يبحث عبر شوب-تو-شوب. **التميّز بـ "قرية واحدة + قرى مجاورة محددة" هو الفرق الوحيد.**

**التطبيق لـ WASALNI:**
- **Filter دائم على القرية** — مش "all of Egypt" زي OLX.
- **Default toggle:** قريتي / القرى المجاورة / الكل — يبدأ على قريتي.
- **Map مركزه القرية** — مش القاهرة.

---

# 🎯 الخلاصة: قائمة الـ 20 قانون

| # | القانون | فئة |
|---|---|---|
| 1 | ابدأ بالـ demand، مش الـ supply | بناء |
| 2 | Manual / Wizard of Oz أولاً | بناء |
| 3 | WhatsApp = communication، WASALNI = discovery | بناء |
| 4 | قرية واحدة، شارع واحد | بناء |
| 5 | Free Layer كبير، Paid Layer لاحقاً | بناء |
| 6 | Field team door-to-door | بناء |
| 7 | استخدم trust nodes موجودة | بناء |
| 8 | Guest-first browsing | منتج |
| 9 | Phone > Email للريف | منتج |
| 10 | Uniform grid + Map | منتج |
| 11 | عامية + صور أولاً | منتج |
| 12 | قريب + مفتوح + جديد (مش algorithm) | منتج |
| 13 | Mom Test interviews | bootstrap |
| 14 | Distribution insight > feature insight | bootstrap |
| 15 | Kill criteria محددة | bootstrap |
| 16 | قيمة single-player من اليوم الأول | retention |
| 17 | WhatsApp sharing > notifications | retention |
| 18 | UGC photos (مؤجّل) | retention |
| 19 | Ground-truth data ضد Google | moat |
| 20 | Hyperlocal precision ضد Facebook | moat |

---

> الخطوة التالية: راجع [`synthesis_anti_patterns.md`](./synthesis_anti_patterns.md) لقائمة الأخطاء اللي بتقتل التطبيقات المشابهة.
