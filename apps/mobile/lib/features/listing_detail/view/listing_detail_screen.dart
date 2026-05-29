import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/launch/contact_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/listing.dart';
import '../bloc/listing_detail_bloc.dart';
import '../bloc/listing_detail_state.dart';
import '../../products/widgets/shop_products_section.dart';

class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({super.key, this.launcher = const ContactLauncher()});
  final ContactLauncher launcher;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingDetailBloc, ListingDetailState>(
      builder: (context, state) => switch (state) {
        ListingDetailLoading() => const Scaffold(body: LoadingView()),
        ListingDetailNoConnection() => Scaffold(
            appBar: AppBar(),
            body: const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
          ),
        ListingDetailError(:final message) => Scaffold(
            appBar: AppBar(),
            body: ErrorView(message: message),
          ),
        ListingDetailLoaded(:final listing) => _DetailBody(listing: listing, launcher: launcher),
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.listing, required this.launcher});
  final Listing listing;
  final ContactLauncher launcher;

  Future<void> _whatsapp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launcher.whatsapp(
      listing.phoneWhatsapp,
      message: 'أنا لقيتك على وصلني و بتواصل معاك بخصوص: ',
    );
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذّر فتح واتساب — اتأكد إنه متنصّب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: (listing.logoUrl == null || listing.logoUrl!.isEmpty)
                  ? Container(
                      color: AppColors.border,
                      child: const Icon(Icons.storefront, size: 64, color: AppColors.textMuted))
                  : CachedNetworkImage(imageUrl: listing.logoUrl!, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(listing.name, style: AppTextStyles.headline)),
                      if (listing.isVerified)
                        const Icon(Icons.verified, color: AppColors.verified),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(listing.bio, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp),
                          onPressed: () => _whatsapp(context),
                          icon: const Icon(Icons.chat),
                          label: const Text('تواصل واتساب'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => launcher.call(listing.phoneWhatsapp),
                          icon: const Icon(Icons.call),
                          label: const Text('اتصال'),
                        ),
                      ),
                    ],
                  ),
                  if (listing.kind == ListingKind.shop) ...[
                    const SizedBox(height: AppSpacing.xl),
                    ShopProductsSection(shopId: listing.id),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
