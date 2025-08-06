import 'package:equatable/equatable.dart';

import '../../../domain/models/task.dart';

enum TaskListViewMode { timeline, calendar }

abstract class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object?> get props => [];
}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListLoaded extends TaskListState {
  final TaskListViewMode viewMode;
  final DateTime selectedDate;
  final String taskType;
  final List<Task> tasksForSelectedDate;
  final Map<DateTime, int> taskCountsByDate;
  final int totalTasksToday;
  final bool isLoading;

  const TaskListLoaded({
    required this.viewMode,
    required this.selectedDate,
    required this.taskType,
    this.tasksForSelectedDate = const [],
    this.taskCountsByDate = const {},
    this.totalTasksToday = 0,
    this.isLoading = false,
  });

  TaskListLoaded copyWith({
    TaskListViewMode? viewMode,
    DateTime? selectedDate,
    String? taskType,
    List<Task>? tasksForSelectedDate,
    Map<DateTime, int>? taskCountsByDate,
    int? totalTasksToday,
    bool? isLoading,
  }) {
    return TaskListLoaded(
      viewMode: viewMode ?? this.viewMode,
      selectedDate: selectedDate ?? this.selectedDate,
      taskType: taskType ?? this.taskType,
      tasksForSelectedDate: tasksForSelectedDate ?? this.tasksForSelectedDate,
      taskCountsByDate: taskCountsByDate ?? this.taskCountsByDate,
      totalTasksToday: totalTasksToday ?? this.totalTasksToday,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        viewMode, 
        selectedDate, 
        taskType, 
        tasksForSelectedDate, 
        taskCountsByDate, 
        totalTasksToday,
        isLoading,
      ];
}