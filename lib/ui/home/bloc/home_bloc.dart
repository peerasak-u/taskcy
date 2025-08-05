import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/task.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/task_repository.dart';
import '../view_model/home_project_view_model.dart';
import '../view_model/home_task_view_model.dart';
import '../view_model/home_view_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskRepository _taskRepository;
  final ProjectRepository _projectRepository;

  HomeBloc({
    required TaskRepository taskRepository,
    required ProjectRepository projectRepository,
  })  : _taskRepository = taskRepository,
        _projectRepository = projectRepository,
        super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      final futures = await Future.wait([
        _projectRepository.getProjects(perPage: 10),
        _taskRepository.getTasks(status: TaskStatus.inProgress, perPage: 10),
      ]);

      final projects = futures[0] as List;
      final inProgressTasks = futures[1] as List;

      if (projects.isEmpty && inProgressTasks.isEmpty) {
        emit(const HomeEmpty());
        return;
      }

      final projectViewModels = <HomeProjectViewModel>[];
      
      for (final project in projects) {
        final projectTasks = await _taskRepository.getTasksByProject(project.id);
        final projectViewModel = HomeProjectViewModel.fromProject(
          project: project,
          projectTasks: projectTasks,
        );
        projectViewModels.add(projectViewModel);
      }

      final taskViewModels = <HomeTaskViewModel>[];
      
      for (final task in inProgressTasks) {
        try {
          final project = await _projectRepository.getProjectById(task.projectId);
          final taskViewModel = HomeTaskViewModel.fromTask(
            task: task,
            project: project,
          );
          taskViewModels.add(taskViewModel);
        } catch (e) {
          continue;
        }
      }

      final homeViewModel = HomeViewModel(
        projects: projectViewModels,
        inProgressTasks: taskViewModels,
      );

      if (homeViewModel.isEmpty) {
        emit(const HomeEmpty());
      } else {
        emit(HomeLoaded(homeData: homeViewModel));
      }
    } catch (error) {
      emit(HomeError(message: error.toString()));
    }
  }
}