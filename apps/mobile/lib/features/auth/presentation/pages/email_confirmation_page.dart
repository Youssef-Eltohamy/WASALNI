import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';

class EmailConfirmationPage extends StatefulWidget {
  const EmailConfirmationPage({super.key});

  @override
  State<EmailConfirmationPage> createState() => _EmailConfirmationPageState();
}

class _EmailConfirmationPageState extends State<EmailConfirmationPage> {
  Timer? _resendCooldown;
  int _secondsLeft = 0;

  @override
  void dispose() {
    _resendCooldown?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _secondsLeft = 60);
    _resendCooldown?.cancel();
    _resendCooldown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend(String email) {
    context.read<AuthBloc>().add(ResendConfirmationRequested(email));
    _startCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال إيميل التأكيد')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final email = user?.email ?? '';
        final daysLeft = user?.daysLeftBeforeAutoDelete;

        return Scaffold(
          appBar: AppBar(title: const Text('تأكيد الإيميل')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 96,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'بعتنالك إيميل تأكيد',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'افتح بريدك ($email) واضغط على لينك التأكيد لتفعيل حسابك.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (daysLeft != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'باقي $daysLeft ${daysLeft == 1 ? 'يوم' : 'أيام'} لتأكيد الإيميل قبل حذف الحساب تلقائياً',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  PrimaryButton(
                    label: _secondsLeft > 0
                        ? 'إعادة الإرسال ($_secondsLeft ث)'
                        : 'إعادة إرسال الإيميل',
                    onPressed: _secondsLeft > 0 ? null : () => _resend(email),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(RoutePaths.feed),
                    child: const Text('العودة للتطبيق'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
