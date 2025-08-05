import 'package:go_router/go_router.dart';

import '../ui/project/widgets/project_screen.dart';
import 'route_utils.dart';

class ProjectRoutes {
  static StatefulShellBranch get branch => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteUtils.projectPath,
        builder: (context, state) => const ProjectScreen(),
      ),
    ],
  );
}