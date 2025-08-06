import 'package:flutter/material.dart';

import 'menu_list_item_widget.dart';

class ProfileMenuSection extends StatelessWidget {
  final VoidCallback? onMyProjectsTapped;
  final VoidCallback? onMyTasksTapped;

  const ProfileMenuSection({
    super.key,
    this.onMyProjectsTapped,
    this.onMyTasksTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          MenuListItemWidget(
            title: 'My Projects',
            onTap: onMyProjectsTapped,
          ),
          MenuListItemWidget(
            title: 'My Task',
            onTap: onMyTasksTapped,
          ),
        ],
      ),
    );
  }
}