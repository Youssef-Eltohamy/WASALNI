import '../../models/category.dart';
import '../../models/enums.dart';
import '../category_repository.dart';
import 'mock_data.dart';

class MockCategoryRepository implements CategoryRepository {
  MockCategoryRepository({this.latency = const Duration(milliseconds: 200)});
  final Duration latency;

  @override
  Future<List<Category>> getCategories({ListingKind? kind}) async {
    await Future<void>.delayed(latency);
    final items = MockData.categories.where((c) => kind == null || c.kind == kind).toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }
}
