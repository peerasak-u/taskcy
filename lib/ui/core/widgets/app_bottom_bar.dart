import 'package:flutter/material.dart';

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
        color: Colors.white,
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
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? const Color(0xFF756EF3) : Colors.grey,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF756EF3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x40756EF3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}