# Data Model: Authentication & Profile

**Spec:** [spec.md](./spec.md) · **Plan:** [plan.md](./plan.md)

---

## نظرة عامة

هذا الـ spec يضيف جدول واحد فقط: `public.profiles`. الـ `auth.users` مدار من Supabase Auth ولا نلمسه. كمان نُنشئ Storage bucket واحد: `avatars`.

---

## 1. الجداول (Tables)

### `public.profiles`

| العمود | النوع | القيود | الوصف |
|--------|------|--------|--------|
| `id` | `uuid` | `PRIMARY KEY, REFERENCES auth.users(id) ON DELETE CASCADE` | نفس الـ id بتاع الـ Auth user |
| `full_name` | `text` | `NOT NULL, CHECK (length(trim(full_name)) >= 3)` | الاسم الكامل (3 حروف +) |
| `phone` | `text` | `NOT NULL, UNIQUE, CHECK (phone ~ '^\+201[0125]\d{8}$')` | موبايل مصري بصيغة `+20XXXXXXXXX` |
| `governorate` | `text` | `NOT NULL, CHECK (governorate IN (...27 الـ governorates))` | المحافظة من القائمة الثابتة |
| `city_or_village` | `text` | `NOT NULL, CHECK (length(trim(city_or_village)) >= 2)` | المدينة/القرية (نص حر) |
| `avatar_url` | `text` | `NULL` | رابط الصورة في Supabase Storage |
| `birth_date` | `date` | `NULL, CHECK (birth_date < CURRENT_DATE AND birth_date > '1920-01-01')` | تاريخ الميلاد (اختياري) |
| `created_at` | `timestamptz` | `NOT NULL DEFAULT now()` | وقت الإنشاء |
| `updated_at` | `timestamptz` | `NOT NULL DEFAULT now()` | وقت آخر تعديل (trigger) |

#### الفهارس (Indexes)

```sql
CREATE INDEX idx_profiles_phone ON public.profiles(phone);
CREATE INDEX idx_profiles_governorate ON public.profiles(governorate);
-- للبحث المستقبلي
CREATE INDEX idx_profiles_full_name_trgm ON public.profiles USING gin (full_name gin_trgm_ops);
```

#### الـ Trigger لتحديث `updated_at`

```sql
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();
```

---

## 2. Row Level Security (RLS)

RLS مفعّلة على الجدول. أربع policies:

### Policy 1: مستخدم يقرأ بروفايله فقط
```sql
CREATE POLICY "Users can read own profile"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);
```

### Policy 2: مستخدم يُنشئ بروفايله فقط (مرة واحدة)
```sql
CREATE POLICY "Users can insert own profile"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);
```

### Policy 3: مستخدم يعدّل بروفايله فقط
```sql
CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);
```

### Policy 4: حذف غير مسموح من العميل
لا policy للـ DELETE → كل محاولة حذف من العميل ستفشل. الحذف فقط عبر cascade من `auth.users` أو من الادمن.

### قراءة عامة للبروفايل (Phase 2)
في Spec 3 (Business Registration)، هنحتاج عرض بيانات صاحب النشاط (اسمه + صورته) في صفحة المحل. هنضيف policy في Spec 3 تسمح بقراءة `full_name + avatar_url` بس بشكل عام، لكن **في هذا الـ spec**: المستخدم يشوف بروفايله فقط.

---

## 3. الـ Trigger لإنشاء بروفايل تلقائياً عند التسجيل

لما يتم تأكيد إيميل المستخدم في `auth.users`، **لا ننشئ profile تلقائياً**. السبب: نريد المستخدم يدخل البيانات الإلزامية بنفسه (الموبايل، المحافظة، القرية).

**الـ flow الفعلي:**
1. User يسجل → row في `auth.users` (بدون email_confirmed_at)
2. User يضغط لينك التأكيد → `email_confirmed_at` يتحدث
3. App يقرأ `profile` فيلاقي مفيش → يوجّه User لشاشة Profile Setup
4. User يكمل البيانات → app يعمل `INSERT INTO profiles`

**هذا الـ flow يضمن:**
- بيانات صحيحة لكل مستخدم (مفيش حسابات بدون موبايل)
- مفيش race conditions

---

## 4. Storage: `avatars` Bucket

### تكوين الـ Bucket

```sql
-- إنشاء الـ bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,  -- public read access
  2097152,  -- 2 MB
  ARRAY['image/jpeg', 'image/png', 'image/webp']
);
```

### Storage Policies

```sql
-- مستخدم يرفع صورة باسم = id بتاعه
CREATE POLICY "Users can upload own avatar"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- مستخدم يحدّث/يستبدل صورته
CREATE POLICY "Users can update own avatar"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- مستخدم يحذف صورته
CREATE POLICY "Users can delete own avatar"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- قراءة عامة (الـ avatars بتظهر في الـ feed)
-- ملحوظة: bucket public:true بيدي قراءة عامة تلقائياً
```

### اصطلاح اسم الملف

```
avatars/{user_id}/avatar.{ext}
مثال: avatars/3f8b2a-7e1c-4b9d/avatar.jpg
```

الـ `{user_id}/` كـ folder بيخلي الـ RLS تقدر تتأكد إن المستخدم بيعدل ملفاته بس.

---

## 5. الـ Migration الكاملة

