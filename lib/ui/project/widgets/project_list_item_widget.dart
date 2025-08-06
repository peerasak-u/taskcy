import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../home/widgets/progress_bar_widget.dart';
import '../../shared/widgets/user_avatar_stack_widget.dart';
import '../view_model/projects_view_model.dart';

class ProjectListItemWidget extends StatelessWidget {
  final ProjectItemViewModel project;
  final VoidCallback? onTap;

  const ProjectListItemWidget({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project.progress,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                UserAvatarStackWidget(
                  avatarUrls: project.teamAvatars,
                  size: 24,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            ProgressBarWidget(
              current: (project.progressPercentage * 100).round(),
              total: 100,
              progressColor: project.progressColor,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
              textColor: AppColors.textSecondary,
              height: 4,
              showText: false,
            ),
          ],
        ),
      ),
    );
  }
}