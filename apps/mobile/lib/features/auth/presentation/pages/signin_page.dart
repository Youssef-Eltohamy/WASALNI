import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_paths.dart';
import '../../../../core/validators/email_validator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/repositories/auth_repository.dart';
import '../cubit/signin_form/signin_form_cubit.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SigninFormCubit(repository: AuthRepository()),
      child: const _SigninView(),
    );
  }
}

class _SigninView extends StatelessWidget {
  const _SigninView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل دخول')),
      body: BlocConsumer<SigninFormCubit, SigninFormState>(
        listenWhen: (p, c) =>
            p.needsEmailConfirmation != c.needsEmailConfirmation &&
            c.needsEmailConfirmation,
        listener: (context, state) {
          context.go(RoutePaths.emailConfirmation);
        },
        builder: (context, state) {
          final cubit = context.read<SigninFormCubit>();
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'أهلاً بعودتك',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سجل دخولك بالإيميل وكلمة السر',
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
                    textInputAction: TextInputAction.done,
                    onChanged: cubit.passwordChanged,
                    errorText: state.password.isPure || state.password.isValid
                        ? null
                        : 'كلمة السر مطلوبة',
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => context.push(RoutePaths.forgotPassword),
                      child: const Text('نسيت كلمة السر؟'),
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 8),
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
                    label: 'دخول',
                    isLoading: state.isSubmitting,
                    onPressed: state.isValid ? cubit.submit : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('مفيش حساب؟'),
                      TextButton(
                        onPressed: () => context.go(RoutePaths.signup),
                        child: const Text('أنشئ حساب جديد'),
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
