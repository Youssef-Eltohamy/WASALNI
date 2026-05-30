import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_password_cubit.dart';
import '../bloc/reset_password_state.dart';
import 'session_sign_in.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.phone,
    required this.token,
    this.from,
  });
  final String phone;
  final String token;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(getIt<AuthRepository>(), phone, token),
      child: _Body(from: from),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({this.from});
  final String? from;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _password = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_password.text.length < 6) {
      setState(() => _localError = 'كلمة السر لازم 6 حروف على الأقل');
      return;
    }
    setState(() => _localError = null);
    context.read<ResetPasswordCubit>().submit(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('كلمة السر الجديدة')),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          } else if (state is ResetPasswordTokenInvalid) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.go('/auth/forgot');
          } else if (state is ResetPasswordError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('اعمل كلمة سر جديدة', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة السر الجديدة (6 حروف على الأقل)',
                  errorText: _localError,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: state is ResetPasswordSubmitting ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(state is ResetPasswordSubmitting
                    ? 'بنأكد...'
                    : 'تأكيد كلمة السر الجديدة'),
              ),
            ],
          );
        },
      ),
    );
  }
}
