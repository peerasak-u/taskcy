import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../cubit/task_list_cubit.dart';
import '../cubit/task_list_state.dart';

class TaskListScreen extends StatefulWidget {
  final String taskType;
  
  const TaskListScreen({
    super.key,
    required this.taskType,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskListCubit>().initialize(taskType: widget.taskType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<TaskListCubit, TaskListState>(
          builder: (context, state) {
            if (state is TaskListLoaded) {
              return Column(
                children: [
                  _buildHeader(state),
                  _buildDateSection(state),
                  _buildDateStrip(state),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildContent(state),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(TaskListLoaded state) {
    final title = state.taskType == 'today' ? 'Today Task' : 'Monthly Task';
    
    return HeaderWidget(
      centerText: title,
      leftIcon: Icons.arrow_back_ios,
      rightIcon: Icons.edit_outlined,
      onLeftTap: () => context.pop(),
      onRightTap: null,
    );
  }

  Widget _buildDateSection(TaskListLoaded state) {
    final formattedDate = DateFormat('MMMM, d').format(state.selectedDate);
    
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
                const Text(
                  '15 task today',
                  style: TextStyle(
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
                state.viewMode == TaskListViewMode.calendar 
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

  Widget _buildDateStrip(TaskListLoaded state) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: _DateStripWidget(
        selectedDate: state.selectedDate,
        onDateSelected: (date) {
          context.read<TaskListCubit>().selectDate(date);
        },
      ),
    );
  }

  Widget _buildContent(TaskListLoaded state) {
    if (state.viewMode == TaskListViewMode.timeline) {
      return _TimelineViewWidget(selectedDate: state.selectedDate);
    } else {
      return _CalendarViewWidget(
        selectedDate: state.selectedDate,
        onDateSelected: (date) {
          context.read<TaskListCubit>().selectDate(date);
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

  const _TimelineViewWidget({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: const [
        _TimeSlot(time: '10 am', hasTask: true, taskTitle: 'Wareframe elements'),
        _TimeSlot(time: '11 am', hasTask: false),
        _TimeSlot(time: '12 pm', hasTask: true, taskTitle: 'Mobile app Design'),
        _TimeSlot(time: '01 pm', hasTask: true, taskTitle: 'Design Team call'),
        _TimeSlot(time: '02 pm', hasTask: false),
      ],
    );
  }
}

class _TimeSlot extends StatelessWidget {
  final String time;
  final bool hasTask;
  final String? taskTitle;

  const _TimeSlot({
    required this.time,
    required this.hasTask,
    this.taskTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: hasTask && taskTitle != null
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskTitle!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '10am - 11am',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(height: 60),
          ),
        ],
      ),
    );
  }
}

class _CalendarViewWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const _CalendarViewWidget({
    required this.selectedDate,
    required this.onDateSelected,
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
            onPressed: () {},
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
            onPressed: () {},
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
        final hasTask = day == 3 || day == 12 || day == 27; // Mock task data
        
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