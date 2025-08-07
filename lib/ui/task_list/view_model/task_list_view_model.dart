import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/task.dart';
import '../bloc/task_list_state.dart';
import 'task_list_item_view_model.dart';

class TaskListViewModel extends Equatable {
  final TaskListViewMode viewMode;
  final DateTime selectedDate;
  final String taskType;
  final List<TaskListItemViewModel> tasks;
  final List<Task> rawTasks; // Keep raw tasks for compatibility
  final Map<DateTime, int> taskCountsByDate;
  final int totalTasksToday;
  final bool isLoading;
  final String formattedSelectedDate;
  final String taskSummaryText;

  const TaskListViewModel({
    required this.viewMode,
    required this.selectedDate,
    required this.taskType,
    required this.tasks,
    required this.rawTasks,
    required this.taskCountsByDate,
    required this.totalTasksToday,
    required this.isLoading,
    required this.formattedSelectedDate,
    required this.taskSummaryText,
  });

  factory TaskListViewModel.fromTaskListState({
    required TaskListViewMode viewMode,
    required DateTime selectedDate,
    required String taskType,
    required List<Task> tasks,
    required Map<DateTime, int> taskCountsByDate,
    required int totalTasksToday,
    required bool isLoading,
  }) {
    final taskViewModels = tasks
        .map((task) => TaskListItemViewModel.fromTask(
              task: task,
              projectName: _getProjectName(task),
            ))
        .toList();

    final formattedSelectedDate = DateFormat('MMMM, d').format(selectedDate);
    final taskSummaryText = _getTaskSummaryText(taskType, selectedDate, totalTasksToday, tasks.length);

    return TaskListViewModel(
      viewMode: viewMode,
      selectedDate: selectedDate,
      taskType: taskType,
      tasks: taskViewModels,
      rawTasks: tasks,
      taskCountsByDate: taskCountsByDate,
      totalTasksToday: totalTasksToday,
      isLoading: isLoading,
      formattedSelectedDate: formattedSelectedDate,
      taskSummaryText: taskSummaryText,
    );
  }

  static String _getProjectName(Task task) {
    // TODO: This should fetch project name from project repository
    // For now, return a placeholder based on projectId
    return 'Project ${task.projectId.substring(0, 1).toUpperCase()}${task.projectId.substring(1)}';
  }

  static String _getTaskSummaryText(String taskType, DateTime selectedDate, int totalTasksToday, int tasksForDate) {
    if (taskType == 'today') {
      final taskText = totalTasksToday == 1 ? 'task' : 'tasks';
      return '$totalTasksToday $taskText today';
    } else {
      final taskText = tasksForDate == 1 ? 'task' : 'tasks';
      final dateText = DateFormat('MMM d').format(selectedDate);
      return '$tasksForDate $taskText on $dateText';
    }
  }

  TaskListViewModel copyWith({
    TaskListViewMode? viewMode,
    DateTime? selectedDate,
    String? taskType,
    List<TaskListItemViewModel>? tasks,
    List<Task>? rawTasks,
    Map<DateTime, int>? taskCountsByDate,
    int? totalTasksToday,
    bool? isLoading,
  }) {
    return TaskListViewModel(
      viewMode: viewMode ?? this.viewMode,
      selectedDate: selectedDate ?? this.selectedDate,
      taskType: taskType ?? this.taskType,
      tasks: tasks ?? this.tasks,
      rawTasks: rawTasks ?? this.rawTasks,
      taskCountsByDate: taskCountsByDate ?? this.taskCountsByDate,
      totalTasksToday: totalTasksToday ?? this.totalTasksToday,
      isLoading: isLoading ?? this.isLoading,
      formattedSelectedDate: selectedDate != null 
          ? DateFormat('MMMM, d').format(selectedDate)
          : formattedSelectedDate,
      taskSummaryText: _getTaskSummaryText(
        taskType ?? this.taskType,
        selectedDate ?? this.selectedDate,
        totalTasksToday ?? this.totalTasksToday,
        tasks?.length ?? this.tasks.length,
      ),
    );
  }

  // Computed properties
  bool get isEmpty => tasks.isEmpty;
  
  bool get isTimelineView => viewMode == TaskListViewMode.timeline;
  
  bool get isCalendarView => viewMode == TaskListViewMode.calendar;
  
  bool get isTodayView => taskType == 'today';
  
  bool get isMonthlyView => taskType == 'monthly';

  String get screenTitle => taskType == 'today' ? 'Today Task' : 'Monthly Task';
  
  List<TaskListItemViewModel> get completedTasks => 
      tasks.where((task) => task.isCompleted).toList();
  
  List<TaskListItemViewModel> get inProgressTasks => 
      tasks.where((task) => task.isInProgress).toList();
  
  List<TaskListItemViewModel> get todoTasks => 
      tasks.where((task) => task.status == TaskStatus.todo).toList();
  
  List<TaskListItemViewModel> get overdueTasks => 
      tasks.where((task) => task.isOverdue).toList();

  int get completedTasksCount => completedTasks.length;
  int get inProgressTasksCount => inProgressTasks.length;
  int get todoTasksCount => todoTasks.length;
  int get overdueTasksCount => overdueTasks.length;

  double get completionPercentage {
    if (tasks.isEmpty) return 0.0;
    return completedTasksCount / tasks.length;
  }

  @override
  List<Object?> get props => [
    viewMode,
    selectedDate,
    taskType,
    tasks,
    rawTasks,
    taskCountsByDate,
    totalTasksToday,
    isLoading,
    formattedSelectedDate,
    taskSummaryText,
  ];
}