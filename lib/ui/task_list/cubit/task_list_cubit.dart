import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/task_repository.dart';
import 'task_list_state.dart';

class TaskListCubit extends Cubit<TaskListState> {
  final TaskRepository _taskRepository;

  TaskListCubit(this._taskRepository) : super(TaskListInitial());

  Future<void> initialize({required String taskType, DateTime? initialDate}) async {
    emit(TaskListLoading());
    
    final selectedDate = initialDate ?? DateTime.now();
    final today = DateTime.now();
    
    try {
      // Load initial data
      await _loadDataForDate(selectedDate, taskType, today);
    } catch (e) {
      // If data loading fails, still show the UI with empty state
      emit(TaskListLoaded(
        viewMode: taskType == 'today' ? TaskListViewMode.timeline : TaskListViewMode.calendar,
        selectedDate: selectedDate,
        taskType: taskType,
      ));
    }
  }

  Future<void> toggleViewMode() async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      final newViewMode = currentState.viewMode == TaskListViewMode.timeline
          ? TaskListViewMode.calendar
          : TaskListViewMode.timeline;
      
      emit(currentState.copyWith(viewMode: newViewMode, isLoading: true));
      
      // If switching to calendar view, load month data
      if (newViewMode == TaskListViewMode.calendar) {
        await _loadMonthData(currentState.selectedDate);
      }
      
      emit(currentState.copyWith(viewMode: newViewMode, isLoading: false));
    }
  }

  Future<void> toggleTaskType() async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      final newTaskType = currentState.taskType == 'today' ? 'monthly' : 'today';
      final newViewMode = newTaskType == 'today' 
          ? TaskListViewMode.timeline 
          : TaskListViewMode.calendar;
      
      emit(currentState.copyWith(
        taskType: newTaskType,
        viewMode: newViewMode,
        isLoading: true,
      ));

      final today = DateTime.now();
      await _loadDataForDate(currentState.selectedDate, newTaskType, today);
    }
  }

  Future<void> selectDate(DateTime date) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      emit(currentState.copyWith(selectedDate: date, isLoading: true));
      
      final today = DateTime.now();
      await _loadDataForDate(date, currentState.taskType, today);
    }
  }

  Future<void> navigateToMonth(DateTime newMonth) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      // Keep the same day if possible, otherwise use day 1
      final currentDay = currentState.selectedDate.day;
      final lastDayOfNewMonth = DateTime(newMonth.year, newMonth.month + 1, 0).day;
      final newDay = currentDay <= lastDayOfNewMonth ? currentDay : 1;
      
      final newSelectedDate = DateTime(newMonth.year, newMonth.month, newDay);
      
      emit(currentState.copyWith(selectedDate: newSelectedDate, isLoading: true));
      
      final today = DateTime.now();
      await _loadDataForDate(newSelectedDate, currentState.taskType, today);
    }
  }

  Future<void> updateTaskType(String taskType) async {
    final currentState = state;
    if (currentState is TaskListLoaded) {
      emit(currentState.copyWith(taskType: taskType, isLoading: true));
      
      final today = DateTime.now();
      await _loadDataForDate(currentState.selectedDate, taskType, today);
    }
  }

  Future<void> _loadDataForDate(DateTime selectedDate, String taskType, DateTime today) async {
    try {
      // Load tasks for selected date
      final tasksForDate = await _taskRepository.getTasksForDate(selectedDate);
      
      // Load today's task count
      final todayTasks = await _taskRepository.getTasksForDate(today);
      final totalTasksToday = todayTasks.length;
      
      // Load task counts for the current month (for calendar highlighting)
      Map<DateTime, int> taskCountsByDate = {};
      if (taskType == 'monthly') {
        final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
        final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        taskCountsByDate = await _taskRepository.getTaskCountsByDateRange(firstDayOfMonth, lastDayOfMonth);
      }

      final currentState = state;
      if (currentState is TaskListLoaded) {
        emit(currentState.copyWith(
          selectedDate: selectedDate,
          taskType: taskType,
          tasksForSelectedDate: tasksForDate,
          taskCountsByDate: taskCountsByDate,
          totalTasksToday: totalTasksToday,
          isLoading: false,
          viewMode: taskType == 'today' ? TaskListViewMode.timeline : TaskListViewMode.calendar,
        ));
      } else {
        emit(TaskListLoaded(
          viewMode: taskType == 'today' ? TaskListViewMode.timeline : TaskListViewMode.calendar,
          selectedDate: selectedDate,
          taskType: taskType,
          tasksForSelectedDate: tasksForDate,
          taskCountsByDate: taskCountsByDate,
          totalTasksToday: totalTasksToday,
          isLoading: false,
        ));
      }
    } catch (e) {
      final currentState = state;
      if (currentState is TaskListLoaded) {
        emit(currentState.copyWith(isLoading: false));
      }
    }
  }

  Future<void> _loadMonthData(DateTime date) async {
    try {
      final firstDayOfMonth = DateTime(date.year, date.month, 1);
      final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
      final taskCountsByDate = await _taskRepository.getTaskCountsByDateRange(firstDayOfMonth, lastDayOfMonth);
      
      final currentState = state;
      if (currentState is TaskListLoaded) {
        emit(currentState.copyWith(taskCountsByDate: taskCountsByDate));
      }
    } catch (e) {
      // Handle error silently for month data
    }
  }
}