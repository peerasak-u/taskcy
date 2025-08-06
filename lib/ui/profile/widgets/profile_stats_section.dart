import 'package:flutter/material.dart';

import 'stat_card_widget.dart';

class ProfileStatsSection extends StatelessWidget {
  final int onGoingTasksCount;
  final int completedTasksCount;

  const ProfileStatsSection({
    super.key,
    required this.onGoingTasksCount,
    required this.completedTasksCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          StatCardWidget(
            icon: Icons.access_time,
            value: onGoingTasksCount.toString(),
            label: 'On Going',
          ),
          const SizedBox(width: 16),
          StatCardWidget(
            icon: Icons.check_circle_outline,
            value: completedTasksCount.toString(),
            label: 'Total Complete',
          ),
        ],
      ),
    );
  }
}