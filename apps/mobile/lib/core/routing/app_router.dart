import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/email_confirmation_page.dart';
import '../../features/auth/presentation/pages/signin_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/widgets/auth_required_modal.dart';
import '../../features/profile/presentation/pages/profile_setup_page.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      refreshListenable: _GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authStatus = authBloc.state.status;
        final loc = state.matchedLocation;

        // الـ deep link callbacks (Supabase email confirmation, password reset):
        // امسكها قبل أي logic تاني وخليها تتصرف على حسب الـ auth state.
        // Supabase SDK بيعالج الـ token تلقائياً وهيحدّث AuthBloc.
        if (loc == RoutePaths.authConfirmCallback ||
            loc == RoutePaths.authResetPasswordCallback) {
          // استنى لحد ما الـ state يتحدّث
          if (authStatus == AuthStatus.unknown ||
              authStatus == AuthStatus.processing) {
            return null;
          }
          // بعد ما الـ state يتحدث، وجّه على حسب
          if (authStatus == AuthStatus.authenticatedNoProfile) {
            return RoutePaths.profileSetup;
          }
          if (authStatus == AuthStatus.authenticated) {
            return RoutePaths.feed;
          }
          if (authStatus == AuthStatus.awaitingEmailConfirmation) {
            return RoutePaths.emailConfirmation;
          }
          return RoutePaths.feed;
        }

        // عند البدء، استنى نعرف الـ state
        if (authStatus == AuthStatus.unknown) {
          return loc == RoutePaths.splash ? null : RoutePaths.splash;
        }

        // المستخدم سجل بس مأكدش الإيميل → وجّهه لشاشة التأكيد
        if (authStatus == AuthStatus.awaitingEmailConfirmation) {
          return loc == RoutePaths.emailConfirmation
              ? null
              : RoutePaths.emailConfirmation;
        }

        // المستخدم مأكد لكن لسه مكملش بروفايل → وجّهه للسيتب
        if (authStatus == AuthStatus.authenticatedNoProfile) {
          return loc == RoutePaths.profileSetup
              ? null
              : RoutePaths.profileSetup;
        }

        // من Splash → افتح الـ Feed
        if (loc == RoutePaths.splash &&
            (authStatus == AuthStatus.unauthenticated ||
                authStatus == AuthStatus.authenticated)) {
          return RoutePaths.feed;
        }

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const _SplashPage(),
        ),
        GoRoute(
          path: RoutePaths.feed,
          builder: (context, state) => const _FeedPlaceholder(),
        ),
        GoRoute(
          path: RoutePaths.signup,
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: RoutePaths.signin,
          builder: (context, state) => const SigninPage(),
        ),
        GoRoute(
          path: RoutePaths.emailConfirmation,
          builder: (context, state) => const EmailConfirmationPage(),
        ),
        GoRoute(
          path: RoutePaths.authConfirmCallback,
          builder: (context, state) => const _DeepLinkLandingPage(
            message: 'بنأكد إيميلك...',
          ),
        ),
        GoRoute(
          path: RoutePaths.authResetPasswordCallback,
          builder: (context, state) => const _DeepLinkLandingPage(
            message: 'جاري التحضير لإعادة تعيين كلمة السر...',
          ),
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          builder: (context, state) =>
              const _PageStub(title: 'استعادة كلمة السر'),
        ),
        GoRoute(
          path: RoutePaths.resetPassword,
          builder: (context, state) => const _PageStub(title: 'كلمة سر جديدة'),
        ),
        GoRoute(
          path: RoutePaths.profileSetup,
          builder: (context, state) => const ProfileSetupPage(),
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
}

/// يحول Stream إلى Listenable عشان go_router refreshListenable
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    (_subscription as dynamic).cancel();
    super.dispose();
  }
}

class _SplashPage extends StatefulWidget {
  const _SplashPage();

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> {
  @override
  void initState() {
    super.initState();
    // ابدأ الـ Auth bootstrap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AuthStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
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
            SizedBox(height: 16),
            Text(
              'وصلني',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Color(0xFF1B998B)),
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
      appBar: AppBar(
        title: const Text('وصلني'),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isAuthenticated) {
                return IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => context.go(RoutePaths.myAccount),
                );
              }
              return TextButton(
                onPressed: () => context.go(RoutePaths.signin),
                child: const Text('دخول'),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.explore, size: 80, color: Color(0xFF1B998B)),
              const SizedBox(height: 16),
              const Text(
                'الـ Feed',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'سيتم تنفيذه في Spec 5',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state.isGuest) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => context.go(RoutePaths.signup),
                          child: const Text('أنشئ حساب'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.storefront),
                          label: const Text('سجّل نشاطك'),
                          onPressed: () => AuthRequiredModal.show(
                            context,
                            message: 'سجل دخولك عشان تقدر تسجل نشاطك',
                            icon: Icons.storefront,
                          ),
                        ),
                      ],
                    );
                  }
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.storefront),
                    label: const Text('سجّل نشاطك'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تسجيل النشاط سيتم تنفيذه في Spec 3'),
                        ),
                      );
                    },
                  );
                },
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

/// شاشة وسيطة بتظهر لما deep link يفتح التطبيق.
/// الـ router redirect يوجه المستخدم بعد ما الـ AuthBloc يتحدّث.
class _DeepLinkLandingPage extends StatelessWidget {
  const _DeepLinkLandingPage({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF1B998B)),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
