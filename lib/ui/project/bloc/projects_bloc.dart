import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/task.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/task_repository.dart';
import '../view_model/projects_view_model.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository _projectRepository;
  final TaskRepository _taskRepository;

  // Internal state management
  ProjectFilterType _currentFilter = ProjectFilterType.favourites;
  String _searchQuery = '';
  List<Project> _allProjects = [];
  final Map<String, List<Task>> _tasksByProject = {};

  ProjectsBloc({
    required ProjectRepository projectRepository,
    required TaskRepository taskRepository,
  })  : _projectRepository = projectRepository,
        _taskRepository = taskRepository,
        super(const ProjectsInitial()) {
    on<LoadProjectsRequested>(_onLoadProjectsRequested);
    on<ProjectFilterChanged>(_onProjectFilterChanged);
    on<ProjectSearchUpdated>(_onProjectSearchUpdated);
    on<ProjectRefreshRequested>(_onProjectRefreshRequested);
  }

  Future<void> _onLoadProjectsRequested(
    LoadProjectsRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      emit(const ProjectsLoading());
      await _loadAllProjects();
      await _loadTasksForProjects();
      _filterAndEmitProjects(emit);
    } catch (error) {
      emit(ProjectsError(message: error.toString()));
    }
  }

  Future<void> _onProjectFilterChanged(
    ProjectFilterChanged event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      _currentFilter = event.filter;
      _filterAndEmitProjects(emit);
    } catch (error) {
      emit(ProjectsError(message: error.toString()));
    }
  }

  Future<void> _onProjectSearchUpdated(
    ProjectSearchUpdated event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      _searchQuery = event.searchQuery;
      
      if (_searchQuery.isNotEmpty) {
        _allProjects = await _projectRepository.getProjects(search: _searchQuery);
      } else {
        _allProjects = await _projectRepository.getProjects();
      }
      
      await _loadTasksForProjects();
      _filterAndEmitProjects(emit);
    } catch (error) {
      emit(ProjectsError(message: error.toString()));
    }
  }

  Future<void> _onProjectRefreshRequested(
    ProjectRefreshRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      // Keep current state while refreshing to avoid loading flicker
      await _loadAllProjects();
      await _loadTasksForProjects();
      _filterAndEmitProjects(emit);
    } catch (error) {
      emit(ProjectsError(message: error.toString()));
    }
  }

  Future<void> _loadAllProjects() async {
    if (_searchQuery.isNotEmpty) {
      _allProjects = await _projectRepository.getProjects(search: _searchQuery);
    } else {
      _allProjects = await _projectRepository.getProjects();
    }
  }

  Future<void> _loadTasksForProjects() async {
    _tasksByProject.clear();
    for (final project in _allProjects) {
      final tasks = await _taskRepository.getTasksByProject(project.id);
      _tasksByProject[project.id] = tasks;
    }
  }

  void _filterAndEmitProjects(Emitter<ProjectsState> emit) {
    List<Project> filteredProjects = _allProjects;

    // Apply category filter
    switch (_currentFilter) {
      case ProjectFilterType.favourites:
        // For now, show all as favourites - can be enhanced with actual favorites logic
        break;
      case ProjectFilterType.recents:
        // Sort by most recently updated
        filteredProjects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        filteredProjects = filteredProjects.take(10).toList();
        break;
      case ProjectFilterType.all:
        // Show all projects
        break;
    }

    if (filteredProjects.isEmpty) {
      emit(const ProjectsEmpty());
    } else {
      final projectsViewModel = ProjectsViewModel.fromProjects(
        filteredProjects,
        tasksByProject: _tasksByProject,
        currentFilter: _currentFilter,
        searchQuery: _searchQuery,
      );
      emit(ProjectsLoaded(projectsData: projectsViewModel));
    }
  }
}