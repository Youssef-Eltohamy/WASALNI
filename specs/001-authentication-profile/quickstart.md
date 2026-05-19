# Quickstart: Authentication & Profile

**Spec:** [spec.md](./spec.md) · **Plan:** [plan.md](./plan.md)

---

# دليل الاختبار اليدوي

هذا الملف يحتوي على **خطة اختبار End-to-End** يدوية للتحقق من إن كل user stories من الـ spec شغّالة بشكل صحيح. كل قسم بياخد ~5 دقائق.

> 🎯 الهدف: نقدر نعمل هذه الاختبارات على جهاز حقيقي (أو emulator) وكلها تنجح قبل ما نقول "الـ feature خلصت".

---

## Setup قبل البدء

### 1. تأكد إن Supabase شغّال

```powershell
# في root المشروع
supabase status
# لازم تظهر: API URL, anon key, etc.
```

### 2. طبّق الـ Migration

```powershell
supabase db push
# تأكد إن migration 001_auth_profiles طبقت
```

### 3. تحقق من Supabase Dashboard

افتح https://supabase.com/dashboard/project/nseuurovkxymrwxamftz/

- ✅ Tables → `public.profiles` موجود
- ✅ Storage → `avatars` bucket موجود (public)
- ✅ Authentication → Email auth مفعّل
- ✅ Authentication → Redirect URLs فيها `wasalni://auth/confirm` و `wasalni://auth/reset-password`

### 4. شغّل التطبيق

```powershell
cd apps\mobile
flutter run
```

---

## ✅ Test 1: User Story 1 — تصفح كـ Guest (P1)

**الهدف:** التأكد إن المستخدم يقدر يدخل التطبيق ويتصفح بدون حساب.

| الخطوة | المتوقع |
|--------|----------|
| 1. افتح التطبيق لأول مرة | شاشة Splash تظهر <2 ثانية |
| 2. انتظر انتهاء الـ Splash | الـ Feed يفتح مباشرة (مفيش signin screen) |
| 3. تصفح في الـ Feed (لو فيه محتوى) | يقدر يفتح صفحات بحرية |
| 4. اضغط أيقونة البحث | شاشة البحث تفتح، يقدر يبحث |
| 5. اضغط على "تسجيل نشاط" أو "تواصل" (لو متاح) | يظهر modal "تحتاج تسجيل دخول" مع زرين |

**✅ Pass criteria:** خطوات 1-5 كلها تنجح بدون errors.

---

## ✅ Test 2: User Story 2 — Signup (P1)

**الهدف:** التحقق من مسار إنشاء حساب كامل من Signup → Profile Setup → Feed.

| الخطوة | المتوقع |
|--------|----------|
| 1. في الـ Feed (Guest)، اضغط على action محتاج auth | يظهر modal "تحتاج تسجيل دخول" |
| 2. اضغط "إنشاء حساب جديد" | شاشة Signup تفتح |
| 3. أدخل إيميل: `test+1@example.com` | لا errors |
| 4. أدخل كلمة سر: `Test1234` | لا errors |
| 5. اترك checkbox الموافقة على الشروط فاضي، اضغط "سجل" | الزر معطّل، أو رسالة "وافق على الشروط" |
| 6. شغّل checkbox، اضغط "سجل" | يظهر Loading، ثم شاشة "تأكيد الإيميل" |
| 7. افتح الإيميل (في Supabase Dashboard → Auth → Users → اضغط على المستخدم → ابحث عن email_change_token_new) أو في الإيميل الفعلي | يوجد إيميل من Supabase |
| 8. اضغط على لينك التأكيد | App يفتح، ينتقل لشاشة Profile Setup |
| 9. اترك حقل الاسم فاضي، اضغط "احفظ" | error: "الاسم مطلوب" |
| 10. أدخل: الاسم "يوسف التهامي"، الموبايل "01012345678" | الموبايل يتحول لـ `+201012345678` تلقائياً |
| 11. اختار المحافظة من القائمة | dropdown يعرض الـ 27 محافظة، تختار "الدقهلية" |
| 12. أدخل القرية: "كفر المقدام" | لا errors |
| 13. اضغط "احفظ" | Loading، ثم انتقال لـ Feed كمستخدم مسجل |
| 14. اضغط على أيقونة الحساب | شاشة "حسابي" تظهر بياناتك |

