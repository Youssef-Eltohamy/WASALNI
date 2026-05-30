import 'package:flutter/material.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/shimmer.dart';

/// A shimmering grid of placeholder cards shown while the feed loads.
/// Mirrors the real feed grid's column count and aspect ratio.
class ListingGridSkeleton extends StatelessWidget {
  const ListingGridSkeleton({super.key, this.itemCount = 6});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.gridColumns(constraints.maxWidth);
        return Shimmer(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.72,
            ),
            itemCount: itemCount,
            itemBuilder: (ctx, idx) => const _SkeletonCard(),
          ),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 10,
            child: DecoratedBox(decoration: BoxDecoration(color: AppColors.surfaceAlt)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(height: 14, width: 110),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 11),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(height: 11, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
