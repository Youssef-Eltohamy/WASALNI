import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/village_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_village_repository.dart';
import 'package:wasalni/features/feed/bloc/feed_bloc.dart';
import 'package:wasalni/features/feed/bloc/feed_event.dart';
import 'package:wasalni/features/feed/view/feed_screen.dart';

void main() {
  testWidgets('FeedScreen renders listings from the mock repo', (tester) async {
    final ListingRepository listingRepo = MockListingRepository(latency: Duration.zero);
    final VillageRepository villageRepo = MockVillageRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => FeedBloc(listingRepo)..add(const FeedRequested(villageId: 'v_kafr')),
          child: FeedScreen(villageRepository: villageRepo),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('سباك الأسطى محمود'), findsOneWidget);
  });
}
