import 'package:go_router/go_router.dart';

import '../ui/home/widgets/home_screen.dart';
import '../ui/home/widgets/task_detail_screen.dart';
import 'route_utils.dart';

class HomeRoutes {
  static StatefulShellBranch get branch => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteUtils.homePath,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'task/:taskId',
            builder: (context, state) => TaskDetailScreen(
              taskId: state.pathParameters['taskId']!,
            ),
          ),
        ],
      ),
    ],
  );
}