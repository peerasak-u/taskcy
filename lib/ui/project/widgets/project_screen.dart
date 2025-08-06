import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../../shared/widgets/loading_state_widget.dart';
import '../../shared/widgets/error_state_widget.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../view_model/projects_view_model.dart';
import 'project_filter_tabs_widget.dart';
import 'project_list_item_widget.dart';
import 'project_search_widget.dart';

class ProjectScreen extends StatefulWidget {
  final TextEditingController searchController;
  
  const ProjectScreen({super.key, required this.searchController});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize projects data when screen is built
    context.read<ProjectsBloc>().add(const LoadProjectsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              centerText: 'Projects',
              rightIcon: Icons.add,
              onRightTap: () {
                // TODO: Navigate to create project screen
              },
            ),
            const SizedBox(height: 16),
            ProjectSearchWidget(
              controller: widget.searchController,
              onChanged: (query) {
                context.read<ProjectsBloc>().add(ProjectSearchUpdated(searchQuery: query));
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (context, state) {
                if (state is ProjectsLoaded) {
                  return ProjectFilterTabsWidget(
                    selectedFilter: state.projectsData.currentFilter,
                    onFilterChanged: (filter) {
                      context.read<ProjectsBloc>().add(ProjectFilterChanged(filter: filter));
                    },
                    onGridIconTap: () {
                      // TODO: Toggle between list and grid view
                    },
                  );
                }
                return ProjectFilterTabsWidget(
                  selectedFilter: ProjectFilterType.favourites,
                  onFilterChanged: (filter) {
                    context.read<ProjectsBloc>().add(ProjectFilterChanged(filter: filter));
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (context, state) {
                  if (state is ProjectsLoading) {
                    return const LoadingStateWidget();
                  } else if (state is ProjectsLoaded) {
                    return _buildLoadedState(context, state.projectsData);
                  } else if (state is ProjectsEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.folder_outlined,
                      title: 'No projects found',
                      message: 'Try adjusting your search or filter',
                    );
                  } else if (state is ProjectsError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () => context.read<ProjectsBloc>().add(const LoadProjectsRequested()),
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


  Widget _buildLoadedState(BuildContext context, ProjectsViewModel projectsData) {
    return ListView.builder(
      itemCount: projectsData.projects.length,
      itemBuilder: (context, index) {
        final project = projectsData.projects[index];
        return ProjectListItemWidget(
          project: project,
          onTap: () {
            // TODO: Navigate to project detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped on ${project.title}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }

}