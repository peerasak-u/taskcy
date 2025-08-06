import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LoadingStateWidget extends StatelessWidget {
  final String? message;
  final bool showMessage;
  
  const LoadingStateWidget({
    super.key,
    this.message,
    this.showMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showMessage && message != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              message!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}