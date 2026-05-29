import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/models/village.dart';
import '../../../data/repositories/village_repository.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/listing_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.villageRepository});
  final VillageRepository villageRepository;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Village> _villages = const [];
  String? _selectedVillageId;

  @override
  void initState() {
    super.initState();
    _loadVillages();
  }

  Future<void> _loadVillages() async {
    final bloc = context.read<FeedBloc>();
    final villages = await widget.villageRepository.getVillages();
    if (!mounted || villages.isEmpty) return;
    setState(() {
      _villages = villages;
      _selectedVillageId = villages.first.id;
    });
    bloc.add(FeedRequested(villageId: villages.first.id));
  }

  void _selectVillage(String id) {
    setState(() => _selectedVillageId = id);
    context.read<FeedBloc>().add(FeedRequested(villageId: id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('وصلني')),
      body: Column(
        children: [
          if (_villages.isNotEmpty && _selectedVillageId != null)
            _VillageFilter(
              villages: _villages,
              selectedId: _selectedVillageId!,
              onSelected: _selectVillage,
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  context.read<FeedBloc>().add(const FeedRefreshed()),
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) => switch (state) {
                  FeedLoading() => const LoadingView(),
                  FeedEmpty() => const EmptyView(
                      message: 'مفيش نشاطات في القرية دي لسه',
                    ),
                  FeedNoConnection() => ErrorView(
                      message: 'مفيش اتصال بالإنترنت',
                      isOffline: true,
                      onRetry: () =>
                          context.read<FeedBloc>().add(const FeedRefreshed()),
                    ),
                  FeedError(:final message) => ErrorView(
                      message: message,
                      onRetry: () =>
                          context.read<FeedBloc>().add(const FeedRefreshed()),
                    ),
                  FeedLoaded(:final listings) => GridView.builder(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: listings.length,
                      itemBuilder: (ctx, idx) =>
                          ListingCard(listing: listings[idx], onTap: () {}),
                    ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VillageFilter extends StatelessWidget {
  const _VillageFilter({
    required this.villages,
    required this.selectedId,
    required this.onSelected,
  });
  final List<Village> villages;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: villages.length,
        separatorBuilder: (ctx, idx) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (ctx, idx) {
          final v = villages[idx];
          return ChoiceChip(
            label: Text(v.name),
            selected: v.id == selectedId,
            onSelected: (selected) => onSelected(v.id),
          );
        },
      ),
    );
  }
}
