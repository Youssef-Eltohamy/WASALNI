import '../models/category.dart';
import '../models/enums.dart';

abstract interface class CategoryRepository {
  Future<List<Category>> getCategories({ListingKind? kind});
}
