# Flutter Clean Architecture Project Guideline

This document serves as a comprehensive system prompt for agents working with Flutter applications following clean architecture principles. It outlines the blueprint for building scalable, maintainable Flutter apps with proper state management, navigation patterns, and development workflows.

## Project Philosophy

This project structure assumes you're **NOT starting from scratch**. Flutter's `flutter create` command provides excellent boilerplate code. This guideline focuses on **evolving** that boilerplate into a production-ready, scalable architecture that supports:

- **Authentication flows** outside the main app scaffold
- **Onboarding experiences** for first-time users
- **Multi-tab navigation** with persistent state
- **Nested navigation** within each tab
- **Overlay presentation** (full-screen, half-screen, content-height modals)
- **Clean separation** of business logic from UI

## Core Architecture Principles

### 1. Clean Architecture Layers

```
lib/
├── main.dart                    # App entry point with provider setup
├── config/                      # App configuration and provider management
│   └── app_providers.dart       # Centralized BLoC provider configuration
├── routing/                     # Navigation and routing configuration
│   ├── app_router.dart          # Main GoRouter configuration
│   ├── auth_routes.dart         # Authentication route definitions
│   ├── home_routes.dart         # Home tab route definitions
│   ├── project_routes.dart      # Project tab route definitions
│   ├── chat_routes.dart         # Chat tab route definitions
│   ├── profile_routes.dart      # Profile tab route definitions
│   └── route_utils.dart         # Routing utilities and helpers
├── data/                        # Data layer - external interfaces
│   ├── model/                   # API request/response models (JSON serializable)
│   ├── repositories/            # Repository implementations (concrete classes)
│   └── services/                # API services, local storage, external services
├── domain/                      # Domain layer - business logic core
│   ├── models/                  # Domain entities (pure business objects)
│   └── repositories/            # Repository contracts (abstract classes)
├── ui/                          # Presentation layer - user interface
│   ├── core/                    # Shared UI infrastructure
│   │   ├── auth/                # App-level authentication state
│   │   ├── navigation/          # Navigation state management (NavigationCubit)
│   │   ├── theme/               # Theme management
│   │   ├── ui/                  # Core UI components (App, MainScaffold)
│   │   └── widgets/             # Reusable UI components
│   ├── [feature]/               # Feature-specific UI modules
│   │   ├── bloc/                # Complex state management (BLoC pattern)
│   │   ├── cubit/               # Simple state management (Cubit pattern)
│   │   ├── view_model/          # Data transformation for UI
│   │   └── widgets/             # Feature-specific UI components
│   └── ...                      # Additional features (auth, onboarding, etc.)
└── utils/                       # Utilities and helpers
```

### 2. State Management Decision Matrix

**Use BLoC When:**

- Complex business logic with multiple related events
- Async operations with loading, success, error states
- Business logic requiring isolation for testing
- Operations involving repositories or external services
- State transformations requiring multiple steps

**Use Cubit When:**

- Simple state changes (toggle, update single value)
- UI state management (selected tab, theme mode, filters)
- Form state management without complex validation
- Navigation state management
- Feature flags and configuration state

**Examples:**

```dart
// BLoC: Complex business logic with events/states
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  // Handles: LoadTasks, CreateTask, UpdateTask, DeleteTask, SearchTasks
  // States: TaskInitial, TaskLoading, TaskLoaded, TaskError, TaskCreating
}

// Cubit: Simple state management
class NavigationCubit extends Cubit<NavigationTab> {
  // Simple enum state with direct methods: selectTab(), goToHome()
}
```

## Authentication & Navigation Blueprint

### App-Level Navigation Architecture

The authentication flow is designed to route users through different screens based on their state, without disrupting the main application scaffold:

```
App Launch
├── AuthInitial (Loading) → CircularProgressIndicator
├── AuthOnboarding → OnboardingScreen (first-time users)
├── AuthUnauthenticated → AuthScreen (login/register)
└── AuthAuthenticated → MainScaffold (main app with tabs)
```

### Key Components

**1. GoRouter Configuration (`lib/routing/app_router.dart`)**

