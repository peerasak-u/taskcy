import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AddMenuModal extends StatelessWidget {
  const AddMenuModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AddMenuModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          _buildMenuItem(
            icon: Icons.task_alt_outlined,
            title: 'Create Task',
            onTap: () => _handleCreateTask(context),
          ),
          _buildMenuItem(
            icon: Icons.add_box_outlined,
            title: 'Create Project',
            onTap: () => _handleCreateProject(context),
          ),
          _buildMenuItem(
            icon: Icons.groups_outlined,
            title: 'Create Team',
            onTap: () => _handleCreateTeam(context),
          ),
          _buildMenuItem(
            icon: Icons.event_outlined,
            title: 'Create Event',
            onTap: () => _handleCreateEvent(context),
          ),
          const SizedBox(height: 16),
          _buildCloseButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close,
          color: AppColors.background,
          size: 24,
        ),
      ),
    );
  }

  void _handleCreateTask(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Navigate to create task screen
  }

  void _handleCreateProject(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Navigate to create project screen
  }

  void _handleCreateTeam(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Navigate to create team screen
  }

  void _handleCreateEvent(BuildContext context) {
    Navigator.of(context).pop();
    // TODO: Navigate to create event screen
  }
}