import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry, this.isOffline = false});
  final String message;
  final VoidCallback? onRetry;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                size: 64, color: AppColors.accent),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onRetry, child: const Text('حاول تاني')),
            ],
          ],
        ),
      ),
    );
  }
}
