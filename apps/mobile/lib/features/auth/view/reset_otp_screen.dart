import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/di.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/reset_otp_cubit.dart';
import '../bloc/reset_otp_state.dart';
import 'otp_code_field.dart';

class ResetOtpScreen extends StatelessWidget {
  const ResetOtpScreen({super.key, required this.phone, this.from});
  final String phone;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetOtpCubit(getIt<AuthRepository>(), phone),
      child: _Body(phone: phone, from: from),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.phone, this.from});
  final String phone;
  final String? from;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعادة تعيين كلمة السر')),
      body: BlocConsumer<ResetOtpCubit, ResetOtpState>(
        listener: (context, state) {
          if (state is ResetOtpVerified) {
            // Replace (not push) so the user can't go back to this OTP screen
            // after the code is consumed — a back tap returns to the phone step.
            context.pushReplacement('/auth/forgot/reset', extra: <String, String?>{
              'phone': widget.phone,
              'token': state.token,
              'from': widget.from,
            });
          }
        },
        builder: (context, state) {
          return ListView(
            padding: Responsive.formPadding(context),
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('أكّد رقمك', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('بعتنا كود على ${widget.phone}  (للتجربة: ١٢٣٤)',
                  style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.lg),
              OtpCodeField(
                controller: _code,
                errorText: state is ResetOtpError ? state.message : null,
                onResend: () => context.read<ResetOtpCubit>().resend(),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: state is ResetOtpVerifying
                    ? null
                    : () => context.read<ResetOtpCubit>().verify(_code.text),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: Text(state is ResetOtpVerifying ? 'بنأكد...' : 'تأكيد الكود'),
              ),
            ],
          );
        },
      ),
    );
  }
}