ملف: `supabase/migrations/20260519XXXXXX_001_auth_profiles.sql`

```sql
-- ============================================================
-- WASALNI - Migration 001: Authentication & Profile
-- ============================================================

-- 1. Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- للبحث الفازي مستقبلاً

-- 2. Updated-at trigger function (مشترك للجداول)
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Profiles table
CREATE TABLE public.profiles (
  id              uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name       text NOT NULL CHECK (length(trim(full_name)) >= 3),
  phone           text NOT NULL UNIQUE CHECK (phone ~ '^\+201[0125]\d{8}$'),
  governorate     text NOT NULL CHECK (governorate IN (
    'القاهرة','الجيزة','الإسكندرية','الدقهلية','الشرقية','المنوفية',
    'القليوبية','الغربية','كفر الشيخ','البحيرة','الإسماعيلية','بورسعيد',
    'السويس','شمال سيناء','جنوب سيناء','دمياط','بني سويف','الفيوم',
    'المنيا','أسيوط','سوهاج','قنا','الأقصر','أسوان',
    'البحر الأحمر','الوادي الجديد','مطروح'
  )),
  city_or_village text NOT NULL CHECK (length(trim(city_or_village)) >= 2),
  avatar_url      text,
  birth_date      date CHECK (birth_date < CURRENT_DATE AND birth_date > '1920-01-01'),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- 4. Indexes
CREATE INDEX idx_profiles_phone ON public.profiles(phone);
CREATE INDEX idx_profiles_governorate ON public.profiles(governorate);
CREATE INDEX idx_profiles_full_name_trgm
  ON public.profiles USING gin (full_name gin_trgm_ops);

-- 5. Updated-at trigger
CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

-- 6. Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 7. RLS Policies
CREATE POLICY "Users can read own profile"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- 8. Avatars Storage Bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,
  2097152,
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- 9. Storage Policies
CREATE POLICY "Users can upload own avatar"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "Users can update own avatar"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

CREATE POLICY "Users can delete own avatar"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- 10. Comment للتوثيق
COMMENT ON TABLE public.profiles IS 'بيانات المستخدم الإضافية بعد التسجيل في auth.users';
COMMENT ON COLUMN public.profiles.phone IS 'موبايل مصري بصيغة +20XXXXXXXXX، unique';
COMMENT ON COLUMN public.profiles.governorate IS 'إحدى المحافظات الـ 27 المصرية';
```

---

## 6. حذف الحسابات غير المؤكدة (Scheduled Function)

لإنفاذ FR-010b (حذف الحسابات بعد 7 أيام بدون تأكيد):

```sql
-- يُضاف في migration منفصل أو في نفس الـ migration
CREATE OR REPLACE FUNCTION public.delete_unconfirmed_accounts()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER  -- يشتغل بصلاحيات owner
AS $$
BEGIN
  DELETE FROM auth.users
  WHERE email_confirmed_at IS NULL
    AND created_at < now() - interval '7 days';
END;
$$;

-- جدولة يومية الساعة 3 صباحاً (cron extension في Supabase)
SELECT cron.schedule(
  'delete-unconfirmed-accounts-daily',
  '0 3 * * *',
  $$ SELECT public.delete_unconfirmed_accounts(); $$
);
```

**ملحوظة:** Supabase pg_cron extension لازم يكون مفعل. نتحقق من ده في Phase A.

---

## 7. ER Diagram (مختصر)

```
┌─────────────────────────────────┐
│  auth.users  (Supabase Auth)    │
│  ─────────                      │
│  id                  uuid PK    │
│  email               text       │
│  encrypted_password  text       │
│  email_confirmed_at  timestamptz│
│  created_at          timestamptz│
└───────────┬─────────────────────┘
            │ 1:1 (ON DELETE CASCADE)
            ↓
┌─────────────────────────────────┐
│  public.profiles                │
│  ─────────                      │
│  id              uuid PK,FK     │
│  full_name       text NOT NULL  │
│  phone           text UNIQUE    │
│  governorate     text (CHECK)   │
│  city_or_village text NOT NULL  │
│  avatar_url      text NULL      │
│  birth_date      date NULL      │
│  created_at      timestamptz    │
│  updated_at      timestamptz    │
└─────────────────────────────────┘
            │
            │ avatar_url يشير إلى:
            ↓
┌─────────────────────────────────┐
│  Storage: avatars bucket        │
│  avatars/{user_id}/avatar.{ext} │
└─────────────────────────────────┘
```

---

## 8. Validation Rules (Summary)

| الحقل | Client (Flutter) | Server (DB constraints) |
|------|------------------|--------------------------|
| `email` | regex + `formz` | Supabase Auth بيتأكد |
| `password` | ≥8، حرف كبير + رقم | Supabase Auth بيتأكد |
| `full_name` | trim, ≥3 حروف | `CHECK length ≥ 3` |
| `phone` | regex لـ مصري | `CHECK regex` |
| `governorate` | dropdown من قائمة | `CHECK IN (27)` |
| `city_or_village` | trim, ≥2 حروف | `CHECK length ≥ 2` |
| `avatar_url` | size ≤2MB, mime type | Storage bucket constraint |
| `birth_date` | <today, >1920 | `CHECK range` |

التحقق client-side **للتجربة فقط**. التحقق server-side **هو المرجع الحقيقي**.
