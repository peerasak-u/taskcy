import 'package:equatable/equatable.dart';

enum ProjectFilterType { favourites, recents, all }

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjectsRequested extends ProjectsEvent {
  const LoadProjectsRequested();
}

class ProjectFilterChanged extends ProjectsEvent {
  final ProjectFilterType filter;

  const ProjectFilterChanged({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class ProjectSearchUpdated extends ProjectsEvent {
  final String searchQuery;

  const ProjectSearchUpdated({required this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class ProjectRefreshRequested extends ProjectsEvent {
  const ProjectRefreshRequested();
}