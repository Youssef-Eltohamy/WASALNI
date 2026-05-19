# WASALNI — منصة الاكتشاف المحلي

منصة تربط سكان القرى المصرية بالمحلات والمنتجات والخدمات والحرفيين المحليين.
نقطة الانطلاق: **قرية كفر المقدام** والقرى المجاورة.

> اكتشاف + بحث + وصول + تواصل مباشر + ثقة — وليس متجراً إلكترونياً أو منصة دفع.

---

## هيكل المشروع (Monorepo)

```
wasalni/
├── apps/
│   ├── mobile/        # Flutter app (Android + iOS)
│   └── admin/         # Next.js admin dashboard
├── supabase/
│   ├── migrations/    # SQL schema versions
│   ├── functions/     # Edge functions
│   └── seed.sql       # Initial data
├── docs/
│   └── specs/         # Feature specifications
└── .specify/          # Spec Kit configuration
```

---

## التكنولوجيا

| الطبقة | الاختيار |
|--------|----------|
| Mobile | Flutter |
| Admin Dashboard | Next.js + Tailwind + shadcn/ui |
| Backend | Supabase (PostgreSQL + Auth + Storage) |
| Methodology | Spec-Driven Development (Spec Kit) |
| اللغة | عربي فقط (RTL) |

---

## البدء (Setup)

### المتطلبات
- Flutter SDK
- Node.js v18+
- Git
- Supabase CLI
- حساب Supabase + مشروع متربط

### الخطوات

```powershell
# 1. Clone the repo
git clone https://github.com/Youssef-Eltohamy/WASALNI.git
cd WASALNI

# 2. Copy environment variables
copy .env.example .env
# Edit .env with real Supabase keys

# 3. Mobile app
cd apps\mobile
flutter pub get
flutter run

# 4. Admin dashboard (in another terminal)
cd apps\admin
npm install
npm run dev

# 5. Supabase (link to remote project)
supabase link --project-ref nseuurovkxymrwxamftz
supabase db push
```

---

## النطاق الحالي (MVP — الإصدار 1.0)

✅ تسجيل/تسجيل دخول • تسجيل محل مجاني • التوثيق • صفحة المحل • منتجات بسيطة • Feed • بحث • أقسام ديناميكية • Admin Dashboard

❌ مؤجل: الباقات المدفوعة • الإعلانات • التقييمات • البلاغات (راجع `docs/specs/` للتفاصيل)

---

## منهجية التطوير

نتبع **Spec-Driven Development** عبر [GitHub Spec Kit](https://github.com/github/spec-kit):

```
/specify → /plan → /tasks → /implement
```

كل ميزة تبدأ بـ spec في `docs/specs/NNN-feature-name.md` قبل أي كود.

---

## الترخيص

Proprietary — جميع الحقوق محفوظة.
