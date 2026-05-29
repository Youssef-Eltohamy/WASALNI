import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/repositories/village_repository.dart';
import '../../feed/bloc/feed_bloc.dart';
import '../../feed/bloc/feed_event.dart';
import '../../feed/bloc/feed_state.dart';
import '../../feed/widgets/listing_card.dart';

class CategoryListingsScreen extends StatefulWidget {
  const CategoryListingsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.villageRepository,
  });
  final String categoryId;
  final String categoryName;
  final VillageRepository villageRepository;

  @override
  State<CategoryListingsScreen> createState() => _CategoryListingsScreenState();
}

class _CategoryListingsScreenState extends State<CategoryListingsScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bloc = context.read<FeedBloc>();
    final villages = await widget.villageRepository.getVillages();
    if (!mounted || villages.isEmpty) return;
    bloc.add(FeedRequested(villageId: villages.first.id, categoryId: widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) => switch (state) {
          FeedLoading() => const LoadingView(),
          FeedEmpty() => const EmptyView(message: 'مفيش نشاطات في التصنيف ده لسه'),
          FeedNoConnection() => ErrorView(
              message: 'مفيش اتصال بالإنترنت', isOffline: true, onRetry: _load),
          FeedError(:final message) => ErrorView(message: message, onRetry: _load),
          FeedLoaded(:final listings) => GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.72,
              ),
              itemCount: listings.length,
              itemBuilder: (context, i) =>
                  ListingCard(listing: listings[i], onTap: () => context.push('/listing/${listings[i].id}')),
            ),
        },
      ),
    );
  }
}
