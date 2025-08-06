import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../view_model/home_view_model.dart';
import '../../shared/widgets/header_widget.dart';
import '../../shared/widgets/loading_state_widget.dart';
import '../../shared/widgets/error_state_widget.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'motivational_banner_widget.dart';
import 'project_card_widget.dart';
import 'section_header_widget.dart';
import 'task_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('EEEE, d').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              centerText: currentDate,
              leftIcon: Icons.menu,
              rightIcon: Icons.notifications_outlined,
              onLeftTap: () {},
              onRightTap: () {},
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return const LoadingStateWidget();
                  } else if (state is HomeLoaded) {
                    return _buildLoadedState(context, state.homeData);
                  } else if (state is HomeEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.inbox_outlined,
                      title: 'No projects or tasks yet',
                      message: 'Create your first project to get started',
                    );
                  } else if (state is HomeError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () => context.read<HomeBloc>().add(const LoadHomeData()),
                    );
                  }
                  return const LoadingStateWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLoadedState(BuildContext context, HomeViewModel homeData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MotivationalBannerWidget(),
          const SizedBox(height: 24),
          if (homeData.projects.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: homeData.projects.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final project = homeData.projects[index];
                  return ProjectCardWidget(
                    title: project.title,
                    subtitle: project.subtitle,
                    teamAvatars: project.teamAvatars,
                    currentProgress: project.currentProgress,
                    totalProgress: project.totalProgress,
                    backgroundColor: project.backgroundColor,
                    onTap: () {},
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
          if (homeData.inProgressTasks.isNotEmpty) ...[
            SectionHeaderWidget(
              title: 'In Progress', 
              onTap: () => context.push('/home/task-list/today'),
            ),
            ...homeData.inProgressTasks.map(
              (task) => TaskItemWidget(
                title: task.title,
                projectName: task.projectName,
                progress: task.progress,
                timeAgo: task.timeAgo,
                progressColor: task.progressColor,
                onTap: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }

}
