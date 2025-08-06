import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class TimePickerFields extends StatelessWidget {
  final String startTime;
  final String endTime;
  final ValueChanged<String> onStartTimeChanged;
  final ValueChanged<String> onEndTimeChanged;

  const TimePickerFields({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimePickerField(
            label: 'Start Time',
            time: startTime,
            onTimeChanged: onStartTimeChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _TimePickerField(
            label: 'End Time',
            time: endTime,
            onTimeChanged: onEndTimeChanged,
          ),
        ),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final String time;
  final ValueChanged<String> onTimeChanged;

  const _TimePickerField({
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showTimePicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.surface,
                width: 1,
              ),
            ),
            child: Text(
              time.isEmpty ? 'Select time' : time,
              style: TextStyle(
                fontSize: 16,
                color: time.isNotEmpty 
                  ? AppColors.textPrimary 
                  : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final currentTime = _parseTime(time);
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final formattedTime = _formatTime(selectedTime);
      onTimeChanged(formattedTime);
    }
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    final displayHour = hour == 0 ? 12 : hour;
    
    return '$displayHour:$minute $period';
  }
}