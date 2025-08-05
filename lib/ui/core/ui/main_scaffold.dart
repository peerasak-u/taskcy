import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_bottom_navigation.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _getBottomNavigationIndex(currentLocation),
        onTap: (index) => _onTabTapped(context, index),
      ),
    );
  }

  int _getBottomNavigationIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/project')) return 1;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    // Handle add button (index 2) separately
    if (index == 2) {
      _showCreateTaskDialog(context);
      return;
    }

    // Map UI index to branch index (accounting for add button)
    final branchIndex = _mapIndexToBranch(index);
    navigationShell.goBranch(branchIndex);
  }

  int _mapIndexToBranch(int uiIndex) {
    // UI: [Home(0), Project(1), Add(2), Chat(3), Profile(4)]
    // Branches: [Home(0), Project(1), Chat(2), Profile(3)]
    if (uiIndex <= 1) return uiIndex;
    return uiIndex - 1; // Account for Add button
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Task'),
        content: const Text('Task creation dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}