import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_phone_cubit.dart';
import '../bloc/reset_phone_state.dart';
import '../phone_validator.dart';

class ResetPhoneScreen extends StatelessWidget {
  const ResetPhoneScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPhoneCubit(getIt<AuthRepository>()),
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
  final _phone = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String get _e164 => '+20${normalizeDigits(_phone.text).substring(1)}';

  void _submit() {
    if (!isValidEgyptianMobile(_phone.text)) {
      setState(() => _phoneError = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    setState(() => _phoneError = null);
    context.read<ResetPhoneCubit>().submit(_e164);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نسيت كلمة السر')),
      body: BlocConsumer<ResetPhoneCubit, ResetPhoneState>(
        listener: (context, state) {
          if (state is ResetPhoneSent) {
            context.push('/auth/forgot/otp', extra: <String, String?>{
              'phone': state.phone,
              'from': widget.from,
            });
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('استرجاع كلمة السر', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('اكتب رقم موبايلك وهنبعتلك كود', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                decoration: InputDecoration(
                  labelText: 'رقم الموبايل',
                  hintText: '01xxxxxxxxx',
                  errorText: _phoneError ??
                      (state is ResetPhoneError ? state.message : null),
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: state is ResetPhoneSubmitting ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(state is ResetPhoneSubmitting ? 'لحظة...' : 'إرسال الكود'),
              ),
            ],
          );
        },
      ),
    );
  }
}
