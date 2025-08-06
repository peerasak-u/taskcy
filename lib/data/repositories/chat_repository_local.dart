import '../../domain/models/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../services/chat_service_local.dart';

class ChatRepositoryLocal implements ChatRepository {
  final ChatServiceLocal _chatService = ChatServiceLocal();

  @override
  Future<List<Chat>> getChats({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    List<Chat> chats;
    
    if (search != null && search.isNotEmpty) {
      chats = await _chatService.searchChats(search);
    } else {
      chats = await _chatService.getChats();
    }
    
    // Sort by last message time (most recent first)
    chats.sort((a, b) {
      final aTime = a.lastMessageTime ?? a.updatedAt;
      final bTime = b.lastMessageTime ?? b.updatedAt;
      return bTime.compareTo(aTime);
    });
    
    // Apply pagination
    final startIndex = (page - 1) * perPage;
    final endIndex = startIndex + perPage;
    
    if (startIndex >= chats.length) {
      return [];
    }
    
    return chats.sublist(
      startIndex,
      endIndex > chats.length ? chats.length : endIndex,
    );
  }

  @override
  Future<Chat> getChatById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 200));
    
    final chat = await _chatService.getChatById(id);
    if (chat == null) {
      throw Exception('Chat not found');
    }
    return chat;
  }

  @override
  Future<List<Chat>> getChatsByUserId(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 250));
    
    return await _chatService.getChatsByUserId(userId);
  }

  @override
  Future<Chat> createUserChat(String participantId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    final chat = Chat(
      id: 'chat_${participantId}_${now.millisecondsSinceEpoch}',
      name: 'New Chat', // This would be populated with the participant's name
      type: ChatType.user,
      participantId: participantId,
      createdAt: now,
      updatedAt: now,
    );
    
    return await _chatService.saveChat(chat);
  }

  @override
  Future<Chat> createTeamChat(String teamId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    final chat = Chat(
      id: 'chat_team_${teamId}_${now.millisecondsSinceEpoch}',
      name: 'Team Chat', // This would be populated with the team's name
      type: ChatType.team,
      teamId: teamId,
      createdAt: now,
      updatedAt: now,
    );
    
    return await _chatService.saveChat(chat);
  }

  @override
  Future<Chat> updateChatStatus(String id, {
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    return await _chatService.updateChatStatus(
      id,
      isOnline: isOnline,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
  }

  @override
  Future<void> deleteChat(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 400));
    
    await _chatService.deleteChat(id);
  }
}