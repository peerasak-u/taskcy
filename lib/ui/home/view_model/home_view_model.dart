import 'package:equatable/equatable.dart';

import 'home_project_view_model.dart';
import 'home_task_view_model.dart';

class HomeViewModel extends Equatable {
  final List<HomeProjectViewModel> projects;
  final List<HomeTaskViewModel> inProgressTasks;

  const HomeViewModel({
    required this.projects,
    required this.inProgressTasks,
  });

  bool get isEmpty => projects.isEmpty && inProgressTasks.isEmpty;

  @override
  List<Object?> get props => [projects, inProgressTasks];
}