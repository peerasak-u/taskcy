import 'package:go_router/go_router.dart';

import '../ui/profile/widgets/profile_screen.dart';
import 'route_utils.dart';

class ProfileRoutes {
  static StatefulShellBranch get branch => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteUtils.profilePath,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}