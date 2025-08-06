import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/task.dart';
import '../../../domain/models/user.dart';
import '../../core/theme/app_colors.dart';

class TaskListItemViewModel extends Equatable {
  final String id;
  final String title;
  final String projectName;
  final TaskPriority priority;
  final TaskStatus status;
  final List<String> assigneeAvatars;
  final String formattedTime;
  final String timeRangeText;
  final Color priorityColor;
  final Color progressColor;
  final String statusEmoji;
  final DateTime? dueDate;
  final Duration? duration;
  final bool hasTimeRange;

  const TaskListItemViewModel({
    required this.id,
    required this.title,
    required this.projectName,
    required this.priority,
    required this.status,
    required this.assigneeAvatars,
    required this.formattedTime,
    required this.timeRangeText,
    required this.priorityColor,
    required this.progressColor,
    required this.statusEmoji,
    this.dueDate,
    this.duration,
    this.hasTimeRange = false,
  });

  factory TaskListItemViewModel.fromTask({
    required Task task,
    String projectName = 'Unknown Project',
  }) {
    final priorityColor = _getPriorityColor(task.priority);
    final progressColor = _getProgressColor(task.status);
    final statusEmoji = _getStatusEmoji(task);
    final formattedTime = _getFormattedTime(task.dueDate);
    final timeRangeText = _getTimeRangeText(task);
    final duration = _getTaskDuration(task);
    final assigneeAvatars = _getAssigneeAvatars(task.assignees);
    final hasTimeRange = task.dueDate != null;

    return TaskListItemViewModel(
      id: task.id,
      title: task.title,
      projectName: projectName,
      priority: task.priority,
      status: task.status,
      assigneeAvatars: assigneeAvatars,
      formattedTime: formattedTime,
      timeRangeText: timeRangeText,
      priorityColor: priorityColor,
      progressColor: progressColor,
      statusEmoji: statusEmoji,
      dueDate: task.dueDate,
      duration: duration,
      hasTimeRange: hasTimeRange,
    );
  }

  static Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return AppColors.orange;
      case TaskPriority.high:
        return AppColors.blue;
      case TaskPriority.medium:
        return AppColors.green;
      case TaskPriority.low:
        return AppColors.textSecondary;
    }
  }

  static Color _getProgressColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return AppColors.green;
      case TaskStatus.inProgress:
        return AppColors.blue;
      case TaskStatus.todo:
        return AppColors.textSecondary;
    }
  }

  static String _getStatusEmoji(Task task) {
    final title = task.title.toLowerCase();
    if (title.contains('wireframe') || title.contains('design')) {
      return '🔥';
    } else if (title.contains('call') || title.contains('meeting')) {
      return '📞';
    } else if (title.contains('research') || title.contains('analysis')) {
      return '🔍';
    } else if (title.contains('develop') || title.contains('implement')) {
      return '💻';
    } else {
      return '⭐';
    }
  }

  static String _getFormattedTime(DateTime? dueDate) {
    if (dueDate == null) return '';
    return DateFormat('h:mma').format(dueDate).toLowerCase();
  }

  static String _getTimeRangeText(Task task) {
    if (task.dueDate == null) return '';
    
    final startTime = DateFormat('h:mma').format(task.dueDate!).toLowerCase();
    final endTime = _getTaskEndTime(task);
    final endTimeFormatted = DateFormat('h:mma').format(endTime).toLowerCase();
    
    return '$startTime - $endTimeFormatted';
  }

  static DateTime _getTaskEndTime(Task task) {
    if (task.dueDate == null) return DateTime.now();
    
    Duration duration;
    final title = task.title.toLowerCase();
    
    if (title.contains('call') || title.contains('meeting')) {
      duration = const Duration(minutes: 30);
    } else if (title.contains('wireframe')) {
      duration = const Duration(hours: 1, minutes: 30);
    } else {
      duration = const Duration(hours: 1);
    }
    
    return task.dueDate!.add(duration);
  }

  static Duration? _getTaskDuration(Task task) {
    if (task.dueDate == null) return null;
    
    final endTime = _getTaskEndTime(task);
    return endTime.difference(task.dueDate!);
  }

  static List<String> _getAssigneeAvatars(List<User> assignees) {
    return assignees
        .map((user) => user.avatarUrl ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  String get priorityText {
    switch (priority) {
      case TaskPriority.urgent:
        return 'Urgent';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  String get statusText {
    switch (status) {
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.todo:
        return 'To Do';
    }
  }

  bool get isCompleted => status == TaskStatus.completed;
  bool get isInProgress => status == TaskStatus.inProgress;
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && !isCompleted;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    projectName,
    priority,
    status,
    assigneeAvatars,
    formattedTime,
    timeRangeText,
    priorityColor,
    progressColor,
    statusEmoji,
    dueDate,
    duration,
    hasTimeRange,
  ];
}