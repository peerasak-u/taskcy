import 'package:equatable/equatable.dart';

import '../../../domain/models/user.dart';
import '../../../domain/models/project.dart';
import '../../../domain/models/task.dart';

class ProfileViewModel extends Equatable {
  final User user;
  final int onGoingTasksCount;
  final int completedTasksCount;
  final int totalProjectsCount;

  const ProfileViewModel({
    required this.user,
    required this.onGoingTasksCount,
    required this.completedTasksCount,
    required this.totalProjectsCount,
  });

  static ProfileViewModel fromUserData({
    required User user,
    required List<Project> userProjects,
    required List<Task> userTasks,
  }) {
    final onGoingTasks = userTasks
        .where((task) => task.status == TaskStatus.inProgress || task.status == TaskStatus.todo)
        .length;
    
    final completedTasks = userTasks
        .where((task) => task.status == TaskStatus.completed)
        .length;

    return ProfileViewModel(
      user: user,
      onGoingTasksCount: onGoingTasks,
      completedTasksCount: completedTasks,
      totalProjectsCount: userProjects.length,
    );
  }

  String get userHandle {
    // Create a handle from email
    final emailPart = user.email.split('@')[0];
    return '@$emailPart';
  }

  @override
  List<Object?> get props => [
        user,
        onGoingTasksCount,
        completedTasksCount,
        totalProjectsCount,
      ];
}