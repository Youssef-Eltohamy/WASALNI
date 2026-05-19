import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

class WasalniApp extends StatefulWidget {
  const WasalniApp({super.key});

  @override
  State<WasalniApp> createState() => _WasalniAppState();
}

class _WasalniAppState extends State<WasalniApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: AuthRepository());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'وصلني',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.create(_authBloc),
        locale: const Locale('ar', 'EG'),
        supportedLocales: const [Locale('ar', 'EG')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
