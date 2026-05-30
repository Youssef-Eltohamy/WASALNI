import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/money.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../cart/bloc/cart_cubit.dart';
import '../../cart/widgets/cart_icon_button.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_state.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        actions: const [CartIconButton()],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) => switch (state) {
          ProductDetailLoading() => const LoadingView(),
          ProductDetailNoConnection() =>
            const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
          ProductDetailError(:final message) => ErrorView(message: message),
          ProductDetailLoaded(:final product, :final shopName, :final shopPhone) =>
            ListView(
              padding: Responsive.formPadding(context),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                          ? const DecoratedBox(
                              decoration: BoxDecoration(color: AppColors.surfaceAlt),
                              child: Icon(Icons.inventory_2_outlined,
                                  size: 64, color: AppColors.textMuted))
                          : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(product.name, style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.xs),
                Text(formatEgp(product.priceEgp),
                    style: AppTextStyles.display.copyWith(color: AppColors.primary)),
                const SizedBox(height: AppSpacing.sm),
                Text(product.description, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.md),
                Text('من: $shopName', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.xl),
                if (product.isAvailable) ...[
                  Row(
                    children: [
                      Text('الكمية:', style: AppTextStyles.label),
                      const SizedBox(width: AppSpacing.md),
                      IconButton.outlined(
                        onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text('$_qty', style: AppTextStyles.title),
                      ),
                      IconButton.outlined(
                        onPressed: () => setState(() => _qty++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                  onPressed: product.isAvailable
                      ? () {
                          context.read<CartCubit>().addProduct(
                                product: product,
                                shopId: product.listingId,
                                shopName: shopName,
                                shopPhone: shopPhone,
                                qty: _qty,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('أضفنا ${product.name} للسلة'), duration: const Duration(seconds: 1)),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(product.isAvailable ? 'أضف للسلة' : 'غير متوفر حالياً'),
                ),
              ],
            ),
        },
      ),
    );
  }
}
