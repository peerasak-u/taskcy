import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class UserAvatarStackWidget extends StatelessWidget {
  final List<String> avatarUrls;
  final double size;
  final int maxVisible;
  final double overlapFactor;

  const UserAvatarStackWidget({
    super.key,
    required this.avatarUrls,
    this.size = 32.0,
    this.maxVisible = 3,
    this.overlapFactor = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrls.isEmpty) return const SizedBox.shrink();

    final visibleAvatars = avatarUrls.take(maxVisible).toList();
    final remainingCount = avatarUrls.length - maxVisible;

    return SizedBox(
      height: size,
      width: _calculateWidth(visibleAvatars.length, remainingCount > 0),
      child: Stack(
        children: [
          ...visibleAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatarUrl = entry.value;
            return Positioned(
              left: index * size * overlapFactor,
              child: _buildAvatar(avatarUrl),
            );
          }),
          if (remainingCount > 0)
            Positioned(
              left: visibleAvatars.length * size * overlapFactor,
              child: _buildCountAvatar(remainingCount),
            ),
        ],
      ),
    );
  }

  double _calculateWidth(int visibleCount, bool hasMore) {
    final stackWidth = (visibleCount - 1) * size * overlapFactor + size;
    if (hasMore) {
      return stackWidth + size * overlapFactor;
    }
    return stackWidth;
  }

  Widget _buildAvatar(String avatarUrl) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.background, width: 2),
        image: avatarUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
              )
            : null,
        color: avatarUrl.isEmpty ? AppColors.primary : null,
      ),
      child: avatarUrl.isEmpty
          ? Icon(
              Icons.person,
              color: AppColors.background,
              size: size * 0.6,
            )
          : null,
    );
  }

  Widget _buildCountAvatar(int count) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textSecondary,
        border: Border.all(color: AppColors.background, width: 2),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            color: AppColors.background,
            fontSize: size * 0.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}