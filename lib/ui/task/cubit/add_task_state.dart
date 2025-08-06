import 'package:equatable/equatable.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/user.dart';
import '../view_model/add_task_form_model.dart';

abstract class AddTaskState extends Equatable {
  const AddTaskState();

  @override
  List<Object?> get props => [];
}

class AddTaskInitial extends AddTaskState {
  const AddTaskInitial();
}

class AddTaskLoading extends AddTaskState {
  const AddTaskLoading();
}

class AddTaskReady extends AddTaskState {
  final AddTaskFormModel formModel;
  final List<Project> availableProjects;
  final List<User> availableUsers;

  const AddTaskReady({
    required this.formModel,
    required this.availableProjects,
    required this.availableUsers,
  });

  AddTaskReady copyWith({
    AddTaskFormModel? formModel,
    List<Project>? availableProjects,
    List<User>? availableUsers,
  }) {
    return AddTaskReady(
      formModel: formModel ?? this.formModel,
      availableProjects: availableProjects ?? this.availableProjects,
      availableUsers: availableUsers ?? this.availableUsers,
    );
  }

  @override
  List<Object?> get props => [formModel, availableProjects, availableUsers];
}

class AddTaskInvalidate extends AddTaskState {
  final AddTaskFormModel formModel;
  final List<Project> availableProjects;
  final List<User> availableUsers;
  final String errorMessage;

  const AddTaskInvalidate({
    required this.formModel,
    required this.availableProjects,
    required this.availableUsers,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [formModel, availableProjects, availableUsers, errorMessage];
}

class AddTaskSubmitting extends AddTaskState {
  final AddTaskFormModel formModel;
  final List<Project> availableProjects;
  final List<User> availableUsers;

  const AddTaskSubmitting({
    required this.formModel,
    required this.availableProjects,
    required this.availableUsers,
  });

  @override
  List<Object?> get props => [formModel, availableProjects, availableUsers];
}

class AddTaskSuccess extends AddTaskState {
  const AddTaskSuccess();
}

class AddTaskFailed extends AddTaskState {
  final String message;
  final AddTaskFormModel formModel;
  final List<Project> availableProjects;
  final List<User> availableUsers;

  const AddTaskFailed({
    required this.message,
    required this.formModel,
    required this.availableProjects,
    required this.availableUsers,
  });

  @override
  List<Object?> get props => [message, formModel, availableProjects, availableUsers];
}