```dart
final appRouter = GoRouter(
  initialLocation: '/home',
  redirect: (BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;

    // Authentication guards - declarative routing
    if (authState is AuthOnboarding) return '/onboarding';
    if (authState is AuthUnauthenticated) return '/auth';
    if (authState is AuthAuthenticated &&
        (state.matchedLocation == '/auth')) return '/home';

    return null; // No redirect needed
  },
  routes: [
    // Authentication routes (outside main shell)
    GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),
    GoRoute(path: '/auth', builder: (_, __) => AuthScreen()),

    // Main app with StatefulShellRoute for tab navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
        MainScaffold(navigationShell: navigationShell),
      branches: [/* tab branches */],
    ),
  ],
);
```

**2. MaterialApp.router Integration (`lib/main.dart`)**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.providers,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'My First Flutter App',
            theme: themeState.currentTheme,
            routerConfig: appRouter, // GoRouter handles all routing
          );
        },
      ),
    );
  }
}
```

**3. AuthCubit States & Flow**

```dart
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {}           // Loading/checking auth
class AuthOnboarding extends AuthState {}        // Show onboarding
class AuthUnauthenticated extends AuthState {}   // Show login/register
class AuthAuthenticated extends AuthState {      // Show main app
  final String? userId;
  final String? userEmail;
}
```

**4. Persistent Storage Strategy**

```dart
class AuthService {
  // Manages persistent authentication state
  Future<bool> isAuthenticated();
  Future<bool> isOnboardingCompleted();
  Future<void> setAuthenticated({required bool isAuthenticated, String? userId, String? userEmail});
  Future<void> setOnboardingCompleted(bool completed);
  Future<void> logout();
}
```

### Provider Organization Pattern

**AppProviders Class (`lib/config/app_providers.dart`)**

```dart
class AppProviders {
  static List<BlocProvider> get providers => [
    // Authentication (highest level)
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(AuthService())..checkAuthStatus(),
    ),

    // Core app functionality
    BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
    BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),

    // Complex business logic (BLoCs)
    BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(taskRepository: TaskRepositoryRemote()),
    ),

    // Simple state management (Cubits)
    BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
    BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
    BlocProvider<TaskFilterCubit>(create: (context) => TaskFilterCubit()),
  ];
}
```

## Modern Navigation with GoRouter

### GoRouter + StatefulShellRoute Architecture

**Modern Approach**: Use **GoRouter with StatefulShellRoute.indexedStack** for declarative routing while preserving tab state - maintaining the same UX benefits as manual IndexedStack.

```dart
// lib/routing/app_router.dart
final appRouter = GoRouter(
  initialLocation: '/home',
  redirect: (BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthOnboarding) return '/onboarding';
    if (authState is AuthUnauthenticated) return '/auth';
    if (authState is AuthAuthenticated &&
        (state.matchedLocation == '/auth')) return '/home';

    return null;
  },
  routes: [
    // Authentication routes
    GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),
    GoRoute(path: '/auth', builder: (_, __) => AuthScreen()),

    // Main app with stateful shell for bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
        MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => HomeScreen(),
              routes: [
                GoRoute(
                  path: 'task/:taskId',
                  builder: (_, state) => TaskDetailScreen(
                    taskId: state.pathParameters['taskId']!
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/project', builder: (_, __) => ProjectScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/chat', builder: (_, __) => ChatScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/profile', builder: (_, __) => ProfileScreen())],
        ),
      ],
    ),
  ],
);
```

### Modular Route Organization

The routing configuration is now organized into separate files for better maintainability:

```dart
// lib/routing/app_router.dart - Main router configuration
final appRouter = GoRouter(
  initialLocation: RouteUtils.homePath,
  redirect: RouteUtils.handleAuthRedirect,
  routes: [
    ...AuthRoutes.routes,        // Authentication routes
    StatefulShellRoute.indexedStack(
      builder: RouteUtils.shellBuilder,
      branches: [
        HomeRoutes.branch,       // Home tab routes
        ProjectRoutes.branch,    // Project tab routes
        ChatRoutes.branch,       // Chat tab routes
        ProfileRoutes.branch,    // Profile tab routes
      ],
    ),
  ],
);

// lib/routing/home_routes.dart - Home tab route definitions
class HomeRoutes {
  static StatefulShellBranch get branch => StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'task/:taskId',
            builder: (_, state) => TaskDetailScreen(
              taskId: state.pathParameters['taskId']!,
            ),
          ),
        ],
      ),
    ],
  );
}

// lib/routing/route_utils.dart - Common routing utilities
class RouteUtils {
  static const String homePath = '/home';

