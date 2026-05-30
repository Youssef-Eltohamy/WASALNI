import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/bloc/session_cubit.dart';
import '../../auth/bloc/session_state.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) => switch (state) {
          SessionAuthenticated(:final profile) => _Authenticated(
              name: profile.displayName.isEmpty ? 'مستخدم وصلني' : profile.displayName,
              phone: profile.phone,
              onSignOut: () => context.read<SessionCubit>().signOut(),
            ),
          _ => _Guest(onSignIn: () => context.push('/auth', extra: <String, String?>{'from': '/account'})),
        },
      ),
    );
  }
}

class _Guest extends StatelessWidget {
  const _Guest({required this.onSignIn});
  final VoidCallback onSignIn;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined, size: 72, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text('سجّل دخولك عشان تكمّل', style: AppTextStyles.title, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text('تقدر تتصفح من غير تسجيل، بس التسجيل بيخليك تطلب وتحفظ المفضلة',
                style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: onSignIn,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              icon: const Icon(Icons.login),
              label: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Authenticated extends StatelessWidget {
  const _Authenticated({required this.name, required this.phone, required this.onSignOut});
  final String name;
  final String phone;
  final VoidCallback onSignOut;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: Responsive.formPadding(context),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryLight, AppColors.primaryDark],
              ),
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: 44, color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(name, style: AppTextStyles.headline, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        Text(phone, style: AppTextStyles.caption, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xl),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error, width: 1.5),
            minimumSize: const Size.fromHeight(52),
          ),
          onPressed: onSignOut,
          icon: const Icon(Icons.logout),
          label: const Text('تسجيل الخروج'),
        ),
      ],
    );
  }
}
