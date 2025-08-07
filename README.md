# Taskcy - Flutter Project Management App

<p align="center">
  <img src="ui-design/Home.png" alt="Taskcy App" width="300"/>
</p>

**Taskcy** is a modern, feature-rich Flutter project management application with a JIRA-like interface but with a more friendly and intuitive UI. Built with Clean Architecture principles, it demonstrates professional Flutter development practices and modern state management patterns.

## 🎯 Project Status

**Current Stage**: Functional Prototype with Local Data Simulation  
**Architecture**: Production-Ready Clean Architecture Implementation  
**UI/UX**: Complete design system with 21+ screen mockups  
**State Management**: BLoC/Cubit pattern with comprehensive implementation  

## ✨ Key Features

- 📊 **Task Management**: Create, assign, and track tasks with status updates
- 🏢 **Project Organization**: Multi-project workspace with team collaboration
- 👥 **Team Management**: User roles, team creation, and member assignment
- 💬 **Team Chat**: Real-time communication within project teams
- 📱 **Modern UI**: Beautiful, responsive design with dark/light theme support
- 🔄 **Real-time Updates**: State synchronization across all screens
- 📈 **Progress Tracking**: Visual progress indicators and statistics

## 🏗️ Architecture Overview

This project demonstrates **Clean Architecture** implementation with clear separation of concerns:

```mermaid
graph TB
    subgraph "UI Layer"
        A[Screens & Widgets]
        B[BLoC/Cubit]
        C[View Models]
    end
    
    subgraph "Domain Layer"
        D[Business Models]
        E[Repository Interfaces]
        F[Use Cases]
    end
    
    subgraph "Data Layer"
        G[Repository Implementations]
        H[Local Services]
        I[Mock Data]
    end
    
    A --> B
    B --> C
    C --> E
    E --> G
    G --> H
    H --> I
    
    B --> D
    E --> D
    G --> D
```

## 🧭 Navigation Structure

The app uses **GoRouter** with **StatefulShellRoute** for sophisticated navigation:

```mermaid
graph TD
    A[App Launch] --> B{Auth Check}
    B -->|First Time| C[Onboarding]
    B -->|Returning| D[Sign In]
    C --> D
    D --> E[Main Shell]
    
    E --> F[Home Tab - Index 0]
    E --> G[Project Tab - Index 1] 
    E --> H[Add Modal - Index 2]
    E --> I[Chat Tab - Index 3]
    E --> J[Profile Tab - Index 4]
    
    F --> F1[Today Tasks]
    F --> F2[Task Details]
    F --> F3[Monthly View]
    
    G --> G1[All Projects]
    G --> G2[In Progress]
    G --> G3[Completed]
    
    H --> H1[Add Task]
    H --> H2[Create Team]
    H --> H3[Create Project]
    
    I --> I1[Team Chats]
    I --> I2[Direct Messages]
    
    J --> J1[Profile Settings]
    J --> J2[Edit Profile]
    J --> J3[Language Settings]
```

## 🏛️ Project Structure

```
lib/
├── config/
│   └── app_providers.dart          # Centralized BLoC providers
├── data/
│   ├── repositories/               # Repository implementations
│   └── services/                   # Local data services (API simulation)
├── domain/
│   ├── models/                     # Business entities
│   └── repositories/               # Repository contracts
├── routing/
│   ├── app_router.dart            # Main router configuration
│   └── [feature]_routes.dart      # Feature-specific routes
├── ui/
│   ├── core/                      # Shared infrastructure
│   │   ├── auth/                  # Authentication state
│   │   ├── navigation/            # Navigation state
│   │   ├── theme/                 # Theme system
│   │   └── widgets/               # Reusable components
│   ├── [feature]/                 # Feature modules
│   │   ├── bloc/                  # BLoC/Cubit for business logic
│   │   ├── view_model/            # View-specific data models
│   │   └── widgets/               # UI components
│   └── shared/                    # Cross-feature widgets
└── main.dart                      # App entry point
```

## 🎨 Design System

### Color Palette
- **Primary**: `#756EF3` (Purple) - Main brand color
- **Secondary**: `#D1E2FE` (Light Blue) - Supporting elements  
- **Blue**: `#63B4FF` - Information and highlights
- **Green**: `#B1D199` - Success states and completed tasks
- **Orange**: `#FFB35A` - Warnings and pending states

### Theme Architecture
```dart
// Centralized color system for optimal performance
Container(color: AppColors.primary)
Card(color: AppColors.green.withValues(alpha: 0.1))
Icon(Icons.check_circle, color: AppColors.success)
```

## 🔧 State Management Strategy

### BLoC Pattern (Complex Business Logic)
- `HomeBloc`: Dashboard data with async operations
- `AddTaskBloc`: Task creation with validation
- `ProjectsBloc`: Project management with filtering
- `ProfileBloc`: User profile with statistics
- `ChatBloc`: Real-time chat functionality

### Cubit Pattern (Simple State)
- `AuthCubit`: Authentication state
- `NavigationCubit`: Tab navigation
- `ThemeCubit`: Theme switching
- `TaskListCubit`: Basic list operations

## 📱 Screen Showcase

<details>
<summary>View All App Screens</summary>

