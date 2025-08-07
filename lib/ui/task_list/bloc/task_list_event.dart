import 'package:equatable/equatable.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object?> get props => [];
}

class InitializeTaskList extends TaskListEvent {
  final String taskType;
  final DateTime? initialDate;

  const InitializeTaskList({
    required this.taskType,
    this.initialDate,
  });

  @override
  List<Object?> get props => [taskType, initialDate];
}

class ToggleViewMode extends TaskListEvent {
  const ToggleViewMode();
}

class ToggleTaskType extends TaskListEvent {
  const ToggleTaskType();
}

class SelectDate extends TaskListEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class NavigateToMonth extends TaskListEvent {
  final DateTime newMonth;

  const NavigateToMonth(this.newMonth);

  @override
  List<Object?> get props => [newMonth];
}

class UpdateTaskType extends TaskListEvent {
  final String taskType;

  const UpdateTaskType(this.taskType);

  @override
  List<Object?> get props => [taskType];
}

class RefreshTaskList extends TaskListEvent {
  const RefreshTaskList();
}