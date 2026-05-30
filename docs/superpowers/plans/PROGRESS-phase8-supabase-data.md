# تقدّم التنفيذ — Phase 8: Supabase Data Layer (قراءة + طلبات)

> **آخر تحديث:** 2026-05-30
> **الخطة:** `docs/superpowers/plans/2026-05-30-supabase-data-layer.md`
> **الـ spec:** `docs/superpowers/specs/2026-05-30-supabase-data-layer-design.md`
> **الفرع:** `002-rebuild-from-zero` — الأساس قبل الـ phase: `74aed8c`

## الحالة

| # | Task | الحالة |
|---|---|---|
| 1 | SQL migration (6 جداول + فهارس + RLS) | ✅ مكتوب (`supabase/migrations/20260530120000_data_layer.sql`) |
| 2 | Seed (نفس بيانات mock_data) | ✅ مكتوب (`supabase/seed.sql`) |
| 3 | Supabase client init من `.env` + main() | ✅ تم |
| 4 | Mappers (row↔model) + tests | ✅ تم |
| 5 | repos: village + category + product | ✅ تم |
| 6 | repo: listing (feed/search/getById) | ✅ تم |
| 7 | repo: order + تبديل DI لـ Supabase | ✅ تم |
| review | مراجعة + إصلاح (web-safe errors, search sanitize, price parse) | ✅ تم |
| 8 | **تشغيل الـ SQL يدويًا + تجربة فعلية** | ⏳ **مطلوب من المالك** |

> **الكود:** `flutter analyze` نضيف + **148 اختبار يعدّي** + الـ web build بيكمبايل. الـ auth لسه mock (`1234`).

## ⏳ المتبقّي — خطوات يدوية (المالك) — Task 8

الـ subagents/الكود مايقدروش يشغّلوا SQL على Supabase (مفيش وصول للـ DB). لازم المالك يعمل:

1. **افتح** Supabase Dashboard → المشروع `nseuurovkxymrwxamftz` → **SQL Editor**.
2. **انسخ والصق وشغّل** محتوى `supabase/migrations/20260530120000_data_layer.sql` (مرة واحدة).
3. **انسخ والصق وشغّل** محتوى `supabase/seed.sql`.
4. **اتأكد** في Table Editor: `listings`=8 صفوف، `products`=7، `categories`=6، `villages`=2، `profiles`=9.
5. **جرّب الأب** (web): `flutter build web --no-tree-shake-icons` ثم `py -3 serve_web.py` → `http://127.0.0.1:8080`:
   - الـ feed يعرض محلات كفر المقدام (الموثّق/المميّز الأول)، فلتر القرية يبدّل لتفهنا.
   - التصنيفات 6.
   - صيدلية الشفاء تعرض 3 منتجات (الكمامات unavailable).
   - بحث "سباك" يرجّع السباكين.
   - أضف منتج للسلة → ابعت الطلب → صف جديد يظهر في `order_intents`.

## القرارات المنفّذة

- جدول `listings` موحّد بـ `kind` + `attributes jsonb` (قرار docx).
- IDs نصية (`v_kafr`, `l1`, `u_demo`…) تطابق الـ seed والكود.
- الطلبات بتتكتب بـ `user_id = u_demo` (حساب seed) — RLS مؤقتة بتسمح insert للـ anon.
- القراءة عامة (RLS select للكل) على الكتالوج + profiles.

## متابعات مؤجّلة (tech-debt صريح)

- **RLS الطلبات مؤقتة:** `insert with check (true)` للـ anon — تتشدّد لـ `auth.uid()::text = user_id` لما الـ auth الحقيقي يدخل.
- الـ auth لسه mock (`1234`) — راجع `docs/superpowers/AUTH-DEV-OTP.md`.
- الجداول الـ6 الباقية (توثيق مشفّر، مفضلة، صور، أدمن، audit, settings) مؤجّلة.
- مفيش live-DB integration tests في CI (هشّة)؛ التحقق يدوي عبر الـ web preview.
