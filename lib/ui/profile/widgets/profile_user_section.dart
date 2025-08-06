import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/widgets/user_avatar_widget.dart';
import '../../../domain/models/user.dart';

class ProfileUserSection extends StatelessWidget {
  final User user;
  final String userHandle;
  final VoidCallback? onEditPressed;

  const ProfileUserSection({
    super.key,
    required this.user,
    required this.userHandle,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
      child: Column(
        children: [
          // User Avatar
          UserAvatarWidget(
            user: user,
            size: 120,
          ),
          const SizedBox(height: 16),
          
          // User Full Name
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          
          // User Handle
          Text(
            userHandle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Edit Button
          OutlinedButton(
            onPressed: onEditPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              side: const BorderSide(color: AppColors.outline, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.background,
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}