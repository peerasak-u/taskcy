import '../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({
    int page = 1,
    int perPage = 20,
    TaskStatus? status,
    TaskPriority? priority,
    String? search,
    String? projectId,
  });

  Future<Task> getTaskById(String id);

  Future<Task> createTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    required String projectId,
    String? assigneeId,
    DateTime? dueDate,
  });

  Future<Task> updateTask(
    String id, {
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    DateTime? dueDate,
  });

  Future<void> deleteTask(String id);

  Future<List<Task>> getTasksByProject(String projectId);

  Future<List<Task>> getTasksByAssignee(String assigneeId);
}