import 'package:equatable/equatable.dart';

import '../view_model/projects_view_model.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectsState {
  final ProjectsViewModel projectsData;

  const ProjectsLoaded({required this.projectsData});

  @override
  List<Object?> get props => [projectsData];
}

class ProjectsEmpty extends ProjectsState {
  const ProjectsEmpty();
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError({required this.message});

  @override
  List<Object?> get props => [message];
}