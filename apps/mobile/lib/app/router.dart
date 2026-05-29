import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/village_repository.dart';
import '../features/account/account_placeholder.dart';
import '../features/categories/bloc/categories_bloc.dart';
import '../features/categories/bloc/categories_event.dart';
import '../features/categories/view/categories_screen.dart';
import '../features/categories/view/category_listings_screen.dart';
import '../features/favorites/favorites_placeholder.dart';
import '../features/feed/bloc/feed_bloc.dart';
import '../features/feed/view/feed_screen.dart';
import '../features/search/bloc/search_bloc.dart';
import '../features/search/view/search_screen.dart';
import '../features/shell/scaffold_with_nav_bar.dart';
import 'di.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/feed',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/feed',
              builder: (context, state) => BlocProvider(
                create: (_) => FeedBloc(getIt<ListingRepository>()),
                child: FeedScreen(villageRepository: getIt<VillageRepository>()),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => BlocProvider(
                create: (_) => CategoriesBloc(getIt<CategoryRepository>())
                  ..add(const CategoriesRequested()),
                child: const CategoriesScreen(),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/favorites', builder: (context, state) => const FavoritesPlaceholder()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/account', builder: (context, state) => const AccountPlaceholder()),
          ]),
        ],
      ),
      GoRoute(
        path: '/category/:id',
        builder: (context, state) => BlocProvider(
          create: (_) => FeedBloc(getIt<ListingRepository>()),
          child: CategoryListingsScreen(
            categoryId: state.pathParameters['id']!,
            categoryName: state.extra as String? ?? 'التصنيف',
            villageRepository: getIt<VillageRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => BlocProvider(
          create: (_) => SearchBloc(getIt<ListingRepository>()),
          child: SearchScreen(villageRepository: getIt<VillageRepository>()),
        ),
      ),
    ],
  );
}
