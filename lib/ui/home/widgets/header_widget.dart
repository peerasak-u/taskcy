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
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(
              Icons.menu,
              color: AppColors.textPrimary,
              size: 24,
            ),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
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
          IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
              size: 24,
            ),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
