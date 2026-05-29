import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../bloc/categories_bloc.dart';
import '../bloc/categories_event.dart';
import '../bloc/categories_state.dart';
import '../widgets/category_tile.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التصنيفات')),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) => switch (state) {
          CategoriesLoading() => const LoadingView(),
          CategoriesNoConnection() => ErrorView(
              message: 'مفيش اتصال بالإنترنت',
              isOffline: true,
              onRetry: () => context.read<CategoriesBloc>().add(const CategoriesRequested()),
            ),
          CategoriesError(:final message) => ErrorView(
              message: message,
              onRetry: () => context.read<CategoriesBloc>().add(const CategoriesRequested()),
            ),
          CategoriesLoaded(:final categories) => categories.isEmpty
              ? const EmptyView(message: 'مفيش تصنيفات')
              : GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return CategoryTile(
                      category: cat,
                      onTap: () => context.push('/category/${cat.id}', extra: cat.name),
                    );
                  },
                ),
        },
      ),
    );
  }
}