| Home & Dashboard | Projects | Task Management |
|------------------|----------|-----------------|
| ![Home](ui-design/Home.png) | ![Projects](ui-design/Projects.png) | ![Add Task](ui-design/Add%20Task.png) |

| Authentication | Onboarding | Profile |
|----------------|------------|---------|
| ![Sign In](ui-design/Signin.png) | ![Onboarding](ui-design/Onboard%201.png) | ![Profile](ui-design/Profile.png) |

| Chat | Settings | Task Details |
|------|----------|-------------|
| ![Chat](ui-design/Chat.png) | ![Settings](ui-design/Settings.png) | ![Task Details](ui-design/Today%20Task%20Details.png) |

</details>

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK  
- iOS Simulator / Android Emulator
- IDE: VS Code, Android Studio, or IntelliJ

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-username/taskcy.git
cd taskcy
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Development Workflow

```bash
# 🔄 Development
flutter run                        # Launch app with hot reload
flutter hot-reload                  # Trigger hot reload (or press 'r')  
flutter hot-restart                 # Trigger hot restart (or press 'R')

# 📦 Dependencies & Code Generation
flutter pub get                     # Install dependencies
dart run build_runner build        # Generate JSON serialization
dart run build_runner watch        # Auto-generate on changes

# 🧪 Quality Assurance
flutter analyze                     # Static analysis
flutter test                        # Run all tests
flutter doctor                      # Check Flutter setup

# 🏗️ Building
flutter build apk                   # Android APK
flutter build ios                   # iOS (macOS only)
flutter build web                   # Web version
```

## 📦 Dependencies

### Core Framework
- **flutter_bloc** (^8.1.3) - State management with BLoC pattern
- **go_router** (^14.2.7) - Declarative routing and navigation
- **equatable** (^2.0.5) - Value equality for state objects

### Networking & Data
- **http** (^1.1.0) - HTTP client for API calls
- **json_annotation** (^4.8.1) - JSON serialization annotations
- **shared_preferences** (^2.2.2) - Local data persistence

### UI & UX
- **shimmer** (^3.0.0) - Loading state animations
- **flutter_svg** (^2.0.9) - SVG image support
- **intl** (^0.19.0) - Internationalization and date formatting

### Development Tools
- **json_serializable** (^6.7.1) - Code generation for JSON
- **build_runner** (^2.4.7) - Code generation runner
- **bloc_test** (^9.1.0) - Testing utilities for BLoC
- **mocktail** (^0.3.0) - Mocking library for tests

## 🎓 Learning Opportunities

This project demonstrates the following Flutter concepts:

### Advanced Patterns
- ✅ **Clean Architecture** - Separation of concerns with clear boundaries
- ✅ **BLoC Pattern** - Reactive state management for complex logic  
- ✅ **Repository Pattern** - Data access abstraction
- ✅ **Dependency Injection** - Centralized provider configuration

### Modern Flutter Features
- ✅ **GoRouter Navigation** - Type-safe routing with nested navigation
- ✅ **StatefulShellRoute** - Persistent tab navigation
- ✅ **Theme Extensions** - Custom color system
- ✅ **Performance Optimization** - Const constructors and efficient rebuilds

### Development Best Practices
- ✅ **Feature-based Architecture** - Modular code organization
- ✅ **Error Handling** - Comprehensive error states and custom exceptions
- ✅ **Testing Strategy** - Unit tests, widget tests, and BLoC tests
- ✅ **Code Quality** - Linting, analysis, and conventions

## 🔍 Code Conventions

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Methods/Variables**: `camelCase` 
- **Constants**: `SCREAMING_SNAKE_CASE`

### Architecture Rules
- **Domain Layer**: No external dependencies, pure business logic
- **Data Layer**: Repository implementations, service integrations
- **UI Layer**: Widgets, state management, view models

### Performance Guidelines
- Use `const` constructors wherever possible
- Implement `Equatable` for state objects
- Use `AppColors` constants instead of theme lookups
- Prefer `withValues()` over deprecated `withOpacity()`

## 🧪 Testing Strategy

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/domain/models/task_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Structure
- **Unit Tests**: Domain models and business logic
- **Widget Tests**: UI component behavior
- **BLoC Tests**: State management and business flows
- **Integration Tests**: End-to-end user workflows

## 🚀 Production Readiness

### ✅ Current Implementation
- Complete Clean Architecture structure
- Professional state management setup
- Comprehensive UI component library
- Rich mock data for all features
- Modern navigation system
- Theme system with light/dark mode

### 🔄 Production Migration Path
1. Replace local services with HTTP API clients
2. Generate JSON serialization code (`dart run build_runner build`)
3. Implement real authentication providers
4. Add proper error handling for network operations  
5. Configure CI/CD pipeline
6. Add comprehensive test coverage

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the established code conventions
4. Write tests for new functionality  
5. Run `flutter analyze` and `flutter test`
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- UI/UX Design inspiration from modern project management tools
- Flutter community for excellent packages and resources
- Clean Architecture principles by Robert C. Martin

---

**Made with ❤️ and Flutter**

*This project serves as a comprehensive example of professional Flutter development practices. Perfect for learning Clean Architecture, modern state management, and building production-ready mobile applications.*