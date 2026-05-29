import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';
import '../phone_validator.dart';
import 'session_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(getIt<AuthRepository>()),
      child: _LoginBody(from: from),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody({this.from});
  final String? from;
  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _phoneError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    setState(() => _phoneError = null);
    final e164 = '+20${normalizeDigits(_phone.text).substring(1)}';
    context.read<LoginCubit>().submit(phone: e164, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final busy = state is LoginSubmitting;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('أهلاً بيك تاني', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('سجّل دخولك برقم موبايلك وكلمة السر', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                decoration: InputDecoration(
                  labelText: 'رقم الموبايل',
                  hintText: '01xxxxxxxxx',
                  errorText: _phoneError,
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة السر',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: busy ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(busy ? 'بنسجّل دخولك...' : 'دخول'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        context.push('/auth/forgot', extra: <String, String?>{'from': widget.from}),
                    child: const Text('نسيت كلمة السر؟'),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.push('/auth/signup', extra: <String, String?>{'from': widget.from}),
                    child: const Text('إنشاء حساب'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Text('للتجربة: 01000000000 / 123456',
                    style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              ),
            ],
          );
        },
      ),
    );
  }
}
