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
| 8 | **تشغيل الـ SQL على Supabase + تحقّق فعلي** | ✅ **تم (CLI)** |

> **الكود:** `flutter analyze` نضيف + **148 اختبار يعدّي** + الـ web build بيكمبايل. الـ auth لسه mock (`1234`).

## ✅ تشغيل الـ SQL — اتعمل بالـ CLI (2026-05-30)

اتعمل بالـ Supabase CLI. السرد الأمين للخطوات (فيها عقبة اتحلّت):

1. `supabase login --token <token>`.
2. `supabase migration repair --status reverted 20260519132341` — تنظيف migration قديم.
3. `supabase db push` **فشل**: الريموت كان فيه جدول `profiles` قديم بـ `id uuid` (من تجربة سابقة)، فـ `create table if not exists` تخطّاه، وبعدين `listings.owner_id text references profiles(id)` رفض لتعارض النوع (text ضد uuid). الـ push وقف ومفيش جداول اتعملت.
4. **الحل:** الجدول القديم `profiles` كان **فاضي (0 صفوف)** فاتمسح (`drop table profiles cascade`)، وبعدين طبّقنا السكيمة + الـ seed **مباشرة** بـ `supabase db query --linked` (الطريقة اللي الـ skill بينصح بيها لتطبيق الschema).
5. الـ seed اتعمل كمان كـ migration للسجل: `supabase/migrations/20260530143052_seed_data.sql` (نسخة من `seed.sql`، idempotent). واتعمل `migration repair --status applied` للاتنين عشان `migration list` يطابق الواقع (Local = Remote للكل).

**التحقّق الفعلي (عبر anon REST — نفس اللي التطبيق يستخدمه):**
- القراءة: villages=2، categories=6، listings=8، products=7، profiles=9 ✅ (anon قرأ listings كفر فعلاً)
- كتابة الطلبات: anon قدر يعمل insert في `order_intents` (HTTP 201) ✅ — اتمسحت صفوف الاختبار بعدها (`order_intents=0`).

> **ملاحظة أمان:** الـ access token اللي اتستخدم ظهر في المحادثة — يُفضّل عمل **revoke** له من https://supabase.com/dashboard/account/tokens وإنشاء واحد جديد.

## المتبقّي — تجربة يدوية اختيارية (المالك)

جرّب الأب على الداتا الحقيقية لما يكون فيه وقت:
```
flutter build web --no-tree-shake-icons
py -3 serve_web.py    # → http://127.0.0.1:8080
```
- الـ feed يعرض محلات كفر المقدام (الموثّق/المميّز الأول)، فلتر القرية يبدّل لتفهنا.
- التصنيفات 6. صيدلية الشفاء تعرض 3 منتجات (الكمامات unavailable). بحث "سباك" يرجّع السباكين.
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
