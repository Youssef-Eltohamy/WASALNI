import '../models/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getProducts({required String shopId});
  Future<Product> getProductById(String id);
}
