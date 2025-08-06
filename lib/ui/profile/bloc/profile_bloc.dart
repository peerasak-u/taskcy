import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/user_repository.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/repositories/task_repository.dart';
import '../view_model/profile_view_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final ProjectRepository _projectRepository;
  final TaskRepository _taskRepository;

  ProfileBloc({
    required UserRepository userRepository,
    required ProjectRepository projectRepository,
    required TaskRepository taskRepository,
  })  : _userRepository = userRepository,
        _projectRepository = projectRepository,
        _taskRepository = taskRepository,
        super(const ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<RefreshProfileData>(_onRefreshProfileData);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    await _loadProfileData(emit);
  }

  Future<void> _onRefreshProfileData(
    RefreshProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    await _loadProfileData(emit);
  }

  Future<void> _loadProfileData(Emitter<ProfileState> emit) async {
    try {
      emit(const ProfileLoading());

      // Get Peerasak user (the current user)
      const peerasakUserId = 'user_peerasak';
      final user = await _userRepository.getUserById(peerasakUserId);

      // Get user's projects and tasks in parallel
      final userProjects = await _projectRepository.getProjectsByOwner(peerasakUserId);
      final userTasks = await _taskRepository.getTasksByAssignee(peerasakUserId);

      final profileViewModel = ProfileViewModel.fromUserData(
        user: user,
        userProjects: userProjects,
        userTasks: userTasks,
      );

      emit(ProfileLoaded(profileData: profileViewModel));
    } catch (error) {
      emit(ProfileError(message: error.toString()));
    }
  }
}