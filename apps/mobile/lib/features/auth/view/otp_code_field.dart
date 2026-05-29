import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Reusable OTP entry: a 4-digit code field + a self-contained resend countdown.
/// The countdown is local (Timer + setState) so it never rebuilds the parent.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.controller,
    required this.onResend,
    this.errorText,
    this.startSeconds = 30,
  });

  final TextEditingController controller;
  final VoidCallback onResend;
  final String? errorText;
  final int startSeconds;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late int _seconds = widget.startSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _seconds = widget.startSeconds);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: AppTextStyles.headline,
          decoration: InputDecoration(
            counterText: '',
            hintText: '____',
            errorText: widget.errorText,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: canResend
              ? () {
                  widget.onResend();
                  _start();
                }
              : null,
          child: Text(canResend ? 'ابعت الكود تاني' : 'ابعت تاني بعد ($_seconds)'),
        ),
      ],
    );
  }
}
