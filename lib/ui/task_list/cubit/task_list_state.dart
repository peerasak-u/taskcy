import 'package:equatable/equatable.dart';

import '../view_model/task_list_item_view_model.dart';
import '../view_model/task_list_view_model.dart';

enum TaskListViewMode { timeline, calendar }

abstract class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object?> get props => [];
}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListLoaded extends TaskListState {
  final TaskListViewModel taskListData;

  const TaskListLoaded({
    required this.taskListData,
  });

  TaskListLoaded copyWith({
    TaskListViewMode? viewMode,
    DateTime? selectedDate,
    String? taskType,
    List<TaskListItemViewModel>? tasks,
    Map<DateTime, int>? taskCountsByDate,
    int? totalTasksToday,
    bool? isLoading,
  }) {
    return TaskListLoaded(
      taskListData: taskListData.copyWith(
        viewMode: viewMode,
        selectedDate: selectedDate,
        taskType: taskType,
        tasks: tasks,
        taskCountsByDate: taskCountsByDate,
        totalTasksToday: totalTasksToday,
        isLoading: isLoading,
      ),
    );
  }

  @override
  List<Object?> get props => [taskListData];
}