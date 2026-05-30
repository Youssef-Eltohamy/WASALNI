import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap, this.onAdd});
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final available = product.isAvailable;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: SizedBox(
            width: 56,
            height: 56,
            child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                ? const DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.surfaceAlt),
                    child: Icon(Icons.inventory_2_outlined, color: AppColors.textMuted))
                : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
          ),
        ),
        title: Text(product.name, style: AppTextStyles.label,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          available ? formatEgp(product.priceEgp) : 'غير متوفر حالياً',
          style: AppTextStyles.label.copyWith(
              color: available ? AppColors.primary : AppColors.accent),
        ),
        trailing: (onAdd != null && available)
            ? IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.accent),
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'أضف للسلة',
                onPressed: onAdd,
              )
            : null,
      ),
    );
  }
}
