import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/task.dart';
import '../../../domain/models/user.dart';
import '../../core/theme/app_colors.dart';

class HomeProjectViewModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final List<String> teamAvatars;
  final int currentProgress;
  final int totalProgress;
  final Color backgroundColor;

  const HomeProjectViewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.teamAvatars,
    required this.currentProgress,
    required this.totalProgress,
    required this.backgroundColor,
  });

  factory HomeProjectViewModel.fromProject({
    required Project project,
    required List<Task> projectTasks,
  }) {
    final completedTasks = projectTasks.where((task) => task.status == TaskStatus.completed).length;
    final totalTasks = projectTasks.length;
    
    final backgroundColor = _getProjectColor(project.id);
    
    final teamAvatars = _getTeamAvatars(project.team.members);
    
    return HomeProjectViewModel(
      id: project.id,
      title: project.name,
      subtitle: _getProjectSubtitle(project.name),
      teamAvatars: teamAvatars,
      currentProgress: completedTasks,
      totalProgress: totalTasks > 0 ? totalTasks : 1,
      backgroundColor: backgroundColor,
    );
  }

  double get progressPercentage => currentProgress / totalProgress;

  static Color _getProjectColor(String projectId) {
    switch (projectId) {
      case 'project_1':
        return AppColors.primary;
      case 'project_2':
        return AppColors.blue;
      case 'project_3':
        return AppColors.green;
      case 'project_4':
        return AppColors.orange;
      default:
        return AppColors.primary;
    }
  }

  static String _getProjectSubtitle(String projectName) {
    if (projectName.toLowerCase().contains('design')) {
      return 'UI Design Kit';
    } else if (projectName.toLowerCase().contains('banking')) {
      return 'UI Design';
    } else if (projectName.toLowerCase().contains('course')) {
      return 'Landing Page';
    } else if (projectName.toLowerCase().contains('commerce')) {
      return 'E-commerce';
    }
    return 'Project';
  }

  static List<String> _getTeamAvatars(List<User> members) {
    return members.map((user) => user.avatarUrl ?? '').where((url) => url.isNotEmpty).toList();
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    teamAvatars,
    currentProgress,
    totalProgress,
    backgroundColor,
  ];
}