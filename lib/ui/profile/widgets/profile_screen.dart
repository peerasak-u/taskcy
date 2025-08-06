import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/header_widget.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'profile_user_section.dart';
import 'profile_stats_section.dart';
import 'profile_menu_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                // Header without back button
                const HeaderWidget(
                  centerText: 'Profile',
                ),
                
                // Main content
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(const RefreshProfileData());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is ProfileLoaded) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            ProfileUserSection(
              user: state.profileData.user,
              userHandle: state.profileData.userHandle,
              onEditPressed: () {
                // TODO: Navigate to edit profile screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit profile functionality coming soon'),
                  ),
                );
              },
            ),
            
            // Stats Section
            ProfileStatsSection(
              onGoingTasksCount: state.profileData.onGoingTasksCount,
              completedTasksCount: state.profileData.completedTasksCount,
            ),
            
            // Menu Section
            ProfileMenuSection(
              onMyProjectsTapped: () {
                // TODO: Navigate to user's projects
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('My Projects functionality coming soon'),
                  ),
                );
              },
              onMyTasksTapped: () {
                // TODO: Navigate to user's tasks
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('My Tasks functionality coming soon'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      );
    }

    // Initial state - trigger data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfileData());
    });

    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}