import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/task.dart';

class TaskServiceLocal {
  static const String _tasksKey = 'tasks';
  static const String _taskCounterKey = 'task_counter';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    
    return tasksJson.map((json) {
      final Map<String, dynamic> taskMap = jsonDecode(json);
      return Task(
        id: taskMap['id'],
        title: taskMap['title'],
        description: taskMap['description'],
        status: TaskStatus.values.firstWhere((s) => s.name == taskMap['status']),
        priority: TaskPriority.values.firstWhere((p) => p.name == taskMap['priority']),
        projectId: taskMap['projectId'],
        assigneeId: taskMap['assigneeId'],
        dueDate: taskMap['dueDate'] != null ? DateTime.parse(taskMap['dueDate']) : null,
        createdAt: DateTime.parse(taskMap['createdAt']),
        updatedAt: DateTime.parse(taskMap['updatedAt']),
      );
    }).toList();
  }

  Future<Task?> getTaskById(String id) async {
    final tasks = await getTasks();
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Task>> getTasksByProject(String projectId) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.projectId == projectId).toList();
  }

  Future<List<Task>> getTasksByAssignee(String assigneeId) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.assigneeId == assigneeId).toList();
  }

  Future<List<Task>> searchTasks(String query) async {
    final tasks = await getTasks();
    final lowerQuery = query.toLowerCase();
    
    return tasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
             task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.status == status).toList();
  }

  Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    final tasks = await getTasks();
    return tasks.where((task) => task.priority == priority).toList();
  }

  Future<Task> saveTask(Task task) async {
    final tasks = await getTasks();
    final existingIndex = tasks.indexWhere((t) => t.id == task.id);
    
    if (existingIndex != -1) {
      tasks[existingIndex] = task.copyWith(updatedAt: DateTime.now());
    } else {
      tasks.add(task);
    }
    
    await _saveTasks(tasks);
    return tasks.firstWhere((t) => t.id == task.id);
  }

  Future<Task> createTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    required String projectId,
    String? assigneeId,
    DateTime? dueDate,
  }) async {
    final id = await _generateId();
    final now = DateTime.now();
    
    final task = Task(
      id: id,
      title: title,
      description: description,
      status: status,
      priority: priority,
      projectId: projectId,
      assigneeId: assigneeId,
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
    );
    
    return await saveTask(task);
  }

  Future<Task> updateTask(String id, {
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    DateTime? dueDate,
  }) async {
    final tasks = await getTasks();
    final taskIndex = tasks.indexWhere((task) => task.id == id);
    
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    
    final updatedTask = tasks[taskIndex].copyWith(
      title: title,
      description: description,
      status: status,
      priority: priority,
      assigneeId: assigneeId,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );
    
    tasks[taskIndex] = updatedTask;
    await _saveTasks(tasks);
    
    return updatedTask;
  }

  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == id);
    await _saveTasks(tasks);
  }

  Future<String> _generateId() async {
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt(_taskCounterKey) ?? 0;
    final newCounter = counter + 1;
    await prefs.setInt(_taskCounterKey, newCounter);
    return 'task_$newCounter';
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) {
      return jsonEncode({
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'status': task.status.name,
        'priority': task.priority.name,
        'projectId': task.projectId,
        'assigneeId': task.assigneeId,
        'dueDate': task.dueDate?.toIso8601String(),
        'createdAt': task.createdAt.toIso8601String(),
        'updatedAt': task.updatedAt.toIso8601String(),
      });
    }).toList();
    
    await prefs.setStringList(_tasksKey, tasksJson);
  }
}