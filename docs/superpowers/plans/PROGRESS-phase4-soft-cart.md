# تقدّم التنفيذ — Phase 4: السلة (Soft Cart)

> **آخر تحديث:** 2026-05-29 (خلصت 100% + مراجعة نهائية)
> **الخطة:** `docs/superpowers/plans/2026-05-29-frontend-phase4-soft-cart.md`
> **الفرع:** `002-rebuild-from-zero`

## النسبة المئوية

**5 / 5 = 100%** ✅

`[█████████████] 100%`

## الحالة

| # | Task | الحالة | Commit |
|---|---|---|---|
| T1 | موديلات السلة (CartLine/ShopCart/Cart/OrderIntent) | ✅ تم | `dab2d56` |
| T2 | CartCubit + DI + provider عام | ✅ تم | `2f631a0` |
| T3 | رسالة الطلب + OrderRepo + OutboxService + CartSender | ✅ تم | `fd807ae` |
| T4 | أزرار "أضف للسلة" + أيقونة السلة بالـ badge | ✅ تم | `77365d3` |
| T5 | شاشة السلة + route + إرسال لكل محل + revalidation + flush | ✅ تم | `3e747a4` |
| — | مراجعة نهائية (opus) + إصلاح ملاحظتين | ✅ تم | `de8823c` |

> **الحالة دلوقتي:** `flutter analyze` نضيف + **72/72 اختبار يعدّي**.

## المراجعة النهائية (APPROVED_WITH_NITS)
- كل متطلبات الـ spec (قسم 12) متحقّقة: سلة لكل محل، شاشة مجمّعة، إرسال لكل محل (بدون bulk)، رسالة واتساب + OrderIntent، revalidation، حالة فاضية، حذف بتأكيد، تعطيل عند غياب الرقم، outbox offline + flush.
- **اتصلّح:** (1) ترتيب كروت المحلات ثابت عند التعديل (مكنش بينط لتحت)، (2) `canSend` بيتطلب صنف متوفر واحد عالأقل (منع إرسال طلب فاضي).

## متابعات مؤجّلة من المراجعة
- **flush الـ outbox بيفتح واتساب من غير لمسة من المستخدم** عند رجوع النت + من غير إشعار — محتاج سطح إشعار/تأكيد (مؤجّل لما نعمل نظام الإشعارات).
- مفيش widget/integration test لمسار offline→queue→flush (مغطّى unit بس في `cart_sender_test`).
- الـ outbox in-memory — بيضيع لو الـ process اتقفل وهو offline (مؤجّل: persistence بـ Hive/Supabase).

## القرارات
- السلة + الـ outbox **in-memory** (مش Hive) في مرحلة الـ mock — يثبت الـ UX من غير مخاطرة codegen. الـ persistence الحقيقي مؤجّل للباك.
- `order_intent` بيتسجّل عبر `MockOrderRepository` (نقطة تبديل لـ Supabase لاحقاً).
- دخول السلة = أيقونة بالـ badge في appbar صفحة المحل + صفحة المنتج → route `/cart`.
- زر الطلب المباشر القديم في صفحة المنتج اتبدّل بـ "أضف للسلة" + عدّاد كمية.

## المتبقّي
- تنفيذ كل الـ 5 tasks subagent-driven (implementer → spec review → code-quality review لكل واحدة).
- مراجعة نهائية شاملة + تحديث النسبة هنا.
