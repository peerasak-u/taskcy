# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Taskcy is a Flutter mobile application for project management with a JIRA-like interface but with a more friendly UI. The app follows Clean Architecture principles with clear separation between data, domain, and UI layers.

## Development Commands

### Running the App

```bash
flutter run                     # Run on connected device/emulator
flutter hot-reload               # Trigger hot reload (or press 'r')
flutter hot-restart              # Trigger hot restart (or press 'R')
```

### Dependencies and Code Generation

```bash
flutter pub get                  # Install dependencies
flutter pub upgrade              # Upgrade dependencies
dart run build_runner build     # Generate code (JSON serialization, etc.)
dart run build_runner build --delete-conflicting-outputs  # Force regenerate
dart run build_runner watch     # Auto-generate on file changes
```

### Code Quality and Testing

```bash
flutter analyze                  # Run static analysis
flutter test                     # Run all tests
flutter test test/specific_test.dart  # Run specific test file
flutter doctor                   # Check Flutter setup
```

### Building

```bash
flutter build apk               # Build Android APK
flutter build ios               # Build iOS (macOS only)
flutter build web               # Build web version
```

## Architecture Overview

This project follows Clean Architecture with three main layers:

### 1. Domain Layer (`lib/domain/`)

- **models/**: Pure business entities (User, Team, Project, Task)
- **repositories/**: Abstract repository contracts
- Core business logic without external dependencies

### 2. Data Layer (`lib/data/`)

- **model/**: API request/response models with JSON serialization
- **repositories/**: Concrete repository implementations
- **services/**: API clients, local storage, external service integrations

### 3. UI/Presentation Layer (`lib/ui/`)

- **core/**: Shared infrastructure (auth, navigation, theme, core widgets)
- **[feature]/**: Feature-specific modules with BLoC/Cubit, ViewModels, and widgets
- **routing/**: Modular GoRouter configuration

## Key Architectural Patterns

### State Management Decision Matrix

- **Use BLoC** for: Complex business logic, async operations, repository interactions
- **Use Cubit** for: Simple state changes, UI state, form management, navigation state

### Navigation Structure

- **GoRouter with StatefulShellRoute.indexedStack** for main tab navigation
- **Modular routing** with separate route files for each tab:
  - `routing/app_router.dart` - Main configuration
  - `routing/auth_routes.dart` - Authentication flows
  - `routing/home_routes.dart` - Home tab routes
  - `routing/project_routes.dart` - Project tab routes
  - `routing/chat_routes.dart` - Chat tab routes
  - `routing/profile_routes.dart` - Profile tab routes

### Provider Organization

All BLoC/Cubit providers are centralized in `config/app_providers.dart` for consistent dependency injection.

## Core Entities

The application manages these primary entities:

- **User**: Authentication, profile (fullname, email, avatarUrl)
- **Team**: User groups with privacy levels (Private/Public/Secret)
- **Project**: Belongs to teams, contains tasks
- **Task**: Atomic work units with status (Completed/In Progress/To Do), dates, assignees

## Screen Structure

### Authentication Flow

- Onboarding (4 steps) → Sign In/Up → Main App

### Main Application (4 tabs)

- **Home**: Task dashboard, Today/Monthly views
- **Project**: Project management
- **Chat**: Team communication
- **Profile**: User settings

### Shared Overlays

- **Add Menu**: Dynamic height modal with blur backdrop
- **Add Task/Create Team/Create Project**: Full-screen forms

## Color Theme System

The app uses a comprehensive color theme system located in `lib/ui/core/theme/` with centralized color constants for optimal performance and consistency.

### Color Palette

- **Background**: White (`#FFFFFF`)
- **Primary**: Purple (`#756EF3`)
- **Secondary**: Light Purple (`#D1E2FE`)
- **Blue**: `#63B4FF`
- **Green**: `#B1D199`
- **Orange**: `#FFB35A`

### Usage Examples

```dart
// Direct color access (recommended for performance)
Container(color: AppColors.primary)
Container(color: AppColors.blue)

// Semi-transparent colors (use withValues instead of deprecated withOpacity)
Card(color: AppColors.green.withValues(alpha: 0.1))

// Status indicators
Icon(Icons.check_circle, color: AppColors.success)
Icon(Icons.warning, color: AppColors.warning)

// Progress indicators
LinearProgressIndicator(
  backgroundColor: AppColors.progressLow,
  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressHigh),
)

// Theme extension (only when needed for light/dark theme adaptation)
final customColors = Theme.of(context).extension<CustomColorsExtension>()!;
Container(color: customColors.shadow) // Adapts between light/dark themes
```

### Files

- `app_colors.dart`: Color constants and palette
- `custom_colors_extension.dart`: Theme extension for custom colors
- `theme_state.dart`: Complete theme configuration for light/dark modes

### Best Practices

- **Always prefer `AppColors` constants** over theme extension lookups for better performance
- Use `withValues(alpha: ...)` instead of deprecated `withOpacity()`
- Use semantic color names (`AppColors.success`) rather than direct colors (`AppColors.green`)
- See `docs/PROJECT_GUIDELINE.md` for comprehensive color system documentation

## File Organization Conventions

- **snake_case** for file names
- **PascalCase** for class names
- **camelCase** for methods/variables
- Group by feature, not file type
- Mirror test structure with main code structure

## Development Workflow

1. Always run `flutter analyze` and `flutter test` before committing
2. Use `dart run build_runner build` after modifying @JsonSerializable classes
3. Follow existing code patterns and conventions
4. Implement proper error handling with custom exception classes
5. Use `const` constructors wherever possible for performance

## Dependencies

Current minimal setup uses:

- **flutter_lints**: ^5.0.0 for code quality
- **cupertino_icons**: ^1.0.8 for iOS-style icons

Future dependencies will include:

- **flutter_bloc**: State management
- **go_router**: Navigation
- **http**: Networking
- **json_annotation/json_serializable**: JSON handling
- **shared_preferences**: Local storage
- **equatable**: Value equality

The project is currently at the initial boilerplate stage and will be evolved according to the comprehensive guidelines in `docs/PROJECT_GUIDELINE.md`.
