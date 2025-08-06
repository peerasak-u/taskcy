import 'package:equatable/equatable.dart';

enum ChatType { user, team }

class Chat extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final ChatType type;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? participantId; // For user chats, this is the other user's ID
  final String? teamId; // For team chats, this is the team ID
  final bool isOnline;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.type,
    this.lastMessage,
    this.lastMessageTime,
    this.participantId,
    this.teamId,
    this.isOnline = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    ChatType? type,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? participantId,
    String? teamId,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participantId: participantId ?? this.participantId,
      teamId: teamId ?? this.teamId,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusText {
    if (type == ChatType.team) {
      return 'Team chat';
    } else if (isOnline) {
      return 'Active now';
    } else if (lastMessageTime != null) {
      final now = DateTime.now();
      final difference = now.difference(lastMessageTime!);
      
      if (difference.inMinutes < 60) {
        return 'Active ${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return 'Active ${difference.inHours}h ago';
      } else {
        return 'Active ${difference.inDays}d ago';
      }
    } else {
      return 'Offline';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        type,
        lastMessage,
        lastMessageTime,
        participantId,
        teamId,
        isOnline,
        createdAt,
        updatedAt,
      ];
}