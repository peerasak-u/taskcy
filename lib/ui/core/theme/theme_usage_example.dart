// This file demonstrates how to use the custom color theme in your widgets

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'custom_colors_extension.dart';

class ThemeUsageExample extends StatelessWidget {
  const ThemeUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Access custom colors through extension
    final customColors = Theme.of(context).extension<CustomColorsExtension>()!;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Theme Usage Example',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using direct AppColors constants
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Primary Color Container',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Using custom colors extension
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: customColors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Custom Blue Container',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress indicator with custom colors
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: customColors.progressLow,
                    valueColor: AlwaysStoppedAnimation<Color>(customColors.progressHigh),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '60%',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Task status cards with different colors
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: customColors.green.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, color: customColors.success),
                          const SizedBox(height: 4),
                          Text(
                            'Completed',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: customColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: customColors.orange.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(Icons.access_time, color: customColors.warning),
                          const SizedBox(height: 4),
                          Text(
                            'In Progress',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: customColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: customColors.blue.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(Icons.schedule, color: customColors.info),
                          const SizedBox(height: 4),
                          Text(
                            'To Do',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: customColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}