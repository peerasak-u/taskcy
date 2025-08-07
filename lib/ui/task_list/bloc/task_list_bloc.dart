import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/task_repository.dart';
import '../view_model/task_list_view_model.dart';
import 'task_list_event.dart';
import 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository _taskRepository;

  TaskListBloc(this._taskRepository) : super(const TaskListInitial()) {
    on<InitializeTaskList>(_onInitializeTaskList);
    on<ToggleViewMode>(_onToggleViewMode);
    on<ToggleTaskType>(_onToggleTaskType);
    on<SelectDate>(_onSelectDate);
    on<NavigateToMonth>(_onNavigateToMonth);
    on<UpdateTaskType>(_onUpdateTaskType);
    on<RefreshTaskList>(_onRefreshTaskList);
  }

  Future<void> _onInitializeTaskList(
    InitializeTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    emit(const TaskListLoading());
    
    final selectedDate = event.initialDate ?? DateTime.now();
    final today = DateTime.now();
    
    try {
      await _loadDataForDate(selectedDate, event.taskType, today, emit);
    } catch (e) {
      final viewModel = TaskListViewModel.fromTaskListState(
        viewMode: event.taskType == 'today' ? TaskListViewMode.timeline : TaskListViewMode.calendar,
        selectedDate: selectedDate,
        taskType: event.taskType,
        tasks: const [],
        taskCountsByDate: const {},
        totalTasksToday: 0,
        isLoading: false,
      );
      emit(TaskListLoaded(taskListData: viewModel));
    }
  }

  Future<void> _onToggleViewMode(
    ToggleViewMode event,
    Emitter<TaskListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      final newViewMode = currentState.taskListData.viewMode == TaskListViewMode.timeline
          ? TaskListViewMode.calendar
          : TaskListViewMode.timeline;
      
      emit(TaskListLoaded(
        taskListData: currentState.taskListData.copyWith(
          viewMode: newViewMode,
          isLoading: true,
        ),
      ));
      
      try {
        if (newViewMode == TaskListViewMode.calendar) {
          await _loadMonthData(currentState.taskListData.selectedDate, emit);
        }
        
        emit(TaskListLoaded(
          taskListData: currentState.taskListData.copyWith(
            viewMode: newViewMode,
            isLoading: false,
          ),
        ));
      } catch (e) {
        emit(TaskListError(message: 'Failed to switch view mode: ${e.toString()}'));
      }
    }
  }

  Future<void> _onToggleTaskType(
    ToggleTaskType event,
    Emitter<TaskListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      final newTaskType = currentState.taskListData.taskType == 'today' ? 'monthly' : 'today';
      final newViewMode = newTaskType == 'today' 
          ? TaskListViewMode.timeline 
          : TaskListViewMode.calendar;
      
      emit(TaskListLoaded(
        taskListData: currentState.taskListData.copyWith(
          taskType: newTaskType,
          viewMode: newViewMode,
          isLoading: true,
        ),
      ));

      try {
        final today = DateTime.now();
        await _loadDataForDate(currentState.taskListData.selectedDate, newTaskType, today, emit);
      } catch (e) {
        emit(TaskListError(message: 'Failed to toggle task type: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<TaskListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      emit(TaskListLoaded(
        taskListData: currentState.taskListData.copyWith(
          selectedDate: event.date,
          isLoading: true,
        ),
      ));
      
      try {
        final today = DateTime.now();
        await _loadDataForDate(event.date, currentState.taskListData.taskType, today, emit);
      } catch (e) {
        emit(TaskListError(message: 'Failed to load data for selected date: ${e.toString()}'));
      }
    }
  }

  Future<void> _onNavigateToMonth(
    NavigateToMonth event,
    Emitter<TaskListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      final currentDay = currentState.taskListData.selectedDate.day;
      final lastDayOfNewMonth = DateTime(event.newMonth.year, event.newMonth.month + 1, 0).day;
      final newDay = currentDay <= lastDayOfNewMonth ? currentDay : 1;
      
      final newSelectedDate = DateTime(event.newMonth.year, event.newMonth.month, newDay);
      
      emit(TaskListLoaded(
        taskListData: currentState.taskListData.copyWith(
          selectedDate: newSelectedDate,
          isLoading: true,
        ),
      ));
      
      try {
        final today = DateTime.now();
        await _loadDataForDate(newSelectedDate, currentState.taskListData.taskType, today, emit);
      } catch (e) {
        emit(TaskListError(message: 'Failed to navigate to month: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateTaskType(
    UpdateTaskType event,
    Emitter<TaskListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      emit(TaskListLoaded(
        taskListData: currentState.taskListData.copyWith(
          taskType: event.taskType,
          isLoading: true,
        ),
      ));
      
      try {
        final today = DateTime.now();
        await _loadDataForDate(currentState.taskListData.selectedDate, event.taskType, today, emit);
      } catch (e) {
        emit(TaskListError(message: 'Failed to update task type: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshTaskList(
    RefreshTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      debugPrint('🔄 TaskListBloc: Refreshing task list for date: ${currentState.taskListData.selectedDate}');
      
      emit(TaskListLoaded(
        taskListData: currentState.taskListData.copyWith(isLoading: true),
      ));
      
      try {
        final today = DateTime.now();
        await _loadDataForDate(
          currentState.taskListData.selectedDate,
          currentState.taskListData.taskType,
          today,
          emit,
        );
      } catch (e) {
        emit(TaskListError(message: 'Failed to refresh task list: ${e.toString()}'));
      }
    }
  }

  Future<void> _loadDataForDate(
    DateTime selectedDate,
    String taskType,
    DateTime today,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final tasksForDate = await _taskRepository.getTasksForDate(selectedDate);
      
      final todayTasks = await _taskRepository.getTasksForDate(today);
      final totalTasksToday = todayTasks.length;
      
      Map<DateTime, int> taskCountsByDate = {};
      if (taskType == 'monthly') {
        final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
        final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        taskCountsByDate = await _taskRepository.getTaskCountsByDateRange(firstDayOfMonth, lastDayOfMonth);
      }

      final viewModel = TaskListViewModel.fromTaskListState(
        viewMode: taskType == 'today' ? TaskListViewMode.timeline : TaskListViewMode.calendar,
        selectedDate: selectedDate,
        taskType: taskType,
        tasks: tasksForDate,
        taskCountsByDate: taskCountsByDate,
        totalTasksToday: totalTasksToday,
        isLoading: false,
      );
      
      emit(TaskListLoaded(taskListData: viewModel));
    } catch (e) {
      final currentState = state;
      if (currentState is TaskListLoaded) {
        emit(TaskListLoaded(
          taskListData: currentState.taskListData.copyWith(isLoading: false),
        ));
      } else {
        emit(TaskListError(message: 'Failed to load task data: ${e.toString()}'));
      }
    }
  }

  Future<void> _loadMonthData(
    DateTime date,
    Emitter<TaskListState> emit,
  ) async {
    try {
      final firstDayOfMonth = DateTime(date.year, date.month, 1);
      final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
      final taskCountsByDate = await _taskRepository.getTaskCountsByDateRange(firstDayOfMonth, lastDayOfMonth);
      
      final currentState = state;
      if (currentState is TaskListLoaded) {
        emit(TaskListLoaded(
          taskListData: currentState.taskListData.copyWith(taskCountsByDate: taskCountsByDate),
        ));
      }
    } catch (e) {
      // Handle error silently for month data - same as original implementation
    }
  }
}