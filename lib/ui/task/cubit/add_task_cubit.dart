import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/user.dart';
import '../view_model/add_task_form_model.dart';
import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(const AddTaskInitial());

  final AddTaskFormModel _formModel = AddTaskFormModel();

  AddTaskFormModel get formModel => _formModel;

  void updateTaskName(String taskName) {
    _formModel.taskName = taskName;
  }

  void updateSelectedDate(DateTime date) {
    _formModel.selectedDate = date;
  }

  void updateStartTime(String startTime) {
    _formModel.startTime = startTime;
  }

  void updateEndTime(String endTime) {
    _formModel.endTime = endTime;
  }

  void updateBoardStatus(BoardStatus status) {
    _formModel.boardStatus = status;
  }

  void addTeamMember(User user) {
    if (!_formModel.selectedMembers.contains(user)) {
      _formModel.selectedMembers.add(user);
    }
  }

  void removeTeamMember(User user) {
    _formModel.selectedMembers.remove(user);
  }

  void toggleTeamMember(User user) {
    if (_formModel.selectedMembers.contains(user)) {
      removeTeamMember(user);
    } else {
      addTeamMember(user);
    }
  }

  bool isFormValid() {
    return _formModel.taskName.trim().isNotEmpty &&
           _formModel.selectedDate != null;
  }

  String? validateTaskName() {
    if (_formModel.taskName.trim().isEmpty) {
      return 'Task name is required';
    }
    if (_formModel.taskName.trim().length < 3) {
      return 'Task name must be at least 3 characters';
    }
    if (_formModel.taskName.length > 100) {
      return 'Task name must be less than 100 characters';
    }
    return null;
  }

  String? validateDate() {
    if (_formModel.selectedDate == null) {
      return 'Date is required';
    }
    return null;
  }

  String? validateTimeRange() {
    if (_formModel.startTime.isNotEmpty && _formModel.endTime.isNotEmpty) {
      final startTime = _parseTime(_formModel.startTime);
      final endTime = _parseTime(_formModel.endTime);
      
      if (startTime != null && endTime != null) {
        final startMinutes = startTime.hour * 60 + startTime.minute;
        final endMinutes = endTime.hour * 60 + endTime.minute;
        
        if (startMinutes >= endMinutes) {
          return 'End time must be after start time';
        }
      }
    }
    return null;
  }

  String? getFirstValidationError() {
    return validateTaskName() ?? validateDate() ?? validateTimeRange();
  }

  TimeOfDay? _parseTime(String timeString) {
    if (timeString.isEmpty) return null;
    
    try {
      final parts = timeString.split(' ');
      if (parts.length != 2) return null;
      
      final timePart = parts[0];
      final amPm = parts[1].toLowerCase();
      
      final timeComponents = timePart.split(':');
      if (timeComponents.length != 2) return null;
      
      int hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);
      
      if (amPm == 'pm' && hour != 12) {
        hour += 12;
      } else if (amPm == 'am' && hour == 12) {
        hour = 0;
      }
      
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  Future<void> createTask() async {
    final validationError = getFirstValidationError();
    if (validationError != null) {
      emit(AddTaskError(message: validationError));
      return;
    }

    emit(const AddTaskLoading());

    try {
      // TODO: Implement task creation with repository
      // For now, simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Create task from form model
      final task = _formModel.toTask();
      
      // TODO: Call repository to save task
      // await taskRepository.createTask(task);
      
      emit(const AddTaskSuccess());
    } catch (e) {
      emit(AddTaskError(message: 'Failed to create task: ${e.toString()}'));
    }
  }

  void reset() {
    _formModel.reset();
    emit(const AddTaskInitial());
  }
}