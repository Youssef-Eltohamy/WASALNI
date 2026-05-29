import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wasalni/data/repositories/category_repository.dart';
import 'package:wasalni/data/repositories/mock/mock_category_repository.dart';
import 'package:wasalni/features/categories/bloc/categories_bloc.dart';
import 'package:wasalni/features/categories/bloc/categories_event.dart';
import 'package:wasalni/features/categories/view/categories_screen.dart';

void main() {
  testWidgets('CategoriesScreen renders category names', (tester) async {
    final CategoryRepository repo = MockCategoryRepository(latency: Duration.zero);
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (_) => CategoriesBloc(repo)..add(const CategoriesRequested()),
          child: const CategoriesScreen(),
        ),
      ),
    ]);
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    ));
    await tester.pumpAndSettle();

    expect(find.text('سباكة'), findsOneWidget);
    expect(find.text('صيدلية'), findsOneWidget);
  });
}
