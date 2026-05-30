import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/signup_cubit.dart';
import '../bloc/signup_state.dart';
import '../phone_validator.dart';
import 'otp_code_field.dart';
import 'session_sign_in.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(getIt<AuthRepository>()),
      child: _SignupBody(from: from),
    );
  }
}

class _SignupBody extends StatefulWidget {
  const _SignupBody({this.from});
  final String? from;
  @override
  State<_SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<_SignupBody> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  String? _formError;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  String get _e164 => '+20${normalizeDigits(_phone.text).substring(1)}';

  void _submitForm() {
    setState(() => _formError = null);
    if (_name.text.trim().isEmpty) {
      setState(() => _formError = 'اكتب اسمك');
      return;
    }
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _formError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    if (_password.text.length < 6) {
      setState(() => _formError = 'كلمة السر لازم 6 حروف على الأقل');
      return;
    }
    context.read<SignupCubit>().submitForm(
        name: _name.text.trim(), phone: _e164, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        builder: (context, state) {
          final onCode = state is SignupCodeSent || state is SignupVerifying;
          return ListView(
            padding: Responsive.formPadding(context),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(onCode ? 'أكّد رقمك' : 'اعمل حساب جديد', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.lg),
              if (!onCode) ...[
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'الاسم', prefixIcon: Icon(Icons.person_outline)),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  decoration: const InputDecoration(
                    labelText: 'رقم الموبايل', hintText: '01xxxxxxxxx',
                    prefixIcon: Icon(Icons.phone_android)),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة السر (6 حروف على الأقل)',
                    prefixIcon: Icon(Icons.lock_outline)),
                ),
                if (_formError != null || state is SignupFormError) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _formError ?? (state as SignupFormError).message,
                    style: AppTextStyles.caption.copyWith(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is SignupSubmitting ? null : _submitForm,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is SignupSubmitting ? 'لحظة...' : 'متابعة'),
                ),
              ] else ...[
                Text('بعتنا كود على $_e164  (للتجربة: ١٢٣٤)', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.lg),
                OtpCodeField(
                  controller: _code,
                  errorText: state is SignupCodeSent ? state.error : null,
                  onResend: () => context.read<SignupCubit>().resend(),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: state is SignupVerifying
                      ? null
                      : () => context.read<SignupCubit>().confirmCode(_code.text),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is SignupVerifying ? 'بنأكد...' : 'تأكيد وإنشاء الحساب'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
