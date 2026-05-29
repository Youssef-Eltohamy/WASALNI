import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/otp_cubit.dart';
import '../bloc/otp_state.dart';
import 'session_sign_in.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.phone, this.from});
  final String phone;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(getIt<AuthRepository>())..requestCode(phone),
      child: _OtpBody(phone: phone, from: from),
    );
  }
}

class _OtpBody extends StatefulWidget {
  const _OtpBody({required this.phone, this.from});
  final String phone;
  final String? from;
  @override
  State<_OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<_OtpBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _messageFor(OtpState state) => switch (state) {
        OtpWrongCode() => 'الكود غلط، جرّب تاني',
        OtpExpired() => 'الكود انتهت صلاحيته، اطلب كود جديد',
        OtpRateLimited() => 'حاولت كتير، استنى شوية',
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الرقم')),
      body: BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        builder: (context, state) {
          final msg = _messageFor(state);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text('اكتب الكود اللي وصلك', style: AppTextStyles.headline),
                const SizedBox(height: AppSpacing.sm),
                Text('بعتنا كود على ${widget.phone}', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.sm),
                Text('(للتجربة: الكود ١٢٣٤)', style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                  style: AppTextStyles.headline,
                  decoration: InputDecoration(
                    counterText: '',
                    errorText: msg,
                    hintText: '____',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: state is OtpVerifying
                      ? null
                      : () => context.read<OtpCubit>().verify(phone: widget.phone, code: _controller.text),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(state is OtpVerifying ? 'بنأكد...' : 'تأكيد'),
                ),
                const SizedBox(height: AppSpacing.md),
                _ResendButton(phone: widget.phone, state: state),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  const _ResendButton({required this.phone, required this.state});
  final String phone;
  final OtpState state;

  @override
  Widget build(BuildContext context) {
    final canResend = state is! OtpCodeSent || (state as OtpCodeSent).resendSeconds <= 0;
    final seconds = state is OtpCodeSent ? (state as OtpCodeSent).resendSeconds : 0;
    return TextButton(
      onPressed: canResend ? () => context.read<OtpCubit>().resend(phone) : null,
      child: Text(canResend ? 'ابعت الكود تاني' : 'ابعت تاني بعد ($seconds)'),
    );
  }
}
