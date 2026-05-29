import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/enums.dart';
import 'package:wasalni/data/models/listing.dart';
import 'package:wasalni/features/feed/widgets/listing_card.dart';

Listing _verified() => Listing(
      id: 'l1', kind: ListingKind.service, ownerId: 'o', villageId: 'v', categoryId: 'c',
      name: 'سباك الأسطى', bio: 'وصف', phoneWhatsapp: '+201000000000',
      isVerified: true, createdAt: DateTime.utc(2026, 1, 1));

void main() {
  testWidgets('ListingCard shows name and verified badge', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: ListingCard(listing: _verified(), onTap: () {})),
      ),
    ));
    expect(find.text('سباك الأسطى'), findsOneWidget);
    expect(find.byIcon(Icons.verified), findsOneWidget);
  });
}
