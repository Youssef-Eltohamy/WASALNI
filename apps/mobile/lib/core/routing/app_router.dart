import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const _SplashPlaceholder(),
      ),
      GoRoute(
        path: RoutePaths.feed,
        builder: (context, state) => const _FeedPlaceholder(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => const _PageStub(title: 'إنشاء حساب'),
      ),
      GoRoute(
        path: RoutePaths.signin,
        builder: (context, state) => const _PageStub(title: 'تسجيل دخول'),
      ),
      GoRoute(
        path: RoutePaths.emailConfirmation,
        builder: (context, state) => const _PageStub(title: 'تأكيد الإيميل'),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) =>
            const _PageStub(title: 'استعادة كلمة السر'),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        builder: (context, state) =>
            const _PageStub(title: 'كلمة سر جديدة'),
      ),
      GoRoute(
        path: RoutePaths.profileSetup,
        builder: (context, state) =>
            const _PageStub(title: 'بياناتك الشخصية'),
      ),
      GoRoute(
        path: RoutePaths.myAccount,
        builder: (context, state) => const _PageStub(title: 'حسابي'),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        builder: (context, state) =>
            const _PageStub(title: 'تعديل البروفايل'),
      ),
      GoRoute(
        path: RoutePaths.terms,
        builder: (context, state) =>
            const _PageStub(title: 'الشروط والأحكام'),
      ),
      GoRoute(
        path: RoutePaths.privacy,
        builder: (context, state) =>
            const _PageStub(title: 'سياسة الخصوصية'),
      ),
    ],
  );
}

class _SplashPlaceholder extends StatelessWidget {
  const _SplashPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF1B998B),
              child: Text(
                'و',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('وصلني', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.feed),
              child: const Text('ادخل التطبيق'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedPlaceholder extends StatelessWidget {
  const _FeedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('وصلني')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, size: 80, color: Color(0xFF1B998B)),
              SizedBox(height: 16),
              Text(
                'الـ Feed',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'سيتم تنفيذه في Spec 5',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageStub extends StatelessWidget {
  const _PageStub({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'شاشة "$title" - قيد التطوير',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
