import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';

Listing _build() => Listing(
      id: 'l1',
      kind: ListingKind.service,
      ownerId: 'u1',
      villageId: 'v1',
      categoryId: 'c1',
      name: 'سباك الحرفية',
      bio: 'سباكة وتسليك مجاري',
      phoneWhatsapp: '+201000000001',
      status: ListingStatus.active,
      isVerified: true,
      plan: ListingPlan.free,
      createdAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  test('Listing has value equality and copyWith preserves other fields', () {
    final a = _build();
    final b = _build();
    expect(a, b); // freezed value equality

    final c = a.copyWith(isVerified: false);
    expect(c.isVerified, false);
    expect(c.name, 'سباك الحرفية');
    expect(c, isNot(a));
    expect(a.kind, ListingKind.service);
  });
}
