import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../../domain/models/user.dart';

class UserAvatarWidget extends StatelessWidget {
  final User? user;
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;
  final bool showAddIcon;

  const UserAvatarWidget({
    super.key,
    this.user,
    this.isSelected = false,
    this.onTap,
    this.size = 48,
    this.showAddIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected 
            ? Border.all(color: AppColors.primary, width: 3)
            : null,
        ),
        child: showAddIcon
          ? _buildAddIcon()
          : _buildUserAvatar(),
      ),
    );
  }

  Widget _buildAddIcon() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.add,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }

  Widget _buildUserAvatar() {
    if (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          user!.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
        ),
      );
    }
    
    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    final initials = _getInitials();
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: AppColors.background,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (user == null) return '?';
    
    final nameParts = user!.fullName.trim().split(' ');
    if (nameParts.isEmpty) return '?';
    
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
  }
}