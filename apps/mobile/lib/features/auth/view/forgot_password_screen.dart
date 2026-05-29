import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_cubit.dart';
import '../bloc/reset_state.dart';
import '../phone_validator.dart';
import 'otp_code_field.dart';
import 'session_sign_in.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetCubit(getIt<AuthRepository>()),
      child: _ForgotBody(from: from),
    );
  }
}

class _ForgotBody extends StatefulWidget {
  const _ForgotBody({this.from});
  final String? from;
  @override
  State<_ForgotBody> createState() => _ForgotBodyState();
}

class _ForgotBodyState extends State<_ForgotBody> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  String get _e164 => '+20${normalizeDigits(_phone.text).substring(1)}';

  void _submitPhone() {
    setState(() => _localError = null);
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _localError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    context.read<ResetCubit>().submitPhone(_e164);
  }

  void _confirm() {
    setState(() => _localError = null);
    if (_password.text.length < 6) {
      setState(() => _localError = 'كلمة السر لازم 6 حروف على الأقل');
      return;
    }
    context.read<ResetCubit>().confirm(code: _code.text, newPassword: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نسيت كلمة السر')),
      body: BlocConsumer<ResetCubit, ResetState>(
        listener: (context, state) {
          if (state is ResetSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        builder: (context, state) {
          final onCode = state is ResetCodeSent || state is ResetVerifying;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(onCode ? 'اعمل كلمة سر جديدة' : 'استرجاع كلمة السر',
                  style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.lg),
              if (!onCode) ...[
                Text('اكتب رقم موبايلك وهنبعتلك كود', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  decoration: InputDecoration(
                    labelText: 'رقم الموبايل', hintText: '01xxxxxxxxx',
                    errorText: _localError ?? (state is ResetPhoneError ? state.message : null),
                    prefixIcon: const Icon(Icons.phone_android)),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is ResetSubmitting ? null : _submitPhone,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is ResetSubmitting ? 'لحظة...' : 'إرسال الكود'),
                ),
              ] else ...[
                Text('بعتنا كود على $_e164  (للتجربة: ١٢٣٤)', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.lg),
                OtpCodeField(
                  controller: _code,
                  errorText: state is ResetCodeSent ? state.error : null,
                  onResend: () => context.read<ResetCubit>().resend(),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة السر الجديدة (6 حروف على الأقل)',
                    errorText: _localError,
                    prefixIcon: const Icon(Icons.lock_outline)),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is ResetVerifying ? null : _confirm,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is ResetVerifying ? 'بنأكد...' : 'تأكيد كلمة السر الجديدة'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
