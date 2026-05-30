import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/app/app.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/core/connectivity/connectivity_service.dart';
import 'package:wasalni/data/repositories/category_repository.dart';
import 'package:wasalni/data/repositories/listing_repository.dart';
import 'package:wasalni/data/repositories/order_repository.dart';
import 'package:wasalni/data/repositories/product_repository.dart';
import 'package:wasalni/data/repositories/village_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_category_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_listing_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_order_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_product_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_village_repository.dart';

// Widget tests have no platform plugins, so override connectivity with a fake.
class _FakeConn implements ConnectivityService {
  @override
  Stream<bool> get onStatusChange => Stream<bool>.empty();
  @override
  Future<bool> isOnline() async => true;
}

void main() {
  setUp(() async {
    await getIt.reset();
    setupDi();
    // Swap Supabase repos with mocks so the widget test runs without a real
    // Supabase instance (Supabase.initialize is not called in tests).
    getIt.unregister<ListingRepository>();
    getIt.unregister<VillageRepository>();
    getIt.unregister<CategoryRepository>();
    getIt.unregister<ProductRepository>();
    getIt.unregister<OrderRepository>();
    getIt.registerLazySingleton<ListingRepository>(MockListingRepository.new);
    getIt.registerLazySingleton<VillageRepository>(MockVillageRepository.new);
    getIt.registerLazySingleton<CategoryRepository>(MockCategoryRepository.new);
    getIt.registerLazySingleton<ProductRepository>(MockProductRepository.new);
    getIt.registerLazySingleton<OrderRepository>(MockOrderRepository.new);
    getIt.unregister<ConnectivityService>();
    getIt.registerLazySingleton<ConnectivityService>(_FakeConn.new);
  });

  testWidgets('App boots, shows RTL home, and switches tabs', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('وصلني'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('حسابي'));
    await tester.pumpAndSettle();
    // AccountScreen: guest state shows the sign-in prompt
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
