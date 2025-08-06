import 'package:equatable/equatable.dart';

import '../../../domain/models/chat.dart';
import 'chat_view_model.dart';

class ChatsViewModel extends Equatable {
  final List<ChatViewModel> chats;
  final List<ChatViewModel> teamChats;
  final List<ChatViewModel> userChats;

  const ChatsViewModel({
    required this.chats,
  }) : teamChats = const [],
       userChats = const [];

  const ChatsViewModel._internal({
    required this.chats,
    required this.teamChats,
    required this.userChats,
  });

  factory ChatsViewModel.fromChats(List<Chat> chats) {
    final chatViewModels = chats.map((chat) => ChatViewModel.fromChat(chat)).toList();
    
    final teamChats = chatViewModels
        .where((chat) => chat.type == ChatType.team)
        .toList();
    
    final userChats = chatViewModels
        .where((chat) => chat.type == ChatType.user)
        .toList();

    return ChatsViewModel._internal(
      chats: chatViewModels,
      teamChats: teamChats,
      userChats: userChats,
    );
  }

  bool get isEmpty => chats.isEmpty;
  
  bool get hasTeamChats => teamChats.isNotEmpty;
  
  bool get hasUserChats => userChats.isNotEmpty;
  
  int get totalChats => chats.length;
  
  int get onlineUsersCount => userChats.where((chat) => chat.isOnline).length;
  
  List<ChatViewModel> get recentChats {
    final recentChats = List<ChatViewModel>.from(chats);
    recentChats.sort((a, b) {
      // Sort by recent activity, with online users first
      if (a.isOnline && !b.isOnline) return -1;
      if (!a.isOnline && b.isOnline) return 1;
      
      // Then by last message time (most recent first)
      if (a.hasRecentActivity && !b.hasRecentActivity) return -1;
      if (!a.hasRecentActivity && b.hasRecentActivity) return 1;
      
      return 0;
    });
    
    return recentChats.take(10).toList();
  }

  @override
  List<Object?> get props => [chats, teamChats, userChats];
}