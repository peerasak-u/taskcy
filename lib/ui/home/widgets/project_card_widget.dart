import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/user_avatar_stack_widget.dart';
import 'progress_bar_widget.dart';

class ProjectCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> teamAvatars;
  final int currentProgress;
  final int totalProgress;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ProjectCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.teamAvatars,
    required this.currentProgress,
    required this.totalProgress,
    this.backgroundColor = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.background,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.background.withAlpha(179),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                UserAvatarStackWidget(
                  avatarUrls: teamAvatars,
                  size: 28,
                ),
                const Spacer(),
                Expanded(
                  child: ProgressBarWidget(
                    current: currentProgress,
                    total: totalProgress,
                    progressColor: AppColors.background,
                    backgroundColor: Colors.white24,
                    textColor: AppColors.background,
                    height: 6,
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