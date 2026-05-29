import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/listing.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing, required this.onTap});
  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: _Image(url: listing.logoUrl),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(listing.name,
                            style: AppTextStyles.label,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      if (listing.isVerified)
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: AppSpacing.xs),
                          child: Icon(Icons.verified, size: 16, color: AppColors.verified),
                        ),
                    ],
                  ),
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

class _Image extends StatelessWidget {
  const _Image({this.url});
  final String? url;
  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.border,
      child: const Icon(Icons.storefront, size: 40, color: AppColors.textMuted),
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
