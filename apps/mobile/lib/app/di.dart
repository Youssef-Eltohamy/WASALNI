import 'package:get_it/get_it.dart';
import '../core/connectivity/connectivity_service.dart';
import '../core/supabase/supabase_init.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/village_repository.dart';
import '../data/repositories/mock/mock_auth_repository.dart';
import '../data/repositories/supabase/supabase_category_repository.dart';
import '../data/repositories/supabase/supabase_listing_repository.dart';
import '../data/repositories/supabase/supabase_order_repository.dart';
import '../data/repositories/supabase/supabase_product_repository.dart';
import '../data/repositories/supabase/supabase_village_repository.dart';
import '../features/auth/bloc/session_cubit.dart';
import '../features/cart/bloc/cart_cubit.dart';
import '../features/cart/cart_sender.dart';
import '../features/cart/outbox_service.dart';
import '../features/cart/session_cart_coordinator.dart';

final getIt = GetIt.instance;

/// Registers repositories + services. SWAP POINT: replace the Mock*
/// implementations with Supabase* here when the backend is ready.
void setupDi() {
  getIt
    ..registerLazySingleton<AuthRepository>(MockAuthRepository.new)
    ..registerLazySingleton<ListingRepository>(() => SupabaseListingRepository(supabaseClient))
    ..registerLazySingleton<VillageRepository>(() => SupabaseVillageRepository(supabaseClient))
    ..registerLazySingleton<CategoryRepository>(() => SupabaseCategoryRepository(supabaseClient))
    ..registerLazySingleton<ProductRepository>(() => SupabaseProductRepository(supabaseClient))
    ..registerLazySingleton<ConnectivityService>(ConnectivityServiceImpl.new)
    ..registerLazySingleton<SessionCubit>(SessionCubit.new)
    ..registerLazySingleton<CartCubit>(CartCubit.new)
    ..registerLazySingleton<OrderRepository>(() => SupabaseOrderRepository(supabaseClient))
    ..registerLazySingleton<OutboxService>(() => OutboxService(getIt<OrderRepository>()))
    ..registerLazySingleton<CartSender>(() => CartSender(getIt<OrderRepository>(), getIt<OutboxService>()))
    ..registerLazySingleton<SessionCartCoordinator>(
        () => SessionCartCoordinator(getIt<SessionCubit>(), getIt<CartCubit>()));

  // Bind the cart to the session (merge on sign-in, reset for guest on sign-out).
  getIt<SessionCartCoordinator>().start();
}
