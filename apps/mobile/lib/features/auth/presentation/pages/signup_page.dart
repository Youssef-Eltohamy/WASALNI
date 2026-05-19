import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_paths.dart';
import '../../../../core/validators/email_validator.dart';
import '../../../../core/validators/password_validator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/repositories/auth_repository.dart';
import '../cubit/signup_form/signup_form_cubit.dart';
import '../widgets/terms_checkbox.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupFormCubit(repository: AuthRepository()),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: BlocConsumer<SignupFormCubit, SignupFormState>(
        listenWhen: (p, c) => p.isSuccess != c.isSuccess && c.isSuccess,
        listener: (context, state) {
          context.go(RoutePaths.emailConfirmation);
        },
        builder: (context, state) {
          final cubit = context.read<SignupFormCubit>();
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'انضم لـ وصلني',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سجل عشان تقدر تتواصل وتسجل نشاطك',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: 'الإيميل',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: cubit.emailChanged,
                    errorText: EmailInput.errorMessage(state.email.displayError),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'كلمة السر',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    onChanged: cubit.passwordChanged,
                    errorText:
                        PasswordInput.errorMessage(state.password.displayError),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'تأكيد كلمة السر',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onChanged: cubit.confirmPasswordChanged,
                    errorText: ConfirmPasswordInput.errorMessage(
                      state.confirmPassword.displayError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TermsCheckbox(
                    value: state.termsAccepted,
                    onChanged: cubit.termsAcceptedChanged,
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'سجل',
                    isLoading: state.isSubmitting,
                    onPressed: state.isValid ? cubit.submit : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('عندك حساب بالفعل؟'),
                      TextButton(
                        onPressed: () => context.go(RoutePaths.signin),
                        child: const Text('دخول'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
