import 'dart:async';
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
      // Navigate on success only — listening (not building) keeps the body static.
      body: BlocListener<OtpCubit, OtpState>(
        listenWhen: (_, curr) => curr is OtpSuccess,
        listener: (context, state) {
          if (state is OtpSuccess) {
            signInAndReturn(context, state.profile, widget.from);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('اكتب الكود اللي وصلك', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              Text('بعتنا كود على ${widget.phone}', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Text('(للتجربة: الكود ١٢٣٤)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.accent)),
              const SizedBox(height: AppSpacing.xl),
              // Rebuilds only on real state changes (sending/verifying/error/...),
              // never per-second — the countdown lives in its own widget below.
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: AppTextStyles.headline,
                        decoration: InputDecoration(
                          counterText: '',
                          errorText: _messageFor(state),
                          hintText: '____',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      FilledButton(
                        onPressed: state is OtpVerifying
                            ? null
                            : () => context
                                .read<OtpCubit>()
                                .verify(phone: widget.phone, code: _controller.text),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                        child: Text(state is OtpVerifying ? 'بنأكد...' : 'تأكيد'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Self-contained: only THIS widget ticks every second.
              _ResendCountdown(phone: widget.phone),
            ],
          ),
        ),
      ),
    );
  }
}

/// Resend button with its own countdown timer. Counting down is a pure UI
/// concern, so it lives here (local setState) — the OtpCubit never emits
/// per-second states, so the rest of the screen never rebuilds for the timer.
class _ResendCountdown extends StatefulWidget {
  const _ResendCountdown({required this.phone});
  final String phone;
  @override
  State<_ResendCountdown> createState() => _ResendCountdownState();
}

class _ResendCountdownState extends State<_ResendCountdown> {
  static const _start = 30;
  int _seconds = _start;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _seconds = _start);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _seconds <= 0;
    return TextButton(
      onPressed: canResend
          ? () {
              context.read<OtpCubit>().resend(widget.phone);
              _startCountdown();
            }
          : null,
      child: Text(canResend ? 'ابعت الكود تاني' : 'ابعت تاني بعد ($_seconds)'),
    );
  }
}
