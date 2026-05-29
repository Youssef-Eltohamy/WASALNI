import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 56,
          height: 56,
          child: (product.imageUrl == null || product.imageUrl!.isEmpty)
              ? Container(
                  color: AppColors.border,
                  child: const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted))
              : CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover),
        ),
        title: Text(product.name, style: AppTextStyles.label,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          product.isAvailable ? formatEgp(product.priceEgp) : 'غير متوفر حالياً',
          style: AppTextStyles.caption.copyWith(
            color: product.isAvailable ? AppColors.primary : AppColors.accent),
        ),
      ),
    );
  }
}
