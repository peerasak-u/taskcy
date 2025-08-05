import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/task.dart';
import '../../../domain/models/project.dart';
import '../../core/theme/app_colors.dart';

class HomeTaskViewModel extends Equatable {
  final String id;
  final String title;
  final String projectName;
  final double progress;
  final String timeAgo;
  final Color progressColor;

  const HomeTaskViewModel({
    required this.id,
    required this.title,
    required this.projectName,
    required this.progress,
    required this.timeAgo,
    required this.progressColor,
  });

  factory HomeTaskViewModel.fromTask({
    required Task task,
    required Project project,
  }) {
    return HomeTaskViewModel(
      id: task.id,
      title: task.title,
      projectName: project.name,
      progress: _calculateTaskProgress(task),
      timeAgo: _formatTimeAgo(task.updatedAt),
      progressColor: _getProgressColor(task, project),
    );
  }

  static double _calculateTaskProgress(Task task) {
    switch (task.status) {
      case TaskStatus.todo:
        return 0.0;
      case TaskStatus.inProgress:
        switch (task.priority) {
          case TaskPriority.low:
            return 0.3;
          case TaskPriority.medium:
            return 0.5;
          case TaskPriority.high:
            return 0.7;
          case TaskPriority.urgent:
            return 0.9;
        }
      case TaskStatus.completed:
        return 1.0;
    }
  }

  static String _formatTimeAgo(DateTime updatedAt) {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
  }

  static Color _getProgressColor(Task task, Project project) {
    switch (project.id) {
      case 'project_1':
        return AppColors.primary;
      case 'project_2':
        return AppColors.blue;
      case 'project_3':
        return AppColors.green;
      case 'project_4':
        return AppColors.orange;
      default:
        switch (task.priority) {
          case TaskPriority.urgent:
            return AppColors.primary;
          case TaskPriority.high:
            return AppColors.orange;
          case TaskPriority.medium:
            return AppColors.blue;
          case TaskPriority.low:
            return AppColors.green;
        }
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    projectName,
    progress,
    timeAgo,
    progressColor,
  ];
}