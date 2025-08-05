import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 80 + bottomPadding,
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  index: 0,
                  isActive: currentIndex == 0,
                ),
                _buildTabItem(
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder,
                  index: 1,
                  isActive: currentIndex == 1,
                ),
                _buildAddButton(),
                _buildTabItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  index: 3,
                  isActive: currentIndex == 3,
                ),
                _buildTabItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  index: 4,
                  isActive: currentIndex == 4,
                ),
              ],
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required bool isActive,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            isActive ? activeIcon : icon,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8, top: 4),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => onTap(2),
            borderRadius: BorderRadius.circular(28),
            child: const Icon(Icons.add, color: AppColors.background, size: 28),
          ),
        ),
      ),
    );
  }
}
