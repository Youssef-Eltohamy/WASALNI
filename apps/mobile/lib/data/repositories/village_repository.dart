import '../models/village.dart';

abstract interface class VillageRepository {
  Future<List<Village>> getVillages();
}
