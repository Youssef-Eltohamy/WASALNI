import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/format/money.dart';
import '../../../core/launch/contact_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, this.launcher = const ContactLauncher()});
  final ContactLauncher launcher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) => switch (state) {
          ProductDetailLoading() => const LoadingView(),
          ProductDetailNoConnection() =>
            const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
          ProductDetailError(:final message) => ErrorView(message: message),
          ProductDetailLoaded(:final product, :final shopName, :final shopPhone) =>
            ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                        ? Container(
                            color: AppColors.border,
                            child: const Icon(Icons.inventory_2_outlined,
                                size: 64, color: AppColors.textMuted))
                        : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(product.name, style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.xs),
                Text(formatEgp(product.priceEgp),
                    style: AppTextStyles.title.copyWith(color: AppColors.primary)),
                const SizedBox(height: AppSpacing.sm),
                Text(product.description, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.md),
                Text('من: $shopName', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp),
                  onPressed: product.isAvailable
                      ? () => _order(context, product.name, product.priceEgp, shopPhone)
                      : null,
                  icon: const Icon(Icons.chat),
                  label: Text(product.isAvailable ? 'اطلب عبر واتساب' : 'غير متوفر حالياً'),
                ),
              ],
            ),
        },
      ),
    );
  }

  Future<void> _order(
      BuildContext context, String name, double price, String shopPhone) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launcher.whatsapp(
      shopPhone,
      message: 'السلام عليكم، عايز أطلب: $name (${formatEgp(price)}) — لقيته على وصلني',
    );
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذّر فتح واتساب — اتأكد إنه متنصّب')),
      );
    }
  }
}
