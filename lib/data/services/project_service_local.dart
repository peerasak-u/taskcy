import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/project.dart';

class ProjectServiceLocal {
  static const String _projectsKey = 'projects';
  static const String _projectCounterKey = 'project_counter';

  Future<List<Project>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = prefs.getStringList(_projectsKey) ?? [];
    
    return projectsJson.map((json) {
      final Map<String, dynamic> projectMap = jsonDecode(json);
      return Project(
        id: projectMap['id'],
        name: projectMap['name'],
        description: projectMap['description'],
        teamId: projectMap['teamId'],
        ownerId: projectMap['ownerId'],
        dueDate: projectMap['dueDate'] != null ? DateTime.parse(projectMap['dueDate']) : null,
        createdAt: DateTime.parse(projectMap['createdAt']),
        updatedAt: DateTime.parse(projectMap['updatedAt']),
      );
    }).toList();
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
    return projects.where((project) => project.teamId == teamId).toList();
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
    final projects = await getProjects();
    final existingIndex = projects.indexWhere((p) => p.id == project.id);
    
    if (existingIndex != -1) {
      projects[existingIndex] = project.copyWith(updatedAt: DateTime.now());
    } else {
      projects.add(project);
    }
    
    await _saveProjects(projects);
    return projects.firstWhere((p) => p.id == project.id);
  }

  Future<Project> createProject({
    required String name,
    required String description,
    required String teamId,
    required String ownerId,
    DateTime? dueDate,
  }) async {
    final id = await _generateId();
    final now = DateTime.now();
    
    final project = Project(
      id: id,
      name: name,
      description: description,
      teamId: teamId,
      ownerId: ownerId,
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
    );
    
    return await saveProject(project);
  }

  Future<Project> updateProject(String id, {
    String? name,
    String? description,
    DateTime? dueDate,
  }) async {
    final projects = await getProjects();
    final projectIndex = projects.indexWhere((project) => project.id == id);
    
    if (projectIndex == -1) {
      throw Exception('Project not found');
    }
    
    final updatedProject = projects[projectIndex].copyWith(
      name: name,
      description: description,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );
    
    projects[projectIndex] = updatedProject;
    await _saveProjects(projects);
    
    return updatedProject;
  }

  Future<void> deleteProject(String id) async {
    final projects = await getProjects();
    projects.removeWhere((project) => project.id == id);
    await _saveProjects(projects);
  }

  Future<String> _generateId() async {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt(_projectCounterKey) ?? 0;
    final newCounter = counter + 1;
    await prefs.setInt(_projectCounterKey, newCounter);
    return 'project_$newCounter';
  }

  Future<void> _saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final projectsJson = projects.map((project) {
      return jsonEncode({
        'id': project.id,
        'name': project.name,
        'description': project.description,
        'teamId': project.teamId,
        'ownerId': project.ownerId,
        'dueDate': project.dueDate?.toIso8601String(),
        'createdAt': project.createdAt.toIso8601String(),
        'updatedAt': project.updatedAt.toIso8601String(),
      });
    }).toList();
    
    await prefs.setStringList(_projectsKey, projectsJson);
  }
}