  static String? handleAuthRedirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;
    // Authentication logic...
  }

  static Widget shellBuilder(context, state, navigationShell) {
    return MainScaffold(navigationShell: navigationShell);
  }
}
```

**Benefits of Modular Routing:**

- ✅ **Better Organization** - Each tab's routes are in separate files
- ✅ **Easier Maintenance** - Changes to one tab don't affect others
- ✅ **Team Development** - Multiple developers can work on different route files
- ✅ **Testability** - Individual route modules can be tested in isolation
- ✅ **Scalability** - Easy to add new tabs and nested routes

### MainScaffold with NavigationShell

```dart
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: navigationShell, // GoRouter manages the IndexedStack internally
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _getBottomNavigationIndex(currentLocation),
        onTap: (index) => _onTabTapped(context, index),
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    if (index == 2) {
      _showCreateTaskDialog(context);
      return;
    }

    // Simple branch navigation - no complex navigator key management
    int branchIndex = _mapIndexToBranch(index);
    navigationShell.goBranch(branchIndex);
  }
}
```

### Benefits of GoRouter + StatefulShellRoute

- ✅ **Same UX as IndexedStack** - StatefulShellRoute.indexedStack preserves screen state
- ✅ **Smooth tab switching** - No rebuild/reload behavior (same as before)
- ✅ **Preserved scroll positions** - Users stay where they left off
- ✅ **Maintained form data** - In-progress forms don't reset
- ✅ **Declarative routing** - All routes defined in one configuration
- ✅ **Built-in deep linking** - URL-based routing ready out of the box
- ✅ **Authentication guards** - Declarative redirect logic
- ✅ **Simplified navigation** - `context.go('/path')` instead of complex Navigator.push()
- ✅ **Better maintainability** - Centralized route configuration
- ✅ **No navigator key management** - GoRouter handles complexity internally

## Multi-Screen Navigation Strategies

### 1. Nested Navigation Within Tabs

Each tab maintains its own navigation stack using StatefulShellBranch nested routes:

```dart
// OLD way: Complex Navigator.push()
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId: taskId)),
);

// NEW way: Simple GoRouter navigation
context.go('/home/task/$taskId');

// Benefits:
// - Bottom navigation remains visible
// - Back button returns to HomeScreen within the same tab
// - URL-based routing for deep linking
// - Type-safe parameter passing
```

### 2. Full-Screen Overlays

For screens that should cover the entire interface including bottom navigation:

```dart
// Method 1: Dialog-based overlays
void _showCreateTaskDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => CreateTaskDialog(),
  );
}

// Method 2: Route-based full-screen overlays
Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    builder: (context) => FullScreenCreateTask(),
    fullscreenDialog: true,
  ),
);
```

### 3. Half-Screen and Content-Height Modals

For future modal presentations (similar to UIKit's presentation styles):

```dart
// Bottom sheet for half-screen content
void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return YourModalContent(scrollController: scrollController);
      },
    ),
  );
}

// Content-height modal
void _showContentHeightModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => Wrap(
      children: [YourContentHeightWidget()],
    ),
  );
}
```

### 4. Advanced GoRouter Patterns

For complex navigation requirements with GoRouter:

```dart
// Custom route matching and parameters
GoRoute(
  path: '/task/:taskId/edit',
  builder: (context, state) {
    final taskId = state.pathParameters['taskId']!;
    final isEditMode = state.uri.queryParameters['edit'] == 'true';

    return TaskDetailScreen(
      taskId: taskId,
      isEditMode: isEditMode,
    );
  },
),

// Conditional routing based on user permissions
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final user = context.read<AuthCubit>().state;
    if (user is AuthAuthenticated && !user.isAdmin) {
      return '/home'; // Redirect non-admin users
    }
    return null; // Allow access
  },
  builder: (_, __) => AdminScreen(),
),

// Custom page transitions
GoRoute(
  path: '/settings',
  pageBuilder: (context, state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: SettingsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
          ),
          child: child,
        );
      },
    );
  },
),
```

## Asset Management System

### Structured Asset Organization

```
assets/
├── icons/
│   ├── bottom_bar/              # Navigation icons
│   │   ├── home_outlined.svg
│   │   ├── home_filled.svg
│   │   ├── chat_outlined.svg
│   │   └── chat_filled.svg
│   ├── actions/                 # Action icons (add, edit, delete)
│   │   ├── add.svg
│   │   ├── edit.svg
│   │   └── delete.svg
│   └── status/                  # Status indicators
│       ├── success.svg
│       ├── error.svg
│       └── warning.svg
├── images/                      # App images and illustrations
│   ├── logos/
│   ├── backgrounds/
│   └── illustrations/
└── fonts/                       # Custom fonts
    ├── primary/
    └── secondary/
