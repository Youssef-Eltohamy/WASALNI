import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/launch/contact_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/listing_visuals.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/listing.dart';
import '../bloc/listing_detail_bloc.dart';
import '../bloc/listing_detail_state.dart';
import '../../cart/widgets/cart_icon_button.dart';
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
    final isOpen = !listing.isTemporarilyClosed;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            foregroundColor: Colors.white,
            actions: const [CartIconButton()],
            flexibleSpace: FlexibleSpaceBar(
              background: _Cover(listing: listing),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(listing.name, style: AppTextStyles.headline)),
                          if (listing.isVerified) ...[
                            const Icon(Icons.verified, size: 20, color: AppColors.verified),
                            const SizedBox(width: AppSpacing.xs),
                            Text('موثّق',
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: AppColors.verified)),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _StatusChip(isOpen: isOpen),
                      const SizedBox(height: AppSpacing.md),
                      Text(listing.bio, style: AppTextStyles.body),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.whatsapp),
                              onPressed: () => _whatsapp(context),
                              icon: const Icon(Icons.chat),
                              label: const Text('تواصل واتساب'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary, width: 1.5),
                                minimumSize: const Size.fromHeight(52),
                              ),
                              onPressed: () => launcher.call(listing.phoneWhatsapp),
                              icon: const Icon(Icons.call),
                              label: const Text('اتصال'),
                            ),
                          ),
                        ],
                      ),
                      if (listing.kind == ListingKind.shop) ...[
                        const SizedBox(height: AppSpacing.xl),
                        ShopProductsSection(
                          shopId: listing.id,
                          shopName: listing.name,
                          shopPhone: listing.phoneWhatsapp,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cover image or a coloured gradient placeholder with the kind icon.
class _Cover extends StatelessWidget {
  const _Cover({required this.listing});
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final url = listing.logoUrl;
    if (url == null || url.isEmpty) {
      return DecoratedBox(
        decoration: const BoxDecoration(gradient: ListingVisuals.placeholderGradient),
        child: Center(
          child: Icon(ListingVisuals.icon(listing.kind),
              size: 72, color: Colors.white.withValues(alpha: 0.9)),
        ),
      );
    }
    return CachedNetworkImage(imageUrl: url, fit: BoxFit.cover);
  }
}

/// ● مفتوح / مقفول pill.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isOpen});
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: (isOpen ? AppColors.success : AppColors.textMuted)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        isOpen ? '● مفتوح دلوقتي' : '● مقفول مؤقتًا',
        style: AppTextStyles.labelSmall
            .copyWith(color: isOpen ? AppColors.success : AppColors.textMuted),
      ),
    );
  }
}
