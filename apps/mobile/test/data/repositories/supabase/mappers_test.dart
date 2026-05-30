import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/order_intent.dart';
import 'package:wasalni/data/repositories/supabase/mappers.dart';

void main() {
  test('villageFromRow maps all fields', () {
    final v = villageFromRow({
      'id': 'v_kafr', 'name': 'كفر المقدام',
      'governorate': 'الدقهلية', 'markaz': 'ميت غمر',
    });
    expect(v.id, 'v_kafr');
    expect(v.name, 'كفر المقدام');
    expect(v.markaz, 'ميت غمر');
  });

  test('categoryFromRow parses kind enum + sort_order', () {
    final c = categoryFromRow({
      'id': 'cat_plumb', 'name': 'سباكة', 'slug': 'plumbing',
      'icon_name': 'plumbing', 'kind': 'service', 'sort_order': 1,
    });
    expect(c.kind, ListingKind.service);
    expect(c.sortOrder, 1);
  });

  test('listingFromRow parses enums, bools, timestamp, null logo', () {
    final l = listingFromRow({
      'id': 'l1', 'kind': 'shop', 'owner_id': 'u4', 'village_id': 'v_kafr',
      'category_id': 'cat_pharm', 'name': 'صيدلية الشفاء', 'bio': 'أدوية',
      'phone_whatsapp': '+201000000004', 'logo_url': null,
      'status': 'active', 'is_verified': true, 'is_featured': true,
      'plan': 'prime', 'is_temporarily_closed': false,
      'created_at': '2026-01-05T00:00:00Z',
    });
    expect(l.kind, ListingKind.shop);
    expect(l.status, ListingStatus.active);
    expect(l.plan, ListingPlan.prime);
    expect(l.isVerified, isTrue);
    expect(l.logoUrl, isNull);
    expect(l.createdAt.year, 2026);
  });

  test('productFromRow parses price as double + availability', () {
    final p = productFromRow({
      'id': 'p1', 'listing_id': 'l4', 'name': 'بنادول', 'description': 'علبة',
      'price_egp': 35, 'image_url': null, 'is_available': false, 'sort_order': 0,
    });
    expect(p.priceEgp, 35.0);
    expect(p.isAvailable, isFalse);
    expect(p.listingId, 'l4');
  });

  test('orderIntentToRow round-trips the fields the table needs', () {
    final intent = OrderIntent(
      id: 'l4-123', shopId: 'l4', shopName: 'صيدلية', shopPhone: '+20100',
      message: 'طلب', totalEgp: 80, itemCount: 2,
      createdAt: DateTime.utc(2026, 1, 5),
    );
    final row = orderIntentToRow(intent, userId: 'u_demo');
    expect(row['id'], 'l4-123');
    expect(row['user_id'], 'u_demo');
    expect(row['shop_id'], 'l4');
    expect(row['total_egp'], 80);
    expect(row['item_count'], 2);
  });
}
