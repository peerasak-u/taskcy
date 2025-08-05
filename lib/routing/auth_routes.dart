import 'package:go_router/go_router.dart';

import '../ui/auth/widgets/auth_screen.dart';
import '../ui/onboarding/widgets/onboarding_screen.dart';
import 'route_utils.dart';

class AuthRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: RouteUtils.onboardingPath,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteUtils.authPath,
      builder: (context, state) => const AuthScreen(),
    ),
  ];
}