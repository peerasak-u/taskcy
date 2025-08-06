import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../cubit/projects_cubit.dart';

class ProjectFilterTabsWidget extends StatelessWidget {
  final ProjectFilterType selectedFilter;
  final Function(ProjectFilterType) onFilterChanged;
  final VoidCallback? onGridIconTap;

  const ProjectFilterTabsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.onGridIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildFilterTab(
                  'Favourites',
                  ProjectFilterType.favourites,
                  selectedFilter == ProjectFilterType.favourites,
                ),
                const SizedBox(width: 24),
                _buildFilterTab(
                  'Recents',
                  ProjectFilterType.recents,
                  selectedFilter == ProjectFilterType.recents,
                ),
                const SizedBox(width: 24),
                _buildFilterTab(
                  'All',
                  ProjectFilterType.all,
                  selectedFilter == ProjectFilterType.all,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onGridIconTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.apps,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    String title,
    ProjectFilterType filterType,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => onFilterChanged(filterType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}