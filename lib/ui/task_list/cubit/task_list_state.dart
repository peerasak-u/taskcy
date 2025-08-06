import 'package:equatable/equatable.dart';

enum TaskListViewMode { timeline, calendar }

abstract class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object?> get props => [];
}

class TaskListInitial extends TaskListState {}

class TaskListLoaded extends TaskListState {
  final TaskListViewMode viewMode;
  final DateTime selectedDate;
  final String taskType;

  const TaskListLoaded({
    required this.viewMode,
    required this.selectedDate,
    required this.taskType,
  });

  TaskListLoaded copyWith({
    TaskListViewMode? viewMode,
    DateTime? selectedDate,
    String? taskType,
  }) {
    return TaskListLoaded(
      viewMode: viewMode ?? this.viewMode,
      selectedDate: selectedDate ?? this.selectedDate,
      taskType: taskType ?? this.taskType,
    );
  }

  @override
  List<Object?> get props => [viewMode, selectedDate, taskType];
}