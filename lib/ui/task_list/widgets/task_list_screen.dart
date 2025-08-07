import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/task.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../../shared/widgets/loading_state_widget.dart';
import '../../shared/widgets/user_avatar_stack_widget.dart';
import '../cubit/task_list_cubit.dart';
import '../cubit/task_list_state.dart';

class TaskListScreen extends StatelessWidget {
  final String taskType;
  
  const TaskListScreen({
    super.key,
    required this.taskType,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize task list after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListCubit>().initialize(taskType: taskType);
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<TaskListCubit, TaskListState>(
          builder: (context, state) {
            if (state is TaskListLoaded) {
              return Column(
                children: [
                  _buildHeader(context, state),
                  _buildDateSection(context, state),
                  _buildDateStrip(context, state),
                  const SizedBox(height: 24),
                  Expanded(
                    child: state.taskListData.isLoading ? 
                      const LoadingStateWidget() : _buildContent(context, state),
                  ),
                ],
              );
            }
            return const LoadingStateWidget();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TaskListLoaded state) {
    final title = state.taskListData.taskType == 'today' ? 'Today Task' : 'Monthly Task';
    
    return HeaderWidget(
      centerText: title,
      leftIcon: Icons.arrow_back_ios,
      rightIcon: Icons.edit_outlined,
      onLeftTap: () => context.pop(),
      onRightTap: null,
    );
  }

  Widget _buildDateSection(BuildContext context, TaskListLoaded state) {
    final formattedDate = DateFormat('MMMM, d').format(state.taskListData.selectedDate);
    final taskCount = state.taskListData.taskType == 'today' 
        ? state.taskListData.totalTasksToday 
        : state.taskListData.tasks.length;
    final taskText = taskCount == 1 ? 'task' : 'tasks';
    final displayText = state.taskListData.taskType == 'today' 
        ? '$taskCount $taskText today'
        : '$taskCount $taskText on ${DateFormat('MMM d').format(state.taskListData.selectedDate)}';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$formattedDate ✍️',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.read<TaskListCubit>().toggleTaskType(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                state.taskListData.viewMode == TaskListViewMode.calendar 
                    ? Icons.view_agenda 
                    : Icons.calendar_month,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStrip(BuildContext context, TaskListLoaded state) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: _DateStripWidget(
        selectedDate: state.taskListData.selectedDate,
        onDateSelected: (date) {
          context.read<TaskListCubit>().selectDate(date);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskListLoaded state) {
    if (state.taskListData.viewMode == TaskListViewMode.timeline) {
      return _TimelineViewWidget(
        selectedDate: state.taskListData.selectedDate,
        tasks: state.taskListData.rawTasks,
      );
    } else {
      return _CalendarViewWidget(
        selectedDate: state.taskListData.selectedDate,
        taskCountsByDate: state.taskListData.taskCountsByDate,
        onDateSelected: (date) {
          context.read<TaskListCubit>().selectDate(date);
        },
        onMonthChanged: (month) {
          context.read<TaskListCubit>().navigateToMonth(month);
        },
      );
    }
  }
}

// Placeholder widgets - will be implemented in separate files
class _DateStripWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _DateStripWidget({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 2));
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isSelected = DateUtils.isSameDay(date, selectedDate);
        final dayName = DateFormat('E').format(date);
        final dayNumber = date.day.toString();
        
        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            width: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimelineViewWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<Task> tasks;
  
  static const double hourHeight = 75.0;
  static const double timeColumnWidth = 60.0;

  const _TimelineViewWidget({
    required this.selectedDate,
    required this.tasks,
  });

  List<_TimelineTask> _buildTimelineTasks() {
    final timelineTasks = <_TimelineTask>[];
    
    for (final task in tasks) {
      if (task.dueDate == null) continue;
      
      final startTime = task.dueDate!;
      // Default 1 hour duration, but can be customized per task
      final endTime = _getTaskEndTime(task);
      
      timelineTasks.add(_TimelineTask(
        task: task,
        startTime: startTime,
        endTime: endTime,
      ));
    }
    
    return timelineTasks;
  }
  
  DateTime _getTaskEndTime(Task task) {
    if (task.dueDate == null) return DateTime.now();
    
    // Custom durations based on task type
    Duration duration;
    if (task.title.toLowerCase().contains('call') || 
        task.title.toLowerCase().contains('meeting')) {
      duration = const Duration(minutes: 30); // 30min meetings
    } else if (task.title.toLowerCase().contains('wireframe')) {
      duration = const Duration(hours: 1, minutes: 30); // 1.5 hours
    } else {
      duration = const Duration(hours: 1); // Default 1 hour
    }
    
    return task.dueDate!.add(duration);
  }

  double _calculateTaskTop(DateTime startTime) {
    final startHour = startTime.hour;
    final startMinute = startTime.minute;
    final hourOffset = startHour - 8; // 8am is the start
    return (hourOffset * hourHeight) + (startMinute / 60.0 * hourHeight);
  }

  double _calculateTaskHeight(DateTime startTime, DateTime endTime) {
    final durationInMinutes = endTime.difference(startTime).inMinutes;
    final calculatedHeight = (durationInMinutes / 60.0) * hourHeight;
    // Minimum height should be equal to one hour slot (75px)
    return calculatedHeight < hourHeight ? hourHeight : calculatedHeight;
  }

  @override
  Widget build(BuildContext context) {
    final timelineTasks = _buildTimelineTasks();
    final totalHeight = (18 - 8 + 1) * hourHeight; // 8am to 6pm
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            // Time slots background
            ...List.generate(11, (index) {
              final hour = 8 + index;
              final top = index * hourHeight;
              return Positioned(
                left: 0,
                top: top,
                right: 0,
                height: hourHeight,
                child: _TimeSlotBackground(
                  hour: hour,
                  isLast: index == 10,
                ),
              );
            }),
            
            // Task cards positioned absolutely
            ...timelineTasks.map((timelineTask) {
              final top = _calculateTaskTop(timelineTask.startTime);
              final height = _calculateTaskHeight(timelineTask.startTime, timelineTask.endTime);
              
              return Positioned(
                left: timeColumnWidth + 16,
                top: top,
                right: 0,
                height: height,
                child: _AbsoluteTimelineTaskCard(
                  timelineTask: timelineTask,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TimelineTask {
  final Task task;
  final DateTime startTime;
  final DateTime endTime;

  _TimelineTask({
    required this.task,
    required this.startTime,
    required this.endTime,
  });
}

class _TimeSlotBackground extends StatelessWidget {
  final int hour;
  final bool isLast;

  const _TimeSlotBackground({
    required this.hour,
    this.isLast = false,
  });

  String _formatHour(int hour) {
    if (hour == 12) return '12 pm';
    if (hour < 12) return '${hour.toString().padLeft(2, '0')} am';
    return '${(hour - 12).toString().padLeft(2, '0')} pm';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _TimelineViewWidget.timeColumnWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatHour(hour),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
        // Separator line
        if (!isLast)
          Container(
            margin: const EdgeInsets.only(left: _TimelineViewWidget.timeColumnWidth + 16),
            height: 1,
            color: AppColors.textSecondary.withValues(alpha: 0.1),
          ),
      ],
    );
  }
}

class _AbsoluteTimelineTaskCard extends StatelessWidget {
  final _TimelineTask timelineTask;

  const _AbsoluteTimelineTaskCard({
    required this.timelineTask,
  });

  Color get _cardColor {
    switch (timelineTask.task.priority) {
      case TaskPriority.urgent:
        return AppColors.orange; // Orange for urgent
      case TaskPriority.high:
        return AppColors.blue; // Blue for high
      case TaskPriority.medium:
        return AppColors.green; // Green for medium
      case TaskPriority.low:
        return AppColors.blue.withValues(alpha: 0.7); // Light blue for low
    }
  }

  String get _taskEmoji {
    final title = timelineTask.task.title.toLowerCase();
    if (title.contains('wireframe') || title.contains('design')) {
      return '🔥';
    } else if (title.contains('call') || title.contains('meeting')) {
      return '📞';
    } else if (title.contains('research') || title.contains('analysis')) {
      return '🔍';
    } else if (title.contains('develop') || title.contains('implement')) {
      return '💻';
    } else {
      return '⭐';
    }
  }

  String get _timeRange {
    final startTime = DateFormat('h:mma').format(timelineTask.startTime).toLowerCase();
    final endTime = DateFormat('h:mma').format(timelineTask.endTime).toLowerCase();
    return '$startTime - $endTime';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${timelineTask.task.title} $_taskEmoji',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Real user avatars from task assignees
              UserAvatarStackWidget(
                avatarUrls: timelineTask.task.assignees.map((user) => user.avatarUrl ?? '').toList(),
                size: 20,
                maxVisible: 3,
                overlapFactor: 0.3,
              ),
              Flexible(
                child: Text(
                  _timeRange,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class _CalendarViewWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Map<DateTime, int> taskCountsByDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;

  const _CalendarViewWidget({
    required this.selectedDate,
    required this.taskCountsByDate,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    final monthYear = DateFormat('MMM yyyy').format(selectedDate);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final previousMonth = DateTime(selectedDate.year, selectedDate.month - 1);
              onMonthChanged(previousMonth);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          Text(
            monthYear,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            onPressed: () {
              final nextMonth = DateTime(selectedDate.year, selectedDate.month + 1);
              onMonthChanged(nextMonth);
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildWeekdayHeaders(),
            Expanded(child: _buildCalendarDays()),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
    return Row(
      children: weekdays.map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarDays() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday;
    
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: daysInMonth + startingWeekday - 1,
      itemBuilder: (context, index) {
        if (index < startingWeekday - 1) {
          return const SizedBox();
        }
        
        final day = index - startingWeekday + 2;
        final date = DateTime(selectedDate.year, selectedDate.month, day);
        final isSelected = DateUtils.isSameDay(date, selectedDate);
        final isToday = DateUtils.isSameDay(date, now);
        final dateKey = DateTime(date.year, date.month, date.day);
        final taskCount = taskCountsByDate[dateKey] ?? 0;
        final hasTask = taskCount > 0;
        
        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: hasTask ? Border.all(color: AppColors.primary, width: 1) : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}