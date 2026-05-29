import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import '../phone_validator.dart';

class PhoneEntryScreen extends StatelessWidget {
  const PhoneEntryScreen({super.key, this.from});
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(getIt<AuthRepository>()),
      child: _PhoneEntryBody(from: from),
    );
  }
}

class _PhoneEntryBody extends StatefulWidget {
  const _PhoneEntryBody({this.from});
  final String? from;
  @override
  State<_PhoneEntryBody> createState() => _PhoneEntryBodyState();
}

class _PhoneEntryBodyState extends State<_PhoneEntryBody> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final phone = _controller.text;
    if (!isValidEgyptianMobile(phone)) {
      setState(() => _error = 'اكتب رقم موبايل صح (11 رقم يبدأ بـ 01)');
      return;
    }
    setState(() => _error = null);
    context.read<OtpCubit>().requestCode('+20${normalizeDigits(phone).substring(1)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpCodeSent) {
            context.push('/auth/verify', extra: <String, String?>{
              'phone': '+20${normalizeDigits(_controller.text).substring(1)}',
              'from': widget.from,
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('اكتب رقم موبايلك', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('هنبعتلك كود تأكيد على الرقم ده', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                decoration: InputDecoration(
                  labelText: 'رقم الموبايل',
                  hintText: '01xxxxxxxxx',
                  errorText: _error,
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) => FilledButton(
                  onPressed: state is OtpSending ? null : _submit,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is OtpSending ? 'بنبعت الكود...' : 'إرسال الكود'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
