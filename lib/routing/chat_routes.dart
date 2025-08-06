import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/chat/widgets/chat_screen.dart';
import 'route_utils.dart';

class ChatRoutes {
  static final TextEditingController _searchController = TextEditingController();
  
  static StatefulShellBranch get branch => StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteUtils.chatPath,
        builder: (context, state) => ChatScreen(searchController: _searchController),
      ),
    ],
  );
}