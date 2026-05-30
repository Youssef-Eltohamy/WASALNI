-- ============================================================
-- WASALNI — Seed data (mirrors mock_data.dart). Idempotent.
-- Run after 20260530120000_data_layer.sql.
-- ============================================================

insert into villages (id, name, governorate, markaz) values
  ('v_kafr','كفر المقدام','الدقهلية','ميت غمر'),
  ('v_tahna','تفهنا الأشراف','الدقهلية','أجا')
on conflict (id) do nothing;

insert into categories (id, name, slug, icon_name, kind, sort_order) values
  ('cat_plumb','سباكة','plumbing','plumbing','service',1),
  ('cat_elec','كهرباء','electric','electrical_services','service',2),
  ('cat_carp','نجارة','carpentry','carpenter','service',3),
  ('cat_pharm','صيدلية','pharmacy','local_pharmacy','shop',4),
  ('cat_groc','بقالة','grocery','storefront','shop',5),
  ('cat_tuktuk','توك توك','tuktuk','electric_rickshaw','transport',6)
on conflict (id) do nothing;

insert into profiles (id, phone, display_name, created_at) values
  ('u_demo','+201000000000','أحمد','2026-01-01T00:00:00Z'),
  ('u1','+201000000001','مالك 1','2026-01-01T00:00:00Z'),
  ('u2','+201000000002','مالك 2','2026-01-01T00:00:00Z'),
  ('u3','+201000000003','مالك 3','2026-01-01T00:00:00Z'),
  ('u4','+201000000004','مالك 4','2026-01-01T00:00:00Z'),
  ('u5','+201000000005','مالك 5','2026-01-01T00:00:00Z'),
  ('u6','+201000000006','مالك 6','2026-01-01T00:00:00Z'),
  ('u7','+201000000007','مالك 7','2026-01-01T00:00:00Z'),
  ('u8','+201000000008','مالك 8','2026-01-01T00:00:00Z')
on conflict (id) do nothing;

insert into listings
  (id, kind, owner_id, village_id, category_id, name, bio, phone_whatsapp,
   status, is_verified, is_featured, plan, created_at) values
  ('l1','service','u1','v_kafr','cat_plumb','سباك الأسطى محمود','سباكة وتسليك وتركيب سخانات','+201000000001','active',true,true,'prime','2026-01-02T00:00:00Z'),
  ('l2','service','u2','v_kafr','cat_elec','كهربائي العمدة','تأسيس وصيانة كهرباء المنازل','+201000000002','active',true,false,'free','2026-01-03T00:00:00Z'),
  ('l3','service','u3','v_kafr','cat_carp','نجار الخير','موبيليا وأبواب وشبابيك','+201000000003','active',false,false,'free','2026-01-04T00:00:00Z'),
  ('l4','shop','u4','v_kafr','cat_pharm','صيدلية الشفاء','أدوية ومستلزمات طبية — توصيل متاح','+201000000004','active',true,true,'free','2026-01-05T00:00:00Z'),
  ('l5','shop','u5','v_kafr','cat_groc','بقالة أبو أحمد','كل لوازم البيت','+201000000005','active',false,false,'free','2026-01-06T00:00:00Z'),
  ('l6','transport','u6','v_kafr','cat_tuktuk','توك توك الصاوي','نقل داخل القرية والعزب المجاورة','+201000000006','active',false,false,'free','2026-01-07T00:00:00Z'),
  ('l7','shop','u7','v_tahna','cat_groc','سوبر ماركت تفهنا','بقالة وخضار وفاكهة','+201000000007','active',true,false,'free','2026-01-08T00:00:00Z'),
  ('l8','service','u8','v_tahna','cat_plumb','سباك تفهنا','صيانة سريعة','+201000000008','active',false,false,'free','2026-01-09T00:00:00Z')
on conflict (id) do nothing;

insert into products (id, listing_id, name, description, price_egp, is_available) values
  ('p1','l4','بنادول إكسترا','علبة 24 قرص',35,true),
  ('p2','l4','فوار فيتامين سي','10 أكياس',45,true),
  ('p3','l4','كمامات طبية','علبة 50',30,false),
  ('p4','l5','زيت عافية 1 لتر','زيت دوار الشمس',60,true),
  ('p5','l5','سكر 1 كيلو','سكر أبيض',30,true),
  ('p6','l5','شاي العروسة','علبة 250 جرام',40,true),
  ('p7','l7','أرز مصري 1 كيلو','أرز شعير',35,true)
on conflict (id) do nothing;
