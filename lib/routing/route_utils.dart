import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../ui/core/auth/cubit/auth_cubit.dart';
import '../ui/core/ui/main_scaffold.dart';

class RouteUtils {
  static const String homePath = '/home';
  static const String projectPath = '/project';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';
  static const String authPath = '/auth';
  static const String onboardingPath = '/onboarding';

  static String? handleAuthRedirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthOnboarding) return onboardingPath;
    if (authState is AuthUnauthenticated) return authPath;
    if (authState is AuthAuthenticated &&
        (state.matchedLocation == authPath || state.matchedLocation == onboardingPath)) {
      return homePath;
    }

    return null; // No redirect needed
  }

  static Widget shellBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainScaffold(navigationShell: navigationShell);
  }
}