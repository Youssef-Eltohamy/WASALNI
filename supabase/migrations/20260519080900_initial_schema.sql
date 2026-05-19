-- ============================================================
-- WASALNI - Initial Schema (Placeholder)
-- ============================================================
-- هذا الملف placeholder للـ schema الأساسي.
-- الـ schema الفعلي سيُكتب في إطار Spec 1 (Authentication + Profiles)
-- بعد كتابة المواصفات الكاملة في docs/specs/001-authentication.md
--
-- الجداول المخططة:
--   - public.profiles            (بيانات المستخدم بعد التسجيل)
--   - public.stores              (المحلات)
--   - public.store_verifications (مراجعة التوثيق)
--   - public.categories          (الأقسام الشجرية)
--   - public.products            (المنتجات)
--   - public.admin_users         (حسابات الإدارة)
--
-- Extensions المطلوبة لاحقاً:
--   - uuid-ossp     (لتوليد UUIDs)
--   - pg_trgm       (للبحث الفازي بالعربي)
--   - unaccent      (لإزالة التشكيل في البحث)
--   - pgcrypto      (لتشفير صور التوثيق)
-- ============================================================

-- تفعيل امتداد UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- (المزيد يأتي في Spec 1)