```

### Type-Safe Asset Access Pattern

```dart
class AppIcons {
  static const bottomBar = _BottomBarIcons();
  static const actions = _ActionIcons();
  static const status = _StatusIcons();
}

class _BottomBarIcons {
  const _BottomBarIcons();

  Widget homeOutlined({Color? color, double? size}) => SvgPicture.asset(
    'assets/icons/bottom_bar/home_outlined.svg',
    color: color,
    width: size,
    height: size,
  );

  Widget homeFilled({Color? color, double? size}) => SvgPicture.asset(
    'assets/icons/bottom_bar/home_filled.svg',
    color: color,
    width: size,
    height: size,
  );
}

// Usage: AppIcons.bottomBar.homeOutlined(color: Colors.blue, size: 24)
```

### Asset Configuration in pubspec.yaml

```yaml
flutter:
  assets:
    - assets/icons/bottom_bar/
    - assets/icons/actions/
    - assets/icons/status/
    - assets/images/logos/
    - assets/images/backgrounds/
    - assets/images/illustrations/

  fonts:
    - family: PrimaryFont
      fonts:
        - asset: assets/fonts/primary/Regular.ttf
        - asset: assets/fonts/primary/Bold.ttf
          weight: 700
```

## Repository & Service Patterns

### Repository Pattern Implementation

**Domain Layer (Abstract)**

```dart
abstract class TaskRepository {
  Future<List<Task>> getTasks({
    int page = 1,
    int perPage = 20,
    TaskStatus? status,
    TaskPriority? priority,
    String? search,
  });

  Future<Task> createTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
  });

  Future<Task> updateTask(String id, {/* parameters */});
  Future<void> deleteTask(String id);
}
```

**Data Layer (Implementation)**

```dart
class TaskRepositoryRemote implements TaskRepository {
  final TaskService _taskService;

  TaskRepositoryRemote({TaskService? taskService})
    : _taskService = taskService ?? TaskService();

  @override
  Future<List<Task>> getTasks({/* parameters */}) async {
    final apiResponse = await _taskService.getTasks(/* parameters */);
    return apiResponse.tasks.map((apiModel) => apiModel.toDomain()).toList();
  }
}
```

### Service Layer Pattern

```dart
class TaskService {
  final http.Client _httpClient;
  final String _baseUrl;

  TaskService({http.Client? httpClient, String? baseUrl})
    : _httpClient = httpClient ?? http.Client(),
      _baseUrl = baseUrl ?? 'https://api.example.com';

  Future<TaskListResponseApiModel> getTasks({
    int page = 1,
    int perPage = 20,
    TaskStatus? status,
    TaskPriority? priority,
    String? search,
  }) async {
    final uri = Uri.parse('$_baseUrl/tasks').replace(queryParameters: {
      'page': page.toString(),
      'per_page': perPage.toString(),
      if (status != null) 'status': status.name,
      if (priority != null) 'priority': priority.name,
      if (search != null) 'search': search,
    });

    final response = await _httpClient.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return TaskListResponseApiModel.fromJson(json);
    } else {
      throw TaskServiceException('Failed to load tasks: ${response.statusCode}');
    }
  }
}
```

### Data Model Transformation Pattern

**API Model (Data Layer)**

```dart
@JsonSerializable()
class TaskApiModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  // JSON serialization methods
  factory TaskApiModel.fromJson(Map<String, dynamic> json) =>
      _$TaskApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskApiModelToJson(this);

  // Domain conversion
  Task toDomain() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: TaskStatus.values.byName(status),
      priority: TaskPriority.values.byName(priority),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
