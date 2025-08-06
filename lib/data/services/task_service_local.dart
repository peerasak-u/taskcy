import '../../domain/models/task.dart';

class TaskServiceLocal {
  static List<Task>? _tasks;
  static int _taskCounter = 20;

  Future<List<Task>> getTasks() async {
    _tasks ??= _seedInitialTasks();
    return List<Task>.from(_tasks!);
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
    _tasks ??= _seedInitialTasks();
    final existingIndex = _tasks!.indexWhere((t) => t.id == task.id);
    
    if (existingIndex != -1) {
      _tasks![existingIndex] = task.copyWith(updatedAt: DateTime.now());
    } else {
      _tasks!.add(task);
    }
    
    return _tasks!.firstWhere((t) => t.id == task.id);
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
    final id = _generateId();
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
    
    print('🔥 TaskServiceLocal: Creating task with id=$id');
    print('🔥 Task title: $title');
    print('🔥 Task dueDate: $dueDate');
    print('🔥 Task projectId: $projectId');
    
    final savedTask = await saveTask(task);
    
    // Debug: Check total tasks after creation
    final allTasks = await getTasks();
    print('🔥 Total tasks after creation: ${allTasks.length}');
    
    return savedTask;
  }

  Future<Task> updateTask(String id, {
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    DateTime? dueDate,
  }) async {
    _tasks ??= _seedInitialTasks();
    final taskIndex = _tasks!.indexWhere((task) => task.id == id);
    
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    
    final updatedTask = _tasks![taskIndex].copyWith(
      title: title,
      description: description,
      status: status,
      priority: priority,
      assigneeId: assigneeId,
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );
    
    _tasks![taskIndex] = updatedTask;
    
    return updatedTask;
  }

  Future<void> deleteTask(String id) async {
    _tasks ??= _seedInitialTasks();
    _tasks!.removeWhere((task) => task.id == id);
  }

  Future<List<Task>> getTasksForDate(DateTime date) async {
    final tasks = await getTasks();
    
    print('🔍 TaskServiceLocal: Getting tasks for date: ${date.year}-${date.month}-${date.day}');
    print('🔍 Total tasks available: ${tasks.length}');
    
    final filteredTasks = tasks.where((task) {
      if (task.dueDate == null) return false;
      
      final matches = task.dueDate!.year == date.year &&
                     task.dueDate!.month == date.month &&
                     task.dueDate!.day == date.day;
      
      if (matches) {
        print('🔍 ✅ Found matching task: ${task.title} (${task.dueDate})');
      }
      
      return matches;
    }).toList();
    
    print('🔍 Filtered tasks for date: ${filteredTasks.length}');
    
    // Debug: Print all tasks with due dates
    print('🔍 All tasks with due dates:');
    for (final task in tasks.where((t) => t.dueDate != null)) {
      print('🔍   - ${task.title}: ${task.dueDate} (${task.dueDate!.year}-${task.dueDate!.month}-${task.dueDate!.day})');
    }
    
    return filteredTasks;
  }

