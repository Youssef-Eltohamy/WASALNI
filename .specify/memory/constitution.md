# دستور مشروع WASALNI

> القواعد الثابتة التي يجب أن يلتزم بها كل feature وكل قرار تقني.

---

## Core Principles (المبادئ الأساسية)

### I. العربية أولاً والـ RTL غير قابل للتفاوض
- كل واجهة مستخدم بالعربية فقط (مفيش toggle للإنجليزية في الـ MVP).
- اتجاه الكتابة من اليمين إلى اليسار (RTL) في كل المكونات.
- خط Cairo (أو ما يكافئه) معتمد كخط افتراضي.
- التواريخ والأرقام: تُعرض بالأرقام العربية الشرقية أو الغربية (يُحدد لاحقاً)، لكن **متسق** في كل التطبيق.
- النصوص الإنجليزية تُسمح فقط في: أسماء الملفات، الكود، البيانات التقنية، والـ logs.

### II. Spec-Driven Development (NON-NEGOTIABLE)
- لا يُكتب كود قبل وجود spec موافَق عليها.
- التسلسل: `/speckit-specify` → `/speckit-plan` → `/speckit-tasks` → `/speckit-implement`.
- الـ specs تُحفظ في `docs/specs/NNN-feature-name.md` مرقّمة.
- أي تغيير في الـ scope بعد بدء التنفيذ → يُحدّث الـ spec أولاً.

### III. Supabase هو المصدر الوحيد للحقيقة (Schema)
- كل تغيير في DB schema يمر عبر migration في `supabase/migrations/`.
- لا يُسمح بتعديل schema يدوياً من Supabase Dashboard في الـ production.
- Types مولّدة من DB باستخدام `supabase gen types` (لا تُكتب يدوياً في الموبايل أو الأدمن).
- Row Level Security (RLS) مفعّلة على **كل جدول** بدون استثناء.

### IV. الخصوصية والأمان (لصور التوثيق خصوصاً)
- صور البطاقات الشخصية تُشفّر في الـ Storage (encrypted bucket).
- بعد قبول/رفض التوثيق من الأدمن، **تُحذف الصور تلقائياً** خلال 30 يوم max.
- لا تظهر صور البطاقة في أي API response خارج الـ admin dashboard.
- `service_role` key محظور تماماً في الموبايل أو أي client-side code.
- المتغيرات السرية (.env) ممنوع رفعها على Git.

### V. البساطة والتركيز على القيمة (YAGNI)
- لا نبني features لـ "احتياج محتمل في المستقبل".
- الـ MVP محدد ومتفق عليه — لا تُضاف ميزات خارج النطاق بدون موافقة.
- الكود يحل المشكلة الحالية فقط، بدون abstractions مفرطة.
- ثلاث أسطر متشابهة أفضل من abstraction سابق لأوانه.

---

## التكنولوجيا المعتمدة (Tech Constraints)

| الطبقة | الاختيار | لا يُستبدل بدون |
|--------|----------|------------------|
| Mobile | Flutter (Dart) | spec rewrite كامل |
| Admin | Next.js + Tailwind + shadcn/ui | spec rewrite كامل |
| Backend / DB | Supabase (PostgreSQL) | spec rewrite كامل |
| Auth | Supabase Auth | spec rewrite |
| Storage | Supabase Storage | spec rewrite |
| Search | PostgreSQL Full-Text Search + pg_trgm | يمكن استبداله بـ Algolia إذا فشل الأداء |

### Naming Conventions
- **Files & Folders:** `kebab-case` (مثلاً `store-registration.dart`).
- **Dart classes:** `PascalCase`.
- **Dart variables/functions:** `camelCase`.
- **TypeScript / React:** نفس قواعد Dart (PascalCase للـ components، camelCase للباقي).
- **PostgreSQL tables:** `snake_case` بالجمع (مثلاً `stores`, `store_verifications`).
- **PostgreSQL columns:** `snake_case` بالمفرد (مثلاً `owner_id`, `created_at`).
- **Migrations:** `YYYYMMDDHHMMSS_short_description.sql` (يولدها Supabase CLI).

### State Management في Flutter
- **مؤجل:** سيُحدد في Spec 1 (Authentication). الخيارات المرشحة: Riverpod أو Bloc.
- بعد الاختيار، يصبح ملزماً لكل التطبيق.

---

## نطاق MVP (مرجع سريع)

✅ **داخل:** Auth، تسجيل محل مجاني، توثيق، صفحة محل، منتجات بسيطة، Feed، بحث، أقسام، Admin Dashboard مبسطة.

❌ **مؤجل:** الباقات المدفوعة، الإعلانات، التقييمات، البلاغات، بروفايلات الحرفيين، Posts، العروض، الإحصائيات، Push Notifications.

أي feature خارج هذه القائمة → يُرفض حتى يُوافَق على ترحيلها للـ MVP صراحةً.

---

## Development Workflow

### قبل كتابة أي كود
1. اكتب الـ spec في `docs/specs/`.
2. راجعها مع المستخدم (المالك).
3. شغّل `/speckit-plan` للخطة التقنية.
4. شغّل `/speckit-tasks` لتقسيمها.

### أثناء التنفيذ
- كل feature في branch منفصل من `main`.
- اسم الـ branch: `feat/NNN-short-name` (مثلاً `feat/001-authentication`).
- Commits بصيغة Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`.
- الـ commits بالإنجليزية (سهولة قراءة `git log`).

### قبل الـ merge على main
- [ ] `flutter analyze` بدون warnings (للموبايل).
- [ ] `npm run build` ينجح (للأدمن).
- [ ] الـ migrations مرتبة ومُختبرة على Supabase preview branch (لو متاح).
- [ ] الـ spec محدّث لو حصل تغيير في القرارات.

---

## Governance

- هذا الدستور **يعلو على أي قرار تكتيكي**. لو الـ spec بتقول حاجة وهو بيقول حاجة تانية، الدستور يفوز.
- التعديل على الدستور يحتاج: (1) سبب موثّق، (2) موافقة المالك (Youssef Eltohamy)، (3) تحديث رقم النسخة.
- Reviews لكل PR يجب أن تتحقق من الالتزام بالدستور.

---

**النسخة:** 1.0.0
**تاريخ الإنشاء:** 2026-05-19
**آخر تعديل:** 2026-05-19
**المالك:** Youssef Eltohamy