**✅ Pass criteria:** خطوات 1-14 كلها تنجح. row في `auth.users` و `public.profiles` يتم إنشاؤه.

### تحقق في Supabase

افتح Dashboard → Table Editor → `public.profiles` → لازم تشوف row جديد بإيميل `test+1@example.com`.

---

## ✅ Test 3: User Story 3 — Signin (P1)

**الهدف:** التحقق من تسجيل دخول مستخدم موجود.

### Setup
استخدم نفس الحساب من Test 2.

| الخطوة | المتوقع |
|--------|----------|
| 1. في "حسابي"، اضغط "تسجيل خروج" | تظهر confirmation dialog |
| 2. أكد الخروج | تعود لـ Feed كـ Guest |
| 3. اضغط على action محتاج auth → "تسجيل دخول" | شاشة Signin تفتح |
| 4. أدخل إيميل خطأ: `wrong@example.com` + باسورد `Test1234` | error: "بيانات الدخول غير صحيحة" |
| 5. أدخل الإيميل الصح + باسورد خطأ | نفس الـ error (مش بنكشف هل الإيميل أو الباسورد) |
| 6. أدخل البيانات الصحيحة | Loading، ثم Feed كمستخدم مسجل |
| 7. اقفل التطبيق وافتحه تاني | يفتح مباشرة (الـ session 30 يوم) |

**✅ Pass criteria:** خطوات 1-7 كلها تنجح.

---

## ✅ Test 4: User Story 4 — Reset Password (P2)

**الهدف:** التحقق من مسار استعادة كلمة السر.

| الخطوة | المتوقع |
|--------|----------|
| 1. سجل خروج | Feed كـ Guest |
| 2. افتح Signin | الشاشة تظهر |
| 3. اضغط "نسيت كلمة السر؟" | شاشة Forgot Password تفتح |
| 4. أدخل إيميل غير مسجل: `nonexistent@example.com` | رسالة "تم الإرسال" (security: مش بنكشف) |
| 5. أدخل الإيميل المسجل (من Test 2) | نفس رسالة "تم الإرسال" |
| 6. افتح الإيميل، اضغط على Reset link | App يفتح، شاشة "كلمة سر جديدة" |
| 7. أدخل كلمة سر جديدة `NewPass123` | حفظ، ثم انتقال للـ Feed |
| 8. سجل خروج، حاول الدخول بالكلمة القديمة `Test1234` | error |
| 9. الدخول بالكلمة الجديدة `NewPass123` | نجاح |

**✅ Pass criteria:** الكلمة القديمة لم تعد صالحة، الجديدة شغّالة.

---

## ✅ Test 5: User Story 5 — Signout (P2)

**الهدف:** التأكد إن تسجيل الخروج يمسح الـ session تماماً.

| الخطوة | المتوقع |
|--------|----------|
| 1. سجل دخول | Feed كمستخدم |
| 2. شاشة "حسابي" → "تسجيل خروج" → "تأكيد" | Feed كـ Guest |
| 3. اقفل التطبيق وافتحه تاني | يفتح كـ Guest (لا session) |
| 4. تحقق من `flutter_secure_storage` (لو متاح) | مفيش refresh token محفوظ |

**✅ Pass criteria:** بعد signout مفيش session، حتى بعد إعادة فتح التطبيق.

---

## ✅ Test 6: User Story 6 — Edit Profile (P3)

**الهدف:** التحقق من قدرة المستخدم على تعديل بياناته.

| الخطوة | المتوقع |
|--------|----------|
| 1. مستخدم مسجل → "حسابي" → "تعديل البروفايل" | شاشة EditProfile مع البيانات الحالية |
| 2. غير الاسم لـ "يوسف الجديد" | يظهر الاسم الجديد في الـ form |
| 3. اضغط "احفظ" | Loading، ثم "تم الحفظ"، رجوع لـ "حسابي" |
| 4. الاسم في "حسابي" بقى "يوسف الجديد" | ✅ |
| 5. رفع صورة شخصية كبيرة (5MB+) | يتم ضغطها تلقائياً، رفع ناجح |
| 6. الصورة تظهر في الـ avatar | ✅ |

