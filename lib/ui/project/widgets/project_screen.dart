import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../cubit/projects_cubit.dart';
import '../cubit/projects_state.dart';
import '../view_model/projects_view_model.dart';
import 'project_filter_tabs_widget.dart';
import 'project_list_item_widget.dart';
import 'project_search_widget.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProjectsCubit>().initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              controller: _searchController,
              onChanged: (query) {
                context.read<ProjectsCubit>().updateSearchQuery(query);
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<ProjectsCubit, ProjectsState>(
              builder: (context, state) {
                if (state is ProjectsLoaded) {
                  return ProjectFilterTabsWidget(
                    selectedFilter: state.projectsData.currentFilter,
                    onFilterChanged: (filter) {
                      context.read<ProjectsCubit>().setFilter(filter);
                    },
                    onGridIconTap: () {
                      // TODO: Toggle between list and grid view
                    },
                  );
                }
                return ProjectFilterTabsWidget(
                  selectedFilter: ProjectFilterType.favourites,
                  onFilterChanged: (filter) {
                    context.read<ProjectsCubit>().setFilter(filter);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ProjectsCubit, ProjectsState>(
                builder: (context, state) {
                  if (state is ProjectsLoading) {
                    return _buildLoadingState();
                  } else if (state is ProjectsLoaded) {
                    return _buildLoadedState(state.projectsData);
                  } else if (state is ProjectsEmpty) {
                    return _buildEmptyState();
                  } else if (state is ProjectsError) {
                    return _buildErrorState(state.message);
                  }
                  return _buildLoadingState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildLoadedState(ProjectsViewModel projectsData) {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No projects found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProjectsCubit>().initialize();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}