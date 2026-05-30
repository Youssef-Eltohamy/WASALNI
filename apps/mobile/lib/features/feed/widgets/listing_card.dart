import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/listing_visuals.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/listing.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing, required this.onTap});
  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOpen = !listing.isTemporarilyClosed;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Cover(url: listing.logoUrl, kind: listing.kind),
                  if (listing.isVerified)
                    const PositionedDirectional(
                      top: AppSpacing.sm,
                      start: AppSpacing.sm,
                      child: _VerifiedBadge(),
                    ),
                  PositionedDirectional(
                    bottom: AppSpacing.sm,
                    end: AppSpacing.sm,
                    child: _StatusBadge(isOpen: isOpen),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.name,
                      style: AppTextStyles.label,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.xs),
                  Text(listing.bio,
                      style: AppTextStyles.caption,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cover image, or a coloured smart placeholder (gradient + kind icon).
class _Cover extends StatelessWidget {
  const _Cover({this.url, required this.kind});
  final String? url;
  final ListingKind kind;

  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: const BoxDecoration(gradient: ListingVisuals.placeholderGradient),
      child: Center(
        child: Icon(ListingVisuals.icon(kind),
            size: 44, color: Colors.white.withValues(alpha: 0.9)),
      ),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => placeholder,
    );
  }
}

/// ✓ موثّق — white pill on the cover.
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, size: 14, color: AppColors.verified),
          const SizedBox(width: AppSpacing.xs),
          Text('موثّق',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.verified)),
        ],
      ),
    );
  }
}

/// ● مفتوح / مقفول — coloured status pill on the cover.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOpen});
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: isOpen ? AppColors.success : AppColors.textMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(isOpen ? 'مفتوح' : 'مقفول',
          style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
    );
  }
}
