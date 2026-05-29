import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../data/repositories/village_repository.dart';
import '../../feed/widgets/listing_card.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.villageRepository});
  final VillageRepository villageRepository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String? _villageId;

  @override
  void initState() {
    super.initState();
    _loadVillage();
  }

  Future<void> _loadVillage() async {
    final villages = await widget.villageRepository.getVillages();
    if (!mounted || villages.isEmpty) return;
    setState(() => _villageId = villages.first.id);
  }

  void _onChanged(String query) {
    final v = _villageId;
    if (v == null) return;
    context.read<SearchBloc>().add(SearchQueryChanged(villageId: v, query: query));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 16),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'ابحث عن خدمة أو محل...',
            hintStyle: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
            border: InputBorder.none,
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => switch (state) {
          SearchInitial() => const EmptyView(message: 'ابحث بالاسم أو الفئة', icon: Icons.search),
          SearchLoading() => const LoadingView(),
          SearchEmpty() => const EmptyView(message: 'مفيش نتائج للبحث ده'),
          SearchNoConnection() =>
            const ErrorView(message: 'مفيش اتصال بالإنترنت', isOffline: true),
          SearchError(:final message) => ErrorView(message: message),
          SearchLoaded(:final results) => GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.72,
              ),
              itemCount: results.length,
              itemBuilder: (context, i) =>
                  ListingCard(listing: results[i], onTap: () => context.push('/listing/${results[i].id}')),
            ),
        },
      ),
    );
  }
}
