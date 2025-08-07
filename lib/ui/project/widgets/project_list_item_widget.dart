import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../home/widgets/progress_bar_widget.dart';
import '../../shared/widgets/user_avatar_stack_widget.dart';
import '../view_model/projects_view_model.dart';

class ProjectListItemWidget extends StatelessWidget {
  final ProjectItemViewModel project;
  final VoidCallback? onTap;

  const ProjectListItemWidget({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 93,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline, width: 1),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        project.teamName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserAvatarStackWidget(
                  avatarUrls: project.teamAvatars,
                  size: 24,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 * 0.5,
                  child: ProgressBarWidget(
                    current: (project.progressPercentage * 100).round(),
                    total: 100,
                    progressColor: project.progressColor,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                    textColor: AppColors.textSecondary,
                    height: 8,
                    showText: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
