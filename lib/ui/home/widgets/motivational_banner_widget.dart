import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MotivationalBannerWidget extends StatelessWidget {
  final String message;
  final String emoji;

  const MotivationalBannerWidget({
    super.key,
    this.message = 'Let\'s make a\nhabits together',
    this.emoji = '🙌',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }
}