  Future<List<Task>> getTasksByDateRange(DateTime start, DateTime end) async {
    final tasks = await getTasks();
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(start.subtract(const Duration(days: 1))) &&
             task.dueDate!.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<Map<DateTime, int>> getTaskCountsByDateRange(DateTime start, DateTime end) async {
    final tasks = await getTasksByDateRange(start, end);
    final Map<DateTime, int> counts = {};
    
    for (final task in tasks) {
      if (task.dueDate != null) {
        final date = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
        counts[date] = (counts[date] ?? 0) + 1;
      }
    }
    
    return counts;
  }

  String _generateId() {
    _taskCounter++;
    return 'task_$_taskCounter';
  }

  List<Task> _seedInitialTasks() {
    final now = DateTime.now();
    
    return [
      // AxenTech Assignment Tasks (5 tasks)
      Task(
        id: 'task_axentech_1',
        title: 'Learn Flutter fundamentals',
        description: 'Complete Flutter basics course, understand widgets, state management, and development workflow',
        status: TaskStatus.completed,
        priority: TaskPriority.high,
        projectId: 'project_axentech',
        assigneeId: 'user_peerasak',
        dueDate: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: 'task_axentech_2',
        title: 'Setup project structure',
        description: 'Initialize Flutter project with clean architecture, configure dependencies, and setup development environment',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        projectId: 'project_axentech',
        assigneeId: 'user_peerasak',
        dueDate: DateTime(now.year, now.month, now.day, 9, 0), // Today at 9:00 AM
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Task(
        id: 'task_axentech_3',
        title: 'Research state management patterns',
        description: 'Evaluate BLoC, Provider, and Riverpod for project requirements and team expertise',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_axentech',
        assigneeId: 'user_claude',
        dueDate: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: 'task_axentech_4',
        title: 'Implement core UI components',
        description: 'Build reusable widgets, design system components, and navigation structure',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        projectId: 'project_axentech',
        assigneeId: 'user_peerasak',
        dueDate: DateTime(now.year, now.month, now.day, 12, 0), // Today at 12:00 PM
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
      Task(
        id: 'task_axentech_5',
        title: 'Craft typography and visual design',
        description: 'Design typography system, color palette, and visual hierarchy for consistent user experience',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_axentech',
        assigneeId: 'user_claude',
        dueDate: now.add(const Duration(days: 9)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // Pygmy Migration Tasks (6 tasks)
      Task(
        id: 'task_pygmy_1',
        title: 'Setup new Flutter project with guidelines',
        description: 'Initialize Flutter project following established project guidelines and architecture patterns',
        status: TaskStatus.inProgress,
        priority: TaskPriority.urgent,
        projectId: 'project_pygmy',
        assigneeId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 2)), // Due Aug 8
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      Task(
        id: 'task_pygmy_2',
        title: 'Bridge Vision Framework to Flutter',
        description: 'Create platform channel to integrate iOS Vision Framework capabilities with Flutter for OCR functionality',
        status: TaskStatus.todo,
        priority: TaskPriority.high,
        projectId: 'project_pygmy',
        assigneeId: 'user_claude',
        dueDate: now.add(const Duration(days: 14)), // Aug 20 (overdue simulation)
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 'task_pygmy_3',
        title: 'Migrate database from SwiftData to SQLite',
        description: 'Convert existing SwiftData models to SQLite schema and implement data migration scripts',
        status: TaskStatus.todo,
        priority: TaskPriority.high,
        projectId: 'project_pygmy',
        assigneeId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 19)), // Aug 25
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      Task(
        id: 'task_pygmy_4',
        title: 'Research Android OCR solutions',
        description: 'Evaluate ML Kit, Tesseract, and other OCR libraries for Android compatibility and accuracy',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_pygmy',
        assigneeId: 'user_claude',
        dueDate: now.add(const Duration(days: 12)), // Aug 18
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Task(
        id: 'task_pygmy_5',
        title: 'Implement core features migration',
        description: 'Migrate core application features from SwiftUI to Flutter widgets and functionality',
        status: TaskStatus.todo,
        priority: TaskPriority.high,
        projectId: 'project_pygmy',
        assigneeId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 40)), // Sep 15
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: 'task_pygmy_6',
        title: 'Design and craft UI',
        description: 'Design Flutter UI components to match iOS version while optimizing for cross-platform consistency',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_pygmy',
        assigneeId: 'user_claude',
        dueDate: now.add(const Duration(days: 56)), // Oct 1
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // Brand Identity Campaign Tasks (6 tasks)
      Task(
        id: 'task_brand_1',
        title: 'Market research and competitor analysis',
        description: 'Conduct comprehensive market research and analyze competitor brand strategies and positioning',
        status: TaskStatus.completed,
        priority: TaskPriority.high,
        projectId: 'project_brand_identity',
        assigneeId: 'user_sarah',
        dueDate: now.subtract(const Duration(days: 9)), // July 28
        createdAt: now.subtract(const Duration(days: 55)),
        updatedAt: now.subtract(const Duration(days: 9)),
      ),
      Task(
        id: 'task_brand_2',
        title: 'Design brand logo concepts',
        description: 'Create multiple logo variations, color schemes, and brand identity concepts for client review',
        status: TaskStatus.completed,
        priority: TaskPriority.high,
        projectId: 'project_brand_identity',
        assigneeId: 'user_alex',
        dueDate: now.subtract(const Duration(days: 5)), // Aug 1
        createdAt: now.subtract(const Duration(days: 35)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Task(
        id: 'task_brand_3',
        title: 'Create comprehensive brand style guide',
        description: 'Develop detailed brand guidelines including typography, color palettes, usage rules, and applications',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        projectId: 'project_brand_identity',
        assigneeId: 'user_alex',
        dueDate: now.add(const Duration(days: 2)), // Aug 8
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
      Task(
        id: 'task_brand_4',
        title: 'Develop marketing materials',
        description: 'Design brochures, business cards, digital assets, and promotional materials using new brand identity',
        status: TaskStatus.completed,
        priority: TaskPriority.medium,
        projectId: 'project_brand_identity',
        assigneeId: 'user_sarah',
        dueDate: now.subtract(const Duration(days: 2)), // Aug 4
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: 'task_brand_5',
        title: 'Launch social media campaign',
        description: 'Execute social media strategy across platforms with consistent brand messaging and visual identity',
        status: TaskStatus.inProgress,
        priority: TaskPriority.urgent,
        projectId: 'project_brand_identity',
        assigneeId: 'user_sarah',
        dueDate: DateTime(now.year, now.month, now.day, 15, 0), // Today at 3:00 PM
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(minutes: 20)),
      ),
      Task(
        id: 'task_brand_6',
        title: 'Measure campaign effectiveness',
        description: 'Track campaign metrics, analyze engagement data, and prepare effectiveness report for stakeholders',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_brand_identity',
        assigneeId: 'user_sarah',
        dueDate: now.add(const Duration(days: 19)), // Aug 25
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),

      // Personal Productivity Tools Tasks (3 tasks)
      Task(
        id: 'task_personal_1',
        title: 'Define requirements and scope',
        description: 'Document feature requirements, user stories, and project scope for personal productivity utilities',
        status: TaskStatus.inProgress,
        priority: TaskPriority.low,
        projectId: 'project_personal_tools',
        assigneeId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 4)), // Aug 10
        createdAt: now, // Started today
        updatedAt: now.subtract(const Duration(minutes: 10)),
      ),
      Task(
        id: 'task_personal_2',
        title: 'Create wireframes and mockups',
        description: 'Design user interface wireframes and interactive mockups for productivity tool features',
        status: TaskStatus.todo,
        priority: TaskPriority.low,
        projectId: 'project_personal_tools',
        assigneeId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 12)), // Aug 18
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 'task_personal_3',
        title: 'Develop MVP features',
        description: 'Implement minimum viable product with core productivity features and basic user interface',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_personal_tools',
        assigneeId: 'user_peerasak',
        dueDate: now.add(const Duration(days: 26)), // Sep 1
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // Timeline demo tasks with overlapping times to showcase the new system
      Task(
        id: 'task_demo_wireframe',
        title: 'Wireframe elements',
        description: 'Create wireframe elements for the new task list feature',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        projectId: 'project_axentech',
        assigneeId: 'user_peerasak',
        dueDate: DateTime(now.year, now.month, now.day, 10, 0), // 10:00 AM - 11:30 AM (1.5 hours)
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      
      Task(
        id: 'task_demo_mobile_design',
        title: 'Mobile app Design',
        description: 'Design mobile interface and user experience flows',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        projectId: 'project_axentech',
        assigneeId: 'user_claude',
        dueDate: DateTime(now.year, now.month, now.day, 13, 0), // 1:00 PM - 2:00 PM (1 hour)
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      
      Task(
        id: 'task_demo_team_call',
        title: 'Design Team call',
        description: 'Weekly design review and planning meeting with the team',
        status: TaskStatus.todo,
        priority: TaskPriority.urgent,
        projectId: 'project_brand_identity',
        assigneeId: 'user_alex',
        dueDate: DateTime(now.year, now.month, now.day, 16, 0), // 4:00 PM - 4:30 PM (30 min meeting)
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}