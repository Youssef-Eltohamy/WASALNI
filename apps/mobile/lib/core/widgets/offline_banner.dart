import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../connectivity/connectivity_cubit.dart';
import '../theme/app_spacing.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (context, status) {
        if (status == ConnectivityStatus.online) return const SizedBox.shrink();
        return Material(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
                SizedBox(width: AppSpacing.sm),
                Text('مفيش اتصال بالإنترنت',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
