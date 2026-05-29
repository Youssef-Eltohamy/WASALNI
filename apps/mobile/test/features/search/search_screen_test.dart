import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/village_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_village_repository.dart';
import 'package:wasalni/features/search/bloc/search_bloc.dart';
import 'package:wasalni/features/search/view/search_screen.dart';

void main() {
  testWidgets('SearchScreen shows results as the user types', (tester) async {
    final ListingRepository listingRepo = MockListingRepository(latency: Duration.zero);
    final VillageRepository villageRepo = MockVillageRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => SearchBloc(listingRepo),
          child: SearchScreen(villageRepository: villageRepo),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'سباك');
    await tester.pumpAndSettle();

    expect(find.text('سباك الأسطى محمود'), findsOneWidget);
  });
}
