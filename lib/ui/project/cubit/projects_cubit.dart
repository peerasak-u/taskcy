import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/project.dart';
import '../../../domain/models/task.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/task_repository.dart';
import '../view_model/projects_view_model.dart';
import 'projects_state.dart';

enum ProjectFilterType { favourites, recents, all }

class ProjectsCubit extends Cubit<ProjectsState> {
  final ProjectRepository _projectRepository;
  final TaskRepository _taskRepository;

  ProjectsCubit({
    required ProjectRepository projectRepository,
    required TaskRepository taskRepository,
  })  : _projectRepository = projectRepository,
        _taskRepository = taskRepository,
        super(const ProjectsInitial());

  ProjectFilterType _currentFilter = ProjectFilterType.favourites;
  String _searchQuery = '';
  List<Project> _allProjects = [];
  final Map<String, List<Task>> _tasksByProject = {};

  ProjectFilterType get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  void initialize() {
    emit(const ProjectsLoading());
    _loadProjects();
  }

  void _loadProjects() async {
    try {
      _allProjects = await _projectRepository.getProjects();
      await _loadTasksForProjects();
      _filterAndEmitProjects();
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  Future<void> _loadTasksForProjects() async {
    _tasksByProject.clear();
    for (final project in _allProjects) {
      final tasks = await _taskRepository.getTasksByProject(project.id);
      _tasksByProject[project.id] = tasks;
    }
  }

  void setFilter(ProjectFilterType filter) {
    _currentFilter = filter;
    _filterAndEmitProjects();
  }

  void updateSearchQuery(String query) async {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      try {
        _allProjects = await _projectRepository.getProjects(search: _searchQuery);
        await _loadTasksForProjects();
      } catch (e) {
        emit(ProjectsError(message: e.toString()));
        return;
      }
    } else {
      try {
        _allProjects = await _projectRepository.getProjects();
        await _loadTasksForProjects();
      } catch (e) {
        emit(ProjectsError(message: e.toString()));
        return;
      }
    }
    _filterAndEmitProjects();
  }

  void _filterAndEmitProjects() {
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