sealed class ProductDetailEvent {
  const ProductDetailEvent();
}

class ProductDetailRequested extends ProductDetailEvent {
  const ProductDetailRequested(this.productId);
  final String productId;
}
