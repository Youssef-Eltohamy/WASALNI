import 'package:flutter/material.dart';
import '../../../core/format/money.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/cart.dart';

class ShopCartCard extends StatelessWidget {
  const ShopCartCard({
    super.key,
    required this.shop,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onSend,
  });

  final ShopCart shop;
  final void Function(String productId) onIncrement;
  final void Function(String productId) onDecrement;
  final void Function(String productId) onRemove;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(shop.shopName, style: AppTextStyles.title)),
              ],
            ),
            if (shop.hasIssues) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text('في أصناف اتغيّر سعرها أو خلصت — راجع طلبك',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            for (final line in shop.lines) _LineRow(
              line: line,
              onIncrement: () => onIncrement(line.productId),
              onDecrement: () => onDecrement(line.productId),
              onRemove: () => onRemove(line.productId),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي', style: AppTextStyles.label),
                Text(formatEgp(shop.total),
                    style: AppTextStyles.title.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp),
                onPressed: shop.canSend ? onSend : null,
                icon: const Icon(Icons.send),
                label: Text(shop.canSend ? 'أرسل السلة' : 'مفيش رقم واتساب للمحل'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });
  final CartLine line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.name, style: AppTextStyles.label,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  line.isUnavailable ? 'غير متوفر حالياً' : formatEgp(line.effectivePrice),
                  style: AppTextStyles.caption.copyWith(
                      color: line.isUnavailable ? AppColors.accent : AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove_circle_outline)),
          Text('${line.qty}', style: AppTextStyles.label),
          IconButton(onPressed: onIncrement, icon: const Icon(Icons.add_circle_outline)),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'حذف',
          ),
        ],
      ),
    );
  }
}
