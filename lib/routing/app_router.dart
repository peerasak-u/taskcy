import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/core/auth/cubit/auth_cubit.dart';
import 'auth_routes.dart';
import 'chat_routes.dart';
import 'home_routes.dart';
import 'profile_routes.dart';
import 'project_routes.dart';
import 'route_utils.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: RouteUtils.homePath,
    redirect: RouteUtils.handleAuthRedirect,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    routes: [
      ...AuthRoutes.routes,
      StatefulShellRoute.indexedStack(
        builder: RouteUtils.shellBuilder,
        branches: [
          HomeRoutes.branch,
          ProjectRoutes.branch,
          ChatRoutes.branch,
          ProfileRoutes.branch,
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}