import 'package:flutter/material.dart';
import '../../../domain/models/chat.dart';
import '../../core/theme/app_colors.dart';

class ChatItemWidget extends StatelessWidget {
  final Chat chat;
  final VoidCallback? onTap;
  final VoidCallback? onCameraTap;

  const ChatItemWidget({
    super.key,
    required this.chat,
    this.onTap,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.statusText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCameraTap,
              icon: const Icon(
                Icons.photo_camera_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: chat.avatarUrl != null
            ? DecorationImage(
                image: NetworkImage(chat.avatarUrl!),
                fit: BoxFit.cover,
              )
            : null,
        color: chat.avatarUrl == null ? AppColors.primary : null,
      ),
      child: chat.avatarUrl == null
          ? Center(
              child: Text(
                chat.name.isNotEmpty ? chat.name[0].toUpperCase() : '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}