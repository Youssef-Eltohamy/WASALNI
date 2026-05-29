import '../../models/village.dart';
import '../village_repository.dart';
import 'mock_data.dart';

class MockVillageRepository implements VillageRepository {
  MockVillageRepository({this.latency = const Duration(milliseconds: 200)});
  final Duration latency;

  @override
  Future<List<Village>> getVillages() async {
    await Future<void>.delayed(latency);
    return MockData.villages;
  }
}
