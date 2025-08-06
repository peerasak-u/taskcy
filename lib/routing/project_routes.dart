import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/project/widgets/project_screen.dart';
import 'route_utils.dart';

class ProjectRoutes {
  static final TextEditingController _searchController = TextEditingController();
  
  static StatefulShellBranch get branch => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteUtils.projectPath,
        builder: (context, state) => ProjectScreen(searchController: _searchController),
      ),
    ],
  );
}