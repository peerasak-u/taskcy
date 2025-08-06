import '../../domain/models/project.dart';
import 'team_service_local.dart';

class ProjectServiceLocal {
  static List<Project>? _projects;
  static int _projectCounter = 4;
  final TeamServiceLocal _teamService = TeamServiceLocal();

  Future<List<Project>> getProjects() async {
    _projects ??= await _seedInitialProjects();
    return List<Project>.from(_projects!);
  }

  Future<Project?> getProjectById(String id) async {
    final projects = await getProjects();
    try {
      return projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Project>> getProjectsByTeam(String teamId) async {
    final projects = await getProjects();
    return projects.where((project) => project.team.id == teamId).toList();
  }

  Future<List<Project>> getProjectsByOwner(String ownerId) async {
    final projects = await getProjects();
    return projects.where((project) => project.ownerId == ownerId).toList();
  }

  Future<List<Project>> searchProjects(String query) async {
    final projects = await getProjects();
    final lowerQuery = query.toLowerCase();

    return projects.where((project) {
      return project.name.toLowerCase().contains(lowerQuery) ||
          project.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<Project>> getOverdueProjects() async {
    final projects = await getProjects();
    final now = DateTime.now();

    return projects.where((project) {
      return project.dueDate != null && now.isAfter(project.dueDate!);
    }).toList();
  }

  Future<Project> saveProject(Project project) async {
    _projects ??= await _seedInitialProjects();
    final existingIndex = _projects!.indexWhere((p) => p.id == project.id);

    if (existingIndex != -1) {
      _projects![existingIndex] = project.copyWith(updatedAt: DateTime.now());
    } else {
      _projects!.add(project);
    }

    return _projects!.firstWhere((p) => p.id == project.id);
  }

  Future<Project> createProject({
    required String name,
    required String description,
    required String teamId,
    required String ownerId,
    DateTime? dueDate,
  }) async {
    final team = await _teamService.getTeamById(teamId);
    if (team == null) {
      throw Exception('Team not found');
    }

    final id = _generateId();
    final now = DateTime.now();

    final project = Project(
      id: id,
      name: name,
      description: description,
      team: team,
      ownerId: ownerId,
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
    );

    return await saveProject(project);
  }

  Future<Project> updateProject(
    String id, {
    String? name,
    String? description,
    String? teamId,
    String? ownerId,
    DateTime? dueDate,
  }) async {
    _projects ??= await _seedInitialProjects();
    final projectIndex = _projects!.indexWhere((project) => project.id == id);

    if (projectIndex == -1) {
      throw Exception('Project not found');
    }

    final currentProject = _projects![projectIndex];
    var updatedTeam = currentProject.team;

    // If teamId is provided, fetch the new team
    if (teamId != null && teamId != currentProject.team.id) {
      final newTeam = await _teamService.getTeamById(teamId);
      if (newTeam == null) {
        throw Exception('Team not found');
      }
      updatedTeam = newTeam;
    }

    final updatedProject = currentProject.copyWith(
      name: name,
      description: description,
      team: updatedTeam,
      ownerId: ownerId,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );

    _projects![projectIndex] = updatedProject;

    return updatedProject;
  }

  Future<void> deleteProject(String id) async {
    _projects ??= await _seedInitialProjects();
    _projects!.removeWhere((project) => project.id == id);
  }

  String _generateId() {
    _projectCounter++;
    return 'project_$_projectCounter';
  }

  Future<List<Project>> _seedInitialProjects() async {
    // Get teams with populated members
    final teams = await _teamService.getTeams();
    
    // Helper function to get team by ID
    getTeamById(String teamId) {
      return teams.firstWhere((team) => team.id == teamId);
    }

    final now = DateTime.now();

    return [
      Project(
        id: 'project_axentech',
        name: 'AxenTech Assignment',
        description:
            'Flutter learning project focusing on foundational development skills and modern mobile app architecture',
        team: getTeamById('team_axentech'),
        ownerId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 21)), // 3 weeks from now
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Project(
        id: 'project_pygmy',
        name: 'Migrate Pygmy to Flutter',
        description:
            'Complex migration project from iOS SwiftUI to Flutter, including Vision Framework integration and database migration',
        team: getTeamById('team_pygmy'),
        ownerId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 90)), // 3 months from now
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Project(
        id: 'project_brand_identity',
        name: 'Brand Identity Campaign',
        description:
            'Comprehensive marketing campaign including brand research, logo design, style guide creation, and social media strategy',
        team: getTeamById('team_creativeworks'),
        ownerId: 'user_sarah',
        dueDate: now.add(const Duration(days: 14)), // 2 weeks from now
        createdAt: now.subtract(const Duration(days: 55)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
      Project(
        id: 'project_personal_tools',
        name: 'Personal Productivity Tools',
        description:
            'Small utility applications for personal productivity and workflow enhancement',
        team: getTeamById('team_axentech'),
        ownerId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 42)), // 6 weeks from now
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(minutes: 15)),
      ),
    ];
  }
}