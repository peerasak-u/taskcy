import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'header_widget.dart';
import 'motivational_banner_widget.dart';
import 'project_card_widget.dart';
import 'section_header_widget.dart';
import 'task_item_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              dateText: 'Friday, 26',
              onMenuTap: () {},
              onNotificationTap: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MotivationalBannerWidget(),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          ProjectCardWidget(
                            title: 'Application Design',
                            subtitle: 'UI Design Kit',
                            teamAvatars: const ['', '', ''],
                            currentProgress: 50,
                            totalProgress: 80,
                            backgroundColor: AppColors.primary,
                            onTap: () {},
                          ),
                          const SizedBox(width: 16),
                          ProjectCardWidget(
                            title: 'Overlay Design',
                            subtitle: 'UI Design',
                            teamAvatars: const ['', ''],
                            currentProgress: 30,
                            totalProgress: 50,
                            backgroundColor: AppColors.blue,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SectionHeaderWidget(title: 'In Progress', onTap: () {}),
                    TaskItemWidget(
                      title: 'Create Detail Booking',
                      projectName: 'Productivity Mobile App',
                      progress: 0.6,
                      timeAgo: '2 min ago',
                      progressColor: AppColors.primary,
                      onTap: () {},
                    ),
                    TaskItemWidget(
                      title: 'Revision Home Page',
                      projectName: 'Banking Mobile App',
                      progress: 0.7,
                      timeAgo: '5 min ago',
                      progressColor: AppColors.blue,
                      onTap: () {},
                    ),
                    TaskItemWidget(
                      title: 'Working On Landing Page',
                      projectName: 'Online Course',
                      progress: 0.8,
                      timeAgo: '7 min ago',
                      progressColor: AppColors.green,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
