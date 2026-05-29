sealed class ProductsEvent {
  const ProductsEvent();
}

class ProductsRequested extends ProductsEvent {
  const ProductsRequested(this.shopId);
  final String shopId;
}
