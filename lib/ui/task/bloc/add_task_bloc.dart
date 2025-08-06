import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/user.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../view_model/add_task_form_model.dart';
import 'add_task_event.dart';
import 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  final TaskRepository _taskRepository;
  final ProjectRepository _projectRepository;
  final UserRepository _userRepository;

  late AddTaskFormModel _formModel;
  late List<Project> _availableProjects;
  late List<User> _availableUsers;

  AddTaskBloc({
    required TaskRepository taskRepository,
    required ProjectRepository projectRepository,
    required UserRepository userRepository,
  })  : _taskRepository = taskRepository,
        _projectRepository = projectRepository,
        _userRepository = userRepository,
        super(const AddTaskInitial()) {
    
    _formModel = const AddTaskFormModel();
    _availableProjects = [];
    _availableUsers = [];

    on<LoadInitialData>(_onLoadInitialData);
    on<UpdateTaskName>(_onUpdateTaskName);
    on<SelectProject>(_onSelectProject);
    on<UpdateDescription>(_onUpdateDescription);
    on<ToggleTeamMember>(_onToggleTeamMember);
    on<UpdateSelectedDate>(_onUpdateSelectedDate);
    on<UpdateStartTime>(_onUpdateStartTime);
    on<UpdateEndTime>(_onUpdateEndTime);
    on<UpdateBoardStatus>(_onUpdateBoardStatus);
    on<SubmitTask>(_onSubmitTask);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<AddTaskState> emit,
  ) async {
    try {
      emit(const AddTaskLoading());

      final futures = await Future.wait([
        _projectRepository.getProjects(perPage: 50),
        _userRepository.getUsers(perPage: 50),
      ]);

      _availableProjects = futures[0] as List<Project>;
      _availableUsers = futures[1] as List<User>;
      _formModel = const AddTaskFormModel();

      emit(AddTaskReady(
        formModel: _formModel,
        availableProjects: _availableProjects,
        availableUsers: _availableUsers,
      ));
    } catch (error) {
      emit(AddTaskFailed(
        message: 'Failed to load data: ${error.toString()}',
        formModel: _formModel,
        availableProjects: const [],
        availableUsers: const [],
      ));
    }
  }

  void _onUpdateTaskName(
    UpdateTaskName event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(taskName: event.taskName);
    _emitUpdatedState(emit);
  }

  void _onSelectProject(
    SelectProject event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(selectedProject: event.project);
    _emitUpdatedState(emit);
  }

  void _onUpdateDescription(
    UpdateDescription event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(description: event.description);
    _emitUpdatedState(emit);
  }

  void _onToggleTeamMember(
    ToggleTeamMember event,
    Emitter<AddTaskState> emit,
  ) {
    final currentMembers = List<User>.from(_formModel.selectedMembers);
    if (currentMembers.contains(event.user)) {
      currentMembers.remove(event.user);
    } else {
      currentMembers.add(event.user);
    }
    _formModel = _formModel.copyWith(selectedMembers: currentMembers);
    _emitUpdatedState(emit);
  }

  void _onUpdateSelectedDate(
    UpdateSelectedDate event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(selectedDate: event.date);
    _emitUpdatedState(emit);
  }

  void _onUpdateStartTime(
    UpdateStartTime event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(startTime: event.startTime);
    _emitUpdatedState(emit);
  }

  void _onUpdateEndTime(
    UpdateEndTime event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(endTime: event.endTime);
    _emitUpdatedState(emit);
  }

  void _onUpdateBoardStatus(
    UpdateBoardStatus event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = _formModel.copyWith(boardStatus: event.status);
    _emitUpdatedState(emit);
  }

  Future<void> _onSubmitTask(
    SubmitTask event,
    Emitter<AddTaskState> emit,
  ) async {
    final validationError = _validateForm();
    if (validationError != null) {
      emit(AddTaskInvalidate(
        formModel: _formModel,
        availableProjects: _availableProjects,
        availableUsers: _availableUsers,
        errorMessage: validationError,
      ));
      return;
    }

    emit(AddTaskSubmitting(
      formModel: _formModel,
      availableProjects: _availableProjects,
      availableUsers: _availableUsers,
    ));

    try {
      final task = _formModel.toTask();
      
      await _taskRepository.createTask(
        title: task.title,
        description: task.description,
        status: task.status,
        priority: task.priority,
        projectId: task.projectId,
        assigneeIds: task.assignees.map((user) => user.id).toList(),
        dueDate: task.dueDate,
      );
      
      emit(const AddTaskSuccess());
    } catch (error) {
      emit(AddTaskFailed(
        message: 'Failed to create task: ${error.toString()}',
        formModel: _formModel,
        availableProjects: _availableProjects,
        availableUsers: _availableUsers,
      ));
    }
  }

  void _onResetForm(
    ResetForm event,
    Emitter<AddTaskState> emit,
  ) {
    _formModel = const AddTaskFormModel();
    emit(AddTaskReady(
      formModel: _formModel,
      availableProjects: _availableProjects,
      availableUsers: _availableUsers,
    ));
  }

  void _emitUpdatedState(Emitter<AddTaskState> emit) {
    emit(AddTaskReady(
      formModel: _formModel,
      availableProjects: _availableProjects,
      availableUsers: _availableUsers,
    ));
  }

  String? _validateForm() {
    if (_formModel.taskName.trim().isEmpty) {
      return 'Task name is required';
    }
    if (_formModel.taskName.trim().length < 3) {
      return 'Task name must be at least 3 characters';
    }
    if (_formModel.taskName.length > 100) {
      return 'Task name must be less than 100 characters';
    }
    if (_formModel.selectedProject == null) {
      return 'Please select a project';
    }
    if (_formModel.selectedDate == null) {
      return 'Date is required';
    }
    
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
}