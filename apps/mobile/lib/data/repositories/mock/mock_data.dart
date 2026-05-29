import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../../models/product.dart';
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

  static final products = <Product>[
    // صيدلية الشفاء (l4)
    Product(id: 'p1', listingId: 'l4', name: 'بنادول إكسترا', description: 'علبة 24 قرص', priceEgp: 35),
    Product(id: 'p2', listingId: 'l4', name: 'فوار فيتامين سي', description: '10 أكياس', priceEgp: 45),
    Product(id: 'p3', listingId: 'l4', name: 'كمامات طبية', description: 'علبة 50', priceEgp: 30, isAvailable: false),
    // بقالة أبو أحمد (l5)
    Product(id: 'p4', listingId: 'l5', name: 'زيت عافية 1 لتر', description: 'زيت دوار الشمس', priceEgp: 60),
    Product(id: 'p5', listingId: 'l5', name: 'سكر 1 كيلو', description: 'سكر أبيض', priceEgp: 30),
    Product(id: 'p6', listingId: 'l5', name: 'شاي العروسة', description: 'علبة 250 جرام', priceEgp: 40),
    // سوبر ماركت تفهنا (l7)
    Product(id: 'p7', listingId: 'l7', name: 'أرز مصري 1 كيلو', description: 'أرز شعير', priceEgp: 35),
  ];
}
