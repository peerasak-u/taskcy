import '../models/project.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects({
    int page = 1,
    int perPage = 20,
    String? search,
    String? teamId,
  });

  Future<Project> getProjectById(String id);

  Future<Project> createProject({
    required String name,
    required String description,
    required String teamId,
    required String ownerId,
    DateTime? dueDate,
  });

  Future<Project> updateProject(
    String id, {
    String? name,
    String? description,
    DateTime? dueDate,
  });

  Future<void> deleteProject(String id);

  Future<List<Project>> getProjectsByTeam(String teamId);

  Future<List<Project>> getProjectsByOwner(String ownerId);

  Future<List<Project>> getOverdueProjects();
}