**✅ Pass criteria:** التغييرات تظهر فوراً، الصورة الكبيرة تتضغط.

---

## ✅ Test 7: Edge Cases

### 7a. لا اتصال بالإنترنت

| الخطوة | المتوقع |
|--------|----------|
| 1. أغلق Wi-Fi و Mobile Data | لا اتصال |
| 2. حاول signup | error واضح: "تحقق من اتصالك بالإنترنت" |
| 3. شغّل النت تاني | تقدر تسجل عادي |

### 7b. Rate Limiting

| الخطوة | المتوقع |
|--------|----------|
| 1. حاول signin بباسورد خطأ 5 مرات متتالية | بعد المحاولة 5: "محاولات كتيرة، انتظر 60 ثانية" |
| 2. انتظر 60 ثانية وحاول تاني | يشتغل |

### 7c. الـ Banner لـ Email غير المؤكد

| الخطوة | المتوقع |
|--------|----------|
| 1. سجل حساب جديد لكن **متضغطش** على لينك التأكيد | في الـ Feed، Banner أحمر بسيط في الأعلى |
| 2. اقرأ الـ Banner | "أكّد إيميلك خلال X أيام قبل حذف الحساب" |
| 3. اضغط "إعادة إرسال" | إيميل تأني يوصل |
| 4. اضغط على لينك التأكيد | Banner يختفي |

### 7d. حذف الحساب غير المؤكد بعد 7 أيام

ده اختبار طويل المدى. للاختبار:
1. غيّر الـ scheduled function مؤقتاً لتعمل بعد ساعة بدل 7 أيام.
2. سجل حساب، انتظر ساعة، تحقق إنه اتحذف.
3. ارجع الـ schedule لـ 7 أيام.

---

## ✅ Test 8: RLS Verification

**الهدف:** التأكد إن المستخدم مش بيقدر يقرأ بروفايلات الآخرين.

### في Supabase SQL Editor:

```sql
-- اعمل user A و user B (يدوياً أو عبر التطبيق)
-- ثم بصلاحيات user A:
SELECT set_config('request.jwt.claims', '{"sub":"USER_A_ID","role":"authenticated"}', true);

-- جرب تقرأ بروفايل user B
SELECT * FROM public.profiles WHERE id = 'USER_B_ID';
-- المتوقع: 0 rows (RLS بيمنع)

-- جرب تعدّل بروفايل user B
UPDATE public.profiles SET full_name = 'hacked' WHERE id = 'USER_B_ID';
-- المتوقع: 0 rows affected
```

**✅ Pass criteria:** User A مايقدرش يشوف أو يعدّل بروفايل User B.

---

## ✅ Test 9: Performance

| المقياس | الـ Target | كيفية الاختبار |
|---------|-----------|------------------|
| Splash time | <2s | شغّل التطبيق ولاحظ |
| Signin response | <2s على Wi-Fi | استخدم stopwatch |
| Profile setup save | <3s | يشمل INSERT + redirect |
| Avatar upload (5MB original) | <5s | الضغط + الرفع |

---

## النتيجة النهائية

| الاختبار | حالة |
|----------|------|
| Test 1: Guest browsing | ⬜ |
| Test 2: Signup full flow | ⬜ |
| Test 3: Signin | ⬜ |
| Test 4: Reset password | ⬜ |
| Test 5: Signout | ⬜ |
| Test 6: Edit profile | ⬜ |
| Test 7a: No internet | ⬜ |
| Test 7b: Rate limiting | ⬜ |
| Test 7c: Email confirmation banner | ⬜ |
| Test 7d: Auto-delete unconfirmed (طويل المدى) | ⬜ |
| Test 8: RLS verification | ⬜ |
| Test 9: Performance | ⬜ |

✅ كل الاختبارات تنجح → **Spec 1 مكتمل وجاهز للنشر**.