```

**Domain Model (Domain Layer)**

```dart
class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
  });

  // Business logic methods
  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  Task copyWith({/* parameters */}) {
    return Task(/* implementation */);
  }
}
```

## Testing Architecture

### Test Structure Organization

```
test/
├── data/                        # Data layer tests
│   ├── model/                   # API model tests
│   ├── repositories/            # Repository implementation tests
│   └── services/                # Service layer tests
├── domain/                      # Domain layer tests
│   ├── models/                  # Domain entity tests
│   └── repositories/            # Repository contract tests
├── ui/                          # UI layer tests
│   ├── core/                    # Core UI component tests
│   ├── [feature]/               # Feature-specific tests
│   │   ├── bloc/                # BLoC tests
│   │   ├── cubit/               # Cubit tests
│   │   └── widgets/             # Widget tests
│   └── integration/             # Integration tests
├── utils/                       # Utility tests
└── widget_test.dart             # Generated widget test
```

### BLoC Testing Pattern

```dart
class TaskBlocTest {
  late TaskBloc taskBloc;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    taskBloc = TaskBloc(taskRepository: mockTaskRepository);
  });

  group('TaskBloc', () {
    test('initial state is TaskInitial', () {
      expect(taskBloc.state, equals(const TaskInitial()));
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskLoaded] when LoadTasks is successful',
      build: () {
        when(() => mockTaskRepository.getTasks())
            .thenAnswer((_) async => [mockTask]);
        return taskBloc;
      },
      act: (bloc) => bloc.add(const LoadTasks()),
      expect: () => [
        const TaskLoading(),
        TaskLoaded(tasks: [mockTask]),
      ],
    );
  });
}
```

### Widget Testing Pattern

```dart
class HomeScreenTest extends StatelessWidget {
  testWidgets('displays task list when loaded', (WidgetTester tester) async {
    // Arrange
    final mockTaskBloc = MockTaskBloc();
    when(() => mockTaskBloc.state).thenReturn(
      TaskLoaded(tasks: [mockTask]),
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TaskBloc>.value(
          value: mockTaskBloc,
          child: const HomeScreen(),
        ),
      ),
    );

    // Assert
    expect(find.text(mockTask.title), findsOneWidget);
    expect(find.byType(TaskListItem), findsOneWidget);
  });
}
```

### Repository Testing with Mocks

```dart
class TaskRepositoryRemoteTest {
  late TaskRepositoryRemote repository;
  late MockTaskService mockTaskService;

  setUp(() {
    mockTaskService = MockTaskService();
    repository = TaskRepositoryRemote(taskService: mockTaskService);
  });

  test('getTasks returns domain models when service succeeds', () async {
    // Arrange
    final apiResponse = TaskListResponseApiModel(
      tasks: [mockTaskApiModel],
      total: 1,
    );
    when(() => mockTaskService.getTasks()).thenAnswer((_) async => apiResponse);

    // Act
    final result = await repository.getTasks();

    // Assert
    expect(result, isA<List<Task>>());
    expect(result.first.id, equals(mockTaskApiModel.id));
    verify(() => mockTaskService.getTasks()).called(1);
  });
}
```

## Development Workflow & Code Quality

### Essential Commands

**Development**

```bash
flutter run                     # Run app (add -d chrome for web, -d macos for macOS)
flutter run --hot-reload        # Run with hot reload enabled
flutter hot-reload              # Trigger hot reload (r in terminal)
flutter hot-restart             # Trigger hot restart (R in terminal)
```

**Dependencies**

```bash
flutter pub get                 # Install dependencies
flutter pub upgrade             # Upgrade dependencies
flutter pub outdated            # Check for outdated dependencies
dart run build_runner build     # Generate JSON serialization code
```

**Code Quality**

```bash
flutter analyze                 # Run static analysis
flutter test                    # Run all tests
flutter test test/specific_test.dart  # Run specific test
flutter doctor                  # Check Flutter installation
```

**Build**

```bash
flutter build apk              # Build Android APK
flutter build ios              # Build iOS app (requires macOS)
flutter build web              # Build web version
flutter build macos            # Build macOS app
flutter build windows          # Build Windows app
flutter build linux            # Build Linux app
```

### Code Generation Workflow

For JSON serialization and other code generation:

```bash
# Generate code (run after modifying @JsonSerializable classes)
dart run build_runner build

# Generate code with conflict resolution
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
dart run build_runner watch
```

### Linting Configuration

**analysis_options.yaml**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    avoid_print: true
    prefer_single_quotes: true
```

### Git Workflow Integration

**Pre-commit Hooks (Recommended)**

