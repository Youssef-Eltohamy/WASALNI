import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/category.dart';

const Map<String, IconData> _categoryIcons = {
  'plumbing': Icons.plumbing,
  'electrical_services': Icons.electrical_services,
  'carpenter': Icons.carpenter,
  'local_pharmacy': Icons.local_pharmacy,
  'storefront': Icons.storefront,
  'electric_rickshaw': Icons.electric_rickshaw,
};

IconData iconForCategory(String name) => _categoryIcons[name] ?? Icons.category_outlined;

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, required this.onTap});
  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconForCategory(category.iconName), size: 36, color: AppColors.primary),
              const SizedBox(height: AppSpacing.sm),
              Text(category.name,
                  style: AppTextStyles.label, textAlign: TextAlign.center,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
