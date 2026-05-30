import 'package:get_it/get_it.dart';
import '../core/connectivity/connectivity_service.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/village_repository.dart';
import '../data/repositories/mock/mock_auth_repository.dart';
import '../data/repositories/mock/mock_category_repository.dart';
import '../data/repositories/mock/mock_listing_repository.dart';
import '../data/repositories/mock/mock_order_repository.dart';
import '../data/repositories/mock/mock_product_repository.dart';
import '../data/repositories/mock/mock_village_repository.dart';
import '../features/auth/bloc/session_cubit.dart';
import '../features/cart/bloc/cart_cubit.dart';
import '../features/cart/cart_sender.dart';
import '../features/cart/outbox_service.dart';
import '../features/cart/session_cart_coordinator.dart';
import '../features/cart/session_cart_coordinator.dart';

final getIt = GetIt.instance;

/// Registers repositories + services. SWAP POINT: replace the Mock*
/// implementations with Supabase* here when the backend is ready.
void setupDi() {
  getIt
    ..registerLazySingleton<AuthRepository>(MockAuthRepository.new)
    ..registerLazySingleton<ListingRepository>(MockListingRepository.new)
    ..registerLazySingleton<VillageRepository>(MockVillageRepository.new)
    ..registerLazySingleton<CategoryRepository>(MockCategoryRepository.new)
    ..registerLazySingleton<ProductRepository>(MockProductRepository.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityServiceImpl.new)
    ..registerLazySingleton<SessionCubit>(SessionCubit.new)
    ..registerLazySingleton<CartCubit>(CartCubit.new)
    ..registerLazySingleton<OrderRepository>(MockOrderRepository.new)
    ..registerLazySingleton<OutboxService>(() => OutboxService(getIt<OrderRepository>()))
    ..registerLazySingleton<CartSender>(() => CartSender(getIt<OrderRepository>(), getIt<OutboxService>()))
    ..registerLazySingleton<SessionCartCoordinator>(
        () => SessionCartCoordinator(getIt<SessionCubit>(), getIt<CartCubit>()));

  // Bind the cart to the session (merge on sign-in, reset for guest on sign-out).
  getIt<SessionCartCoordinator>().start();
}