```bash
# Run before committing
flutter analyze && flutter test
```

**CI/CD Pipeline Checks**

```yaml
# Example GitHub Actions
- name: Analyze
  run: flutter analyze

- name: Test
  run: flutter test

- name: Build
  run: flutter build apk --release
```

## Key Dependencies & Versions

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5

  # Navigation & Routing
  go_router: ^14.2.7

  # Networking & Serialization
  http: ^1.1.0
  json_annotation: ^4.8.1

  # Storage & Authentication
  shared_preferences: ^2.2.2

  # UI & UX
  cupertino_icons: ^1.0.8
  shimmer: ^3.0.0
  flutter_svg: ^2.0.9 # For SVG asset management

  # Utilities
  intl: ^0.19.0 # Date formatting

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Quality
  flutter_lints: ^5.0.0

  # Code Generation
  json_serializable: ^6.7.1
  build_runner: ^2.4.7

  # Testing
  bloc_test: ^9.1.0
  mocktail: ^0.3.0
```

## Best Practices & Conventions

### 1. File Naming Conventions

- **snake_case** for file names: `task_repository.dart`
- **PascalCase** for class names: `TaskRepository`
- **camelCase** for method and variable names: `getTasks()`

### 2. Folder Organization

- Group by feature, not by file type
- Keep shared/core components separate from feature-specific code
- Mirror test structure with main code structure

### 3. State Management Guidelines

- One BLoC/Cubit per feature or major functionality
- Keep states and events immutable using `Equatable`
- Use meaningful state and event names
- Handle loading and error states consistently

### 4. Navigation Best Practices

- Use **GoRouter with StatefulShellRoute.indexedStack** for bottom navigation
- Define routes declaratively in `app_router.dart` configuration
- Use `context.go('/path')` for navigation instead of `Navigator.push()`
- Implement authentication guards using GoRouter's `redirect` parameter
- Use nested routes under StatefulShellBranch for tab-specific navigation
- Consider user experience when designing navigation flows and URL structure

### 5. Error Handling

- Create custom exception classes for different error types
- Handle network errors gracefully with user-friendly messages
- Implement retry mechanisms for failed operations
- Log errors appropriately for debugging

### 6. Performance Considerations

- Use `const` constructors wherever possible
- Implement lazy loading for large lists
- Cache frequently accessed data
- Use `ListView.builder` for dynamic lists
- Implement pull-to-refresh for data lists

### 7. Security Best Practices

- Never store sensitive data in plain text
- Use secure storage for authentication tokens
- Validate input data before processing
- Implement proper error handling to avoid information leakage

## Future Extensibility Patterns

### 1. Adding New Features

1. Create feature folder under `lib/ui/[feature_name]/`
2. Add BLoC/Cubit for state management
3. Implement repository if external data is needed
4. Add to `AppProviders` if global state is required
5. Create tests following the established structure

### 2. Adding New Navigation Tabs

1. Create new screen widget
2. Add new `StatefulShellBranch` to `app_router.dart`
3. Define routes for the new tab (including nested routes if needed)
4. Update `MainScaffold._getBottomNavigationIndex()` mapping
5. Update `MainScaffold._onTabTapped()` branch index mapping
6. Add new tab icon to `CustomBottomNavigation`
7. Optional: Keep `NavigationTab` enum for UI state management if needed

### 3. Implementing Feature Flags

```dart
class FeatureFlags {
  static const bool enableExperimentalUI = true;
  static const bool enableAdvancedFilters = false;

  static bool isEnabled(String featureName) {
    // Implement remote configuration logic
    return true;
  }
}
```

### 4. Adding Localization

```dart
// Add to dependencies
flutter_localizations:
  sdk: flutter
intl: any

// Generate localization files
flutter gen-l10n
```

## Color Theme System

### Overview

The application uses a centralized color system built on Flutter's Material Theme with custom extensions. All colors are defined as constants in `AppColors` class for optimal performance and consistency.

### Color Architecture

```
lib/ui/core/theme/
├── app_colors.dart              # Core color constants
├── custom_colors_extension.dart # Theme extension wrapper  
└── theme_state.dart            # Complete theme configuration
```

### Color Palette

The app uses a carefully designed color palette optimized for both light and dark themes:

**Brand Colors**
- **Primary**: `#756EF3` (Purple) - Main brand color for primary actions
- **Secondary**: `#D1E2FE` (Light Purple) - Supporting brand elements
- **Background**: `#FFFFFF` (White) - Main background color

