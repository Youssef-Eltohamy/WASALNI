import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../data/repositories/listing_repository.dart';
import '../data/repositories/village_repository.dart';
import '../features/account/account_placeholder.dart';
import '../features/categories/categories_placeholder.dart';
import '../features/favorites/favorites_placeholder.dart';
import '../features/feed/bloc/feed_bloc.dart';
import '../features/feed/bloc/feed_event.dart';
import '../features/feed/view/feed_screen.dart';
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
                create: (_) => FeedBloc(getIt<ListingRepository>())
                  ..add(const FeedRequested(villageId: 'v_kafr')),
                child: FeedScreen(villageRepository: getIt<VillageRepository>()),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/categories', builder: (context, state) => const CategoriesPlaceholder()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/favorites', builder: (context, state) => const FavoritesPlaceholder()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/account', builder: (context, state) => const AccountPlaceholder()),
          ]),
        ],
      ),
    ],
  );
}
