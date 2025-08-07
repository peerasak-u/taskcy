import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/task.dart';
import '../../../domain/models/user.dart';
import '../../core/theme/app_colors.dart';
import '../bloc/projects_event.dart';

class ProjectsViewModel extends Equatable {
  final List<ProjectItemViewModel> projects;
  final ProjectFilterType currentFilter;
  final String searchQuery;

  const ProjectsViewModel({
    required this.projects,
    required this.currentFilter,
    required this.searchQuery,
  });

  factory ProjectsViewModel.fromProjects(
    List<Project> projects, {
    required Map<String, List<Task>> tasksByProject,
    required ProjectFilterType currentFilter,
    required String searchQuery,
  }) {
    final projectItems = projects.map((project) {
      final projectTasks = tasksByProject[project.id] ?? [];
      return ProjectItemViewModel.fromProject(project, projectTasks: projectTasks);
    }).toList();

    return ProjectsViewModel(
      projects: projectItems,
      currentFilter: currentFilter,
      searchQuery: searchQuery,
    );
  }

  @override
  List<Object?> get props => [projects, currentFilter, searchQuery];
}

class ProjectItemViewModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final String teamName;
  final String emoji;
  final List<String> teamAvatars;
  final String progress;
  final double progressPercentage;
  final Color progressColor;

  const ProjectItemViewModel({
    required this.id,
    required this.title,
    required this.category,
    required this.teamName,
    required this.emoji,
    required this.teamAvatars,
    required this.progress,
    required this.progressPercentage,
    required this.progressColor,
  });

  factory ProjectItemViewModel.fromProject(Project project, {required List<Task> projectTasks}) {
    // Calculate real progress from task completion
    final total = projectTasks.length;
    final completed = projectTasks.where((task) => task.status == TaskStatus.completed).length;
    final percentage = total > 0 ? completed / total : 0.0;

    return ProjectItemViewModel(
      id: project.id,
      title: '${project.name} ${_getProjectEmoji(project.name)}',
      category: _getCategoryFromDescription(project.description),
      teamName: project.team.name,
      emoji: _getProjectEmoji(project.name),
      teamAvatars: _getTeamAvatars(project.team.members),
      progress: '$completed/$total',
      progressPercentage: percentage,
      progressColor: _getProgressColor(percentage),
    );
  }

  static String _getProjectEmoji(String projectName) {
    final name = projectName.toLowerCase();
    if (name.contains('axentech') || name.contains('assignment')) {
      return '📚';
    } else if (name.contains('pygmy') || name.contains('migrate')) {
      return '🚀';
    } else if (name.contains('brand') || name.contains('identity') || name.contains('campaign')) {
      return '🎨';
    } else if (name.contains('personal') || name.contains('productivity') || name.contains('tools')) {
      return '🔧';
    } else if (name.contains('unity') || name.contains('dashboard')) {
      return '🤩';
    } else if (name.contains('instagram') || name.contains('social')) {
      return '⚡';
    } else if (name.contains('cubbles') || name.contains('game')) {
      return '😍';
    } else if (name.contains('ui8') || name.contains('platform')) {
      return '🤓';
    } else {
      return '💡';
    }
  }

  static String _getCategoryFromDescription(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('flutter') || desc.contains('learning') || desc.contains('development')) {
      return 'Development';
    } else if (desc.contains('migration') || desc.contains('ios') || desc.contains('swiftui')) {
      return 'Migration';
    } else if (desc.contains('marketing') || desc.contains('brand') || desc.contains('campaign')) {
      return 'Marketing';
    } else if (desc.contains('productivity') || desc.contains('utility') || desc.contains('personal')) {
      return 'Tools';
    } else {
      return 'General';
    }
  }

  static List<String> _getTeamAvatars(List<User> members) {
    return members.map((user) => user.avatarUrl ?? '').where((url) => url.isNotEmpty).toList();
  }

  static Color _getProgressColor(double percentage) {
    if (percentage < 0.3) {
      return AppColors.orange; // Low progress
    } else if (percentage < 0.7) {
      return AppColors.blue; // Medium progress
    } else {
      return AppColors.green; // High progress
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        teamName,
        emoji,
        teamAvatars,
        progress,
        progressPercentage,
        progressColor,
      ];
}