**Functional Colors**
- **Blue**: `#63B4FF` - Information and secondary actions
- **Green**: `#B1D199` - Success states and positive actions  
- **Orange**: `#FFB35A` - Warning states and in-progress indicators
- **Red**: `#FF5757` - Error states and destructive actions

**Text Colors**
- **Primary**: `#1A1A1A` - Main text content
- **Secondary**: `#757575` - Supporting text
- **Light**: `#BDBDBD` - Placeholder and disabled text

**Surface Colors**
- **Surface**: `#F8F9FA` - Card backgrounds
- **Surface Variant**: `#F3F4F6` - Alternative surfaces
- **Outline**: `#E0E0E0` - Borders and dividers

### Usage Patterns

#### 1. Direct Color Access (Recommended)

Use `AppColors` directly for best performance:

```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Primary Button',
    style: TextStyle(color: Colors.white),
  ),
)
```

#### 2. Semi-Transparent Colors

Use `withValues(alpha: ...)` for transparency:

```dart
Card(
  color: AppColors.green.withValues(alpha: 0.1), // 10% opacity
  child: Column(
    children: [
      Icon(Icons.check_circle, color: AppColors.success),
      Text('Completed', style: TextStyle(color: AppColors.success)),
    ],
  ),
)
```

#### 3. Status-Based Color Usage

Use semantic color names for status indicators:

```dart
// Task status cards
Widget buildStatusCard(TaskStatus status) {
  late Color cardColor;
  late Color iconColor;
  late IconData icon;
  
  switch (status) {
    case TaskStatus.completed:
      cardColor = AppColors.green.withValues(alpha: 0.1);
      iconColor = AppColors.success;
      icon = Icons.check_circle;
      break;
    case TaskStatus.inProgress:
      cardColor = AppColors.orange.withValues(alpha: 0.1);
      iconColor = AppColors.warning;
      icon = Icons.access_time;
      break;
    case TaskStatus.todo:
      cardColor = AppColors.blue.withValues(alpha: 0.1);
      iconColor = AppColors.info;
      icon = Icons.schedule;
      break;
  }
  
  return Card(
    color: cardColor,
    child: Column(
      children: [
        Icon(icon, color: iconColor),
        Text(status.displayName, style: TextStyle(color: iconColor)),
      ],
    ),
  );
}
```

#### 4. Progress Indicators

Use graduated colors for progress visualization:

```dart
LinearProgressIndicator(
  value: 0.6,
  backgroundColor: AppColors.progressLow,
  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressHigh),
)
```

#### 5. Theme Extension Access (When Needed)

Use theme extension for complex theming scenarios:

```dart
final customColors = Theme.of(context).extension<CustomColorsExtension>()!;
Container(color: customColors.shadow) // Adapts to light/dark theme
```

### Best Practices

#### 1. Performance Optimization
- **Always prefer `AppColors` constants** over theme extension lookups
- Use `const` constructors when all parameters are compile-time constants
- Cache color values in build methods if expensive calculations are needed

#### 2. Consistency Guidelines
- Use semantic color names (`success`, `warning`, `error`) over direct colors (`green`, `orange`, `red`)
- Maintain consistent opacity levels: 0.1 for subtle backgrounds, 0.2 for hover states
- Follow Material Design color contrast guidelines for accessibility

#### 3. Dark Theme Considerations
- All colors in `AppColors` work for both light and dark themes
- Use `ThemeExtension` only when colors need to adapt between themes
- Test color combinations in both light and dark modes

#### 4. Common Patterns

**Container with Primary Color:**
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('Button', style: TextStyle(color: Colors.white)),
)
```

**Status Indicator:**
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.success.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    'Active',
    style: TextStyle(color: AppColors.success, fontSize: 12),
  ),
)
```

**Card with Shadow:**
```dart
Card(
  elevation: 0,
  color: AppColors.surface,
  shadowColor: AppColors.shadow,
  child: content,
)
```

This centralized color system ensures consistency across the app while maintaining optimal performance and easy maintenance.

This guideline provides a comprehensive blueprint for building scalable Flutter applications with clean architecture, proper state management, and maintainable code patterns. Follow these patterns consistently to ensure your app remains maintainable and extensible as it grows.
