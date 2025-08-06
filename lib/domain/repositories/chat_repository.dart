import '../models/chat.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats({
    int page = 1,
    int perPage = 20,
    String? search,
  });

  Future<Chat> getChatById(String id);

  Future<List<Chat>> getChatsByUserId(String userId);

  Future<Chat> createUserChat(String participantId);

  Future<Chat> createTeamChat(String teamId);

  Future<Chat> updateChatStatus(String id, {
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageTime,
  });

  Future<void> deleteChat(String id);
}