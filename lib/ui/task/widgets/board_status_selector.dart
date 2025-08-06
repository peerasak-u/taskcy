import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../view_model/add_task_form_model.dart';

class BoardStatusSelector extends StatelessWidget {
  final BoardStatus selectedStatus;
  final ValueChanged<BoardStatus> onStatusChanged;

  const BoardStatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Board',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _StatusButton(
              status: BoardStatus.urgent,
              label: 'Urgent',
              isSelected: selectedStatus == BoardStatus.urgent,
              onTap: () => onStatusChanged(BoardStatus.urgent),
            ),
            _StatusButton(
              status: BoardStatus.running,
              label: 'Running',
              isSelected: selectedStatus == BoardStatus.running,
              onTap: () => onStatusChanged(BoardStatus.running),
            ),
            _StatusButton(
              status: BoardStatus.ongoing,
              label: 'ongoing',
              isSelected: selectedStatus == BoardStatus.ongoing,
              onTap: () => onStatusChanged(BoardStatus.ongoing),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusButton extends StatelessWidget {
  final BoardStatus status;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.status,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(
            color: color,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppColors.background : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BoardStatus status) {
    switch (status) {
      case BoardStatus.urgent:
        return AppColors.orange;
      case BoardStatus.running:
        return AppColors.primary;
      case BoardStatus.ongoing:
        return AppColors.green;
    }
  }
}