import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String dateText;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const HeaderWidget({
    super.key,
    required this.dateText,
    this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(
                Icons.menu,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                dateText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}