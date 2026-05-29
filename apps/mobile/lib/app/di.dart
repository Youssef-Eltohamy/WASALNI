import 'package:get_it/get_it.dart';
import '../core/connectivity/connectivity_service.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/village_repository.dart';
import '../data/repositories/mock/mock_category_repository.dart';
import '../data/repositories/mock/mock_listing_repository.dart';
import '../data/repositories/mock/mock_village_repository.dart';

final getIt = GetIt.instance;

/// Registers repositories + services. SWAP POINT: replace the Mock*
/// implementations with Supabase* here when the backend is ready.
void setupDi() {
  getIt
    ..registerLazySingleton<ListingRepository>(MockListingRepository.new)
    ..registerLazySingleton<VillageRepository>(MockVillageRepository.new)
    ..registerLazySingleton<CategoryRepository>(MockCategoryRepository.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityServiceImpl.new);
}
