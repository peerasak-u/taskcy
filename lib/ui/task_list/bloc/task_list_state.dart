import 'package:equatable/equatable.dart';

import '../view_model/task_list_view_model.dart';

enum TaskListViewMode { timeline, calendar }

abstract class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object?> get props => [];
}

class TaskListInitial extends TaskListState {
  const TaskListInitial();
}

class TaskListLoading extends TaskListState {
  const TaskListLoading();
}

class TaskListLoaded extends TaskListState {
  final TaskListViewModel taskListData;

  const TaskListLoaded({
    required this.taskListData,
  });

  @override
  List<Object?> get props => [taskListData];
}

class TaskListError extends TaskListState {
  final String message;

  const TaskListError({required this.message});

  @override
  List<Object?> get props => [message];
}