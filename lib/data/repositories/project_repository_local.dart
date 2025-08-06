import '../../domain/models/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../services/project_service_local.dart';

class ProjectRepositoryLocal implements ProjectRepository {
  final ProjectServiceLocal _projectService = ProjectServiceLocal();

  @override
  Future<List<Project>> getProjects({
    int page = 1,
    int perPage = 20,
    String? search,
    String? teamId,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    List<Project> projects;
    
    if (search != null && search.isNotEmpty) {
      projects = await _projectService.searchProjects(search);
    } else {
      projects = await _projectService.getProjects();
    }
    
    // Apply team filter
    if (teamId != null) {
      projects = projects.where((project) => project.team.id == teamId).toList();
    }
    
    // Apply pagination
    final startIndex = (page - 1) * perPage;
    final endIndex = startIndex + perPage;
    
    if (startIndex >= projects.length) {
      return [];
    }
    
    return projects.sublist(
      startIndex,
      endIndex > projects.length ? projects.length : endIndex,
    );
  }

  @override
  Future<Project> getProjectById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final project = await _projectService.getProjectById(id);
    if (project == null) {
      throw Exception('Project not found');
    }
    return project;
  }

  @override
  Future<Project> createProject({
    required String name,
    required String description,
    required String teamId,
    required String ownerId,
    DateTime? dueDate,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    return await _projectService.createProject(
      name: name,
      description: description,
      teamId: teamId,
      ownerId: ownerId,
      dueDate: dueDate,
    );
  }

  @override
  Future<Project> updateProject(
    String id, {
    String? name,
    String? description,
    DateTime? dueDate,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    return await _projectService.updateProject(
      id,
      name: name,
      description: description,
      dueDate: dueDate,
    );
  }

  @override
  Future<void> deleteProject(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    await _projectService.deleteProject(id);
  }

  @override
  Future<List<Project>> getProjectsByTeam(String teamId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _projectService.getProjectsByTeam(teamId);
  }

  @override
  Future<List<Project>> getProjectsByOwner(String ownerId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _projectService.getProjectsByOwner(ownerId);
  }

  @override
  Future<List<Project>> getOverdueProjects() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _projectService.getOverdueProjects();
  }
}