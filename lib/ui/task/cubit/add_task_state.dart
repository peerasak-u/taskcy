import 'package:equatable/equatable.dart';

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

class AddTaskSuccess extends AddTaskState {
  const AddTaskSuccess();
}

class AddTaskError extends AddTaskState {
  final String message;

  const AddTaskError({required this.message});

  @override
  List<Object?> get props => [message];
}