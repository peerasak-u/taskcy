import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'circular_progress_widget.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final String projectName;
  final double progress;
  final String timeAgo;
  final Color progressColor;
  final VoidCallback? onTap;

  const TaskItemWidget({
    super.key,
    required this.title,
    required this.projectName,
    required this.progress,
    required this.timeAgo,
    this.progressColor = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            CircularProgressWidget(
              progress: progress,
              size: 44,
              strokeWidth: 3,
              progressColor: progressColor,
              backgroundColor: AppColors.surface,
              textStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}