import 'package:equatable/equatable.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/user.dart';
import '../view_model/add_task_form_model.dart';

abstract class AddTaskEvent extends Equatable {
  const AddTaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends AddTaskEvent {
  const LoadInitialData();
}

class UpdateTaskName extends AddTaskEvent {
  final String taskName;

  const UpdateTaskName(this.taskName);

  @override
  List<Object?> get props => [taskName];
}

class SelectProject extends AddTaskEvent {
  final Project project;

  const SelectProject(this.project);

  @override
  List<Object?> get props => [project];
}

class UpdateDescription extends AddTaskEvent {
  final String description;

  const UpdateDescription(this.description);

  @override
  List<Object?> get props => [description];
}

class ToggleTeamMember extends AddTaskEvent {
  final User user;

  const ToggleTeamMember(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateSelectedDate extends AddTaskEvent {
  final DateTime date;

  const UpdateSelectedDate(this.date);

  @override
  List<Object?> get props => [date];
}

class UpdateStartTime extends AddTaskEvent {
  final String startTime;

  const UpdateStartTime(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class UpdateEndTime extends AddTaskEvent {
  final String endTime;

  const UpdateEndTime(this.endTime);

  @override
  List<Object?> get props => [endTime];
}

class UpdateBoardStatus extends AddTaskEvent {
  final BoardStatus status;

  const UpdateBoardStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SubmitTask extends AddTaskEvent {
  const SubmitTask();
}

class ResetForm extends AddTaskEvent {
  const ResetForm();
}