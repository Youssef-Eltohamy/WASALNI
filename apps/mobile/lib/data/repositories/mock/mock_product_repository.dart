import '../../../core/network/repository_exception.dart';
import '../../models/product.dart';
import '../product_repository.dart';
import 'mock_data.dart';

class MockProductRepository implements ProductRepository {
  MockProductRepository({this.latency = const Duration(milliseconds: 300)});
  final Duration latency;

  @override
  Future<List<Product>> getProducts({required String shopId}) async {
    await Future<void>.delayed(latency);
    final items = MockData.products.where((p) => p.listingId == shopId).toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }

  @override
  Future<Product> getProductById(String id) async {
    await Future<void>.delayed(latency);
    final match = MockData.products.where((p) => p.id == id);
    if (match.isEmpty) throw const NotFoundException();
    return match.first;
  }
}
