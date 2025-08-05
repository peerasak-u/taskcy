import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../services/task_service_local.dart';

class TaskRepositoryLocal implements TaskRepository {
  final TaskServiceLocal _taskService = TaskServiceLocal();

  @override
  Future<List<Task>> getTasks({
    int page = 1,
    int perPage = 20,
    TaskStatus? status,
    TaskPriority? priority,
    String? search,
    String? projectId,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    List<Task> tasks;
    
    if (search != null && search.isNotEmpty) {
      tasks = await _taskService.searchTasks(search);
    } else {
      tasks = await _taskService.getTasks();
    }
    
    // Apply filters
    if (status != null) {
      tasks = tasks.where((task) => task.status == status).toList();
    }
    
    if (priority != null) {
      tasks = tasks.where((task) => task.priority == priority).toList();
    }
    
    if (projectId != null) {
      tasks = tasks.where((task) => task.projectId == projectId).toList();
    }
    
    // Apply pagination
    final startIndex = (page - 1) * perPage;
    final endIndex = startIndex + perPage;
    
    if (startIndex >= tasks.length) {
      return [];
    }
    
    return tasks.sublist(
      startIndex,
      endIndex > tasks.length ? tasks.length : endIndex,
    );
  }

  @override
  Future<Task> getTaskById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final task = await _taskService.getTaskById(id);
    if (task == null) {
      throw Exception('Task not found');
    }
    return task;
  }

  @override
  Future<Task> createTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    required String projectId,
    String? assigneeId,
    DateTime? dueDate,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    return await _taskService.createTask(
      title: title,
      description: description,
      status: status,
      priority: priority,
      projectId: projectId,
      assigneeId: assigneeId,
      dueDate: dueDate,
    );
  }

  @override
  Future<Task> updateTask(
    String id, {
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    DateTime? dueDate,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    return await _taskService.updateTask(
      id,
      title: title,
      description: description,
      status: status,
      priority: priority,
      assigneeId: assigneeId,
      dueDate: dueDate,
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    await _taskService.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasksByProject(String projectId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _taskService.getTasksByProject(projectId);
  }

  @override
  Future<List<Task>> getTasksByAssignee(String assigneeId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _taskService.getTasksByAssignee(assigneeId);
  }
}