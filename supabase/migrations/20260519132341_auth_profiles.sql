-- ============================================================
-- WASALNI - Migration: Authentication Profiles (Spec 001)
-- ============================================================
-- ينشئ:
--   - public.profiles table (بيانات إضافية لـ auth.users)
--   - RLS policies (المستخدم يقرأ/يعدّل بروفايله بس)
--   - avatars storage bucket + RLS policies
--   - updated_at trigger function
-- ============================================================

-- 1) Extensions اللازمة
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 2) Updated-at trigger function (مشتركة بين الجداول)
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- 3) Profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
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

-- 4) Indexes
CREATE INDEX IF NOT EXISTS idx_profiles_phone
  ON public.profiles(phone);
CREATE INDEX IF NOT EXISTS idx_profiles_governorate
  ON public.profiles(governorate);
CREATE INDEX IF NOT EXISTS idx_profiles_full_name_trgm
  ON public.profiles USING gin (full_name gin_trgm_ops);

-- 5) Updated-at trigger
DROP TRIGGER IF EXISTS trg_profiles_updated_at ON public.profiles;
CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

-- 6) Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 7) RLS Policies
DROP POLICY IF EXISTS "Users can read own profile" ON public.profiles;
CREATE POLICY "Users can read own profile"
  ON public.profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- (No DELETE policy → الحذف يتم تلقائياً عبر CASCADE من auth.users)

-- 8) Avatars Storage Bucket
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  true,
  2097152,                                          -- 2 MB
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO UPDATE
  SET public = EXCLUDED.public,
      file_size_limit = EXCLUDED.file_size_limit,
      allowed_mime_types = EXCLUDED.allowed_mime_types;

-- 9) Storage policies (المستخدم يدير ملفاته فقط في folder = id)
DROP POLICY IF EXISTS "Users can upload own avatar" ON storage.objects;
CREATE POLICY "Users can upload own avatar"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Users can update own avatar" ON storage.objects;
CREATE POLICY "Users can update own avatar"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Users can delete own avatar" ON storage.objects;
CREATE POLICY "Users can delete own avatar"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- 10) Comments للتوثيق
COMMENT ON TABLE public.profiles IS
  'بيانات المستخدم الإضافية بعد التسجيل. مرتبط 1:1 مع auth.users';
COMMENT ON COLUMN public.profiles.phone IS
  'موبايل مصري بصيغة +20XXXXXXXXX (شركات 010/011/012/015)';
COMMENT ON COLUMN public.profiles.governorate IS
  'إحدى المحافظات الـ 27 المصرية';
