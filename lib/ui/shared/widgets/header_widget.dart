import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String centerText;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  const HeaderWidget({
    super.key,
    required this.centerText,
    this.leftIcon,
    this.rightIcon,
    this.onLeftTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          if (leftIcon != null)
            IconButton(
              onPressed: onLeftTap,
              icon: Icon(
                leftIcon!,
                color: AppColors.textPrimary,
                size: 24,
              ),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                centerText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          if (rightIcon != null)
            IconButton(
              onPressed: onRightTap,
              icon: Icon(
                rightIcon!,
                color: AppColors.textPrimary,
                size: 24,
              ),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}