import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/chat.dart';
import '../../core/theme/app_colors.dart';

class ChatViewModel extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final String? avatarUrl;
  final ChatType type;
  final String lastMessage;
  final String lastMessageTime;
  final String statusText;
  final bool isOnline;
  final Color statusColor;
  final IconData typeIcon;

  const ChatViewModel({
    required this.id,
    required this.name,
    required this.displayName,
    this.avatarUrl,
    required this.type,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.statusText,
    required this.isOnline,
    required this.statusColor,
    required this.typeIcon,
  });

  factory ChatViewModel.fromChat(Chat chat) {
    final displayName = _getDisplayName(chat);
    final lastMessage = _getFormattedLastMessage(chat.lastMessage);
    final lastMessageTime = _getFormattedLastMessageTime(chat.lastMessageTime);
    final statusColor = _getStatusColor(chat.type, chat.isOnline);
    final typeIcon = _getTypeIcon(chat.type);

    return ChatViewModel(
      id: chat.id,
      name: chat.name,
      displayName: displayName,
      avatarUrl: chat.avatarUrl,
      type: chat.type,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      statusText: chat.statusText,
      isOnline: chat.isOnline,
      statusColor: statusColor,
      typeIcon: typeIcon,
    );
  }

  static String _getDisplayName(Chat chat) {
    return chat.name.isNotEmpty ? chat.name : 'Unknown User';
  }

  static String _getFormattedLastMessage(String? lastMessage) {
    if (lastMessage == null || lastMessage.isEmpty) {
      return 'No messages yet';
    }
    
    // Truncate long messages
    if (lastMessage.length > 50) {
      return '${lastMessage.substring(0, 47)}...';
    }
    
    return lastMessage;
  }

  static String _getFormattedLastMessageTime(DateTime? lastMessageTime) {
    if (lastMessageTime == null) {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      // Format as date for older messages
      return '${lastMessageTime.day}/${lastMessageTime.month}';
    }
  }

  static Color _getStatusColor(ChatType type, bool isOnline) {
    if (type == ChatType.team) {
      return AppColors.blue;
    } else if (isOnline) {
      return AppColors.green;
    } else {
      return AppColors.textSecondary;
    }
  }

  static IconData _getTypeIcon(ChatType type) {
    switch (type) {
      case ChatType.team:
        return Icons.group;
      case ChatType.user:
        return Icons.person;
    }
  }

  bool get hasRecentActivity => lastMessageTime != 'now' && lastMessageTime.isNotEmpty;
  
  bool get isTeamChat => type == ChatType.team;
  
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
  
  String get avatarFallback => displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

  @override
  List<Object?> get props => [
    id,
    name,
    displayName,
    avatarUrl,
    type,
    lastMessage,
    lastMessageTime,
    statusText,
    isOnline,
    statusColor,
    typeIcon,
  ];
}