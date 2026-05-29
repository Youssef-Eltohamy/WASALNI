import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../../models/village.dart';

/// Realistic seed data for Kafr El-Maqdam & Tahna. Mirrors the schema draft
/// so it can later seed the real DB.
abstract final class MockData {
  static final villages = <Village>[
    Village(id: 'v_kafr', name: 'كفر المقدام', governorate: 'الدقهلية', markaz: 'ميت غمر'),
    Village(id: 'v_tahna', name: 'تفهنا الأشراف', governorate: 'الدقهلية', markaz: 'أجا'),
  ];

  static final categories = <Category>[
    Category(id: 'cat_plumb', name: 'سباكة', slug: 'plumbing', iconName: 'plumbing', kind: ListingKind.service, sortOrder: 1),
    Category(id: 'cat_elec', name: 'كهرباء', slug: 'electric', iconName: 'electrical_services', kind: ListingKind.service, sortOrder: 2),
    Category(id: 'cat_carp', name: 'نجارة', slug: 'carpentry', iconName: 'carpenter', kind: ListingKind.service, sortOrder: 3),
    Category(id: 'cat_pharm', name: 'صيدلية', slug: 'pharmacy', iconName: 'local_pharmacy', kind: ListingKind.shop, sortOrder: 4),
    Category(id: 'cat_groc', name: 'بقالة', slug: 'grocery', iconName: 'storefront', kind: ListingKind.shop, sortOrder: 5),
    Category(id: 'cat_tuktuk', name: 'توك توك', slug: 'tuktuk', iconName: 'electric_rickshaw', kind: ListingKind.transport, sortOrder: 6),
  ];

  static final listings = <Listing>[
    Listing(
      id: 'l1', kind: ListingKind.service, ownerId: 'u1', villageId: 'v_kafr',
      categoryId: 'cat_plumb', name: 'سباك الأسطى محمود', bio: 'سباكة وتسليك وتركيب سخانات',
      phoneWhatsapp: '+201000000001', status: ListingStatus.active, isVerified: true,
      isFeatured: true, plan: ListingPlan.prime, createdAt: DateTime.utc(2026, 1, 2)),
    Listing(
      id: 'l2', kind: ListingKind.service, ownerId: 'u2', villageId: 'v_kafr',
      categoryId: 'cat_elec', name: 'كهربائي العمدة', bio: 'تأسيس وصيانة كهرباء المنازل',
      phoneWhatsapp: '+201000000002', status: ListingStatus.active, isVerified: true,
      createdAt: DateTime.utc(2026, 1, 3)),
    Listing(
      id: 'l3', kind: ListingKind.service, ownerId: 'u3', villageId: 'v_kafr',
      categoryId: 'cat_carp', name: 'نجار الخير', bio: 'موبيليا وأبواب وشبابيك',
      phoneWhatsapp: '+201000000003', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 4)),
    Listing(
      id: 'l4', kind: ListingKind.shop, ownerId: 'u4', villageId: 'v_kafr',
      categoryId: 'cat_pharm', name: 'صيدلية الشفاء', bio: 'أدوية ومستلزمات طبية — توصيل متاح',
      phoneWhatsapp: '+201000000004', status: ListingStatus.active, isVerified: true,
      isFeatured: true, createdAt: DateTime.utc(2026, 1, 5)),
    Listing(
      id: 'l5', kind: ListingKind.shop, ownerId: 'u5', villageId: 'v_kafr',
      categoryId: 'cat_groc', name: 'بقالة أبو أحمد', bio: 'كل لوازم البيت',
      phoneWhatsapp: '+201000000005', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 6)),
    Listing(
      id: 'l6', kind: ListingKind.transport, ownerId: 'u6', villageId: 'v_kafr',
      categoryId: 'cat_tuktuk', name: 'توك توك الصاوي', bio: 'نقل داخل القرية والعزب المجاورة',
      phoneWhatsapp: '+201000000006', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 7)),
    Listing(
      id: 'l7', kind: ListingKind.shop, ownerId: 'u7', villageId: 'v_tahna',
      categoryId: 'cat_groc', name: 'سوبر ماركت تفهنا', bio: 'بقالة وخضار وفاكهة',
      phoneWhatsapp: '+201000000007', status: ListingStatus.active, isVerified: true,
      createdAt: DateTime.utc(2026, 1, 8)),
    Listing(
      id: 'l8', kind: ListingKind.service, ownerId: 'u8', villageId: 'v_tahna',
      categoryId: 'cat_plumb', name: 'سباك تفهنا', bio: 'صيانة سريعة',
      phoneWhatsapp: '+201000000008', status: ListingStatus.active,
      createdAt: DateTime.utc(2026, 1, 9)),
  ];
}
