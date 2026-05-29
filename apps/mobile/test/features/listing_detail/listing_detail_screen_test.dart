import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_bloc.dart';
import 'package:wasalni/features/listing_detail/bloc/listing_detail_event.dart';
import 'package:wasalni/features/listing_detail/view/listing_detail_screen.dart';

void main() {
  testWidgets('ListingDetailScreen shows the listing and a WhatsApp button', (tester) async {
    final ListingRepository repo = MockListingRepository(latency: Duration.zero);

    await tester.pumpWidget(MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => ListingDetailBloc(repo)..add(const ListingDetailRequested('l1')),
          child: const ListingDetailScreen(),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('سباك الأسطى محمود'), findsOneWidget);
    expect(find.text('تواصل واتساب'), findsOneWidget);
  });
}
