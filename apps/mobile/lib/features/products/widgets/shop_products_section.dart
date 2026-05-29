import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/product_repository.dart';
import '../../cart/bloc/cart_cubit.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import 'product_card.dart';

class ShopProductsSection extends StatelessWidget {
  const ShopProductsSection({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.shopPhone,
    this.repository,
  });
  final String shopId;
  final String shopName;
  final String shopPhone;
  final ProductRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? getIt<ProductRepository>();
    return BlocProvider(
      create: (_) => ProductsBloc(repo)..add(ProductsRequested(shopId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المنتجات', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) => switch (state) {
              ProductsLoading() => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ProductsEmpty() => Text('مفيش منتجات لسه', style: AppTextStyles.caption),
              ProductsNoConnection() =>
                Text('تعذّر تحميل المنتجات (مفيش نت)', style: AppTextStyles.caption),
              ProductsError(:final message) => Text(message, style: AppTextStyles.caption),
              ProductsLoaded(:final products) => Column(
                  children: [
                    for (final p in products)
                      ProductCard(
                        product: p,
                        onTap: () => context.push('/product/${p.id}'),
                        onAdd: () {
                          context.read<CartCubit>().addProduct(
                                product: p, shopId: shopId, shopName: shopName, shopPhone: shopPhone);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تمت إضافة ${p.name} للسلة'), duration: const Duration(seconds: 1)),
                          );
                        },
                      ),
                  ],
                ),
            },
          ),
        ],
      ),
    );
  }
}
