import '../../domain/models/chat.dart';
import '../../domain/models/user.dart';
import 'user_service_local.dart';

class ChatServiceLocal {
  static List<Chat>? _chats;
  final UserServiceLocal _userService = UserServiceLocal();

  Future<List<Chat>> getChats() async {
    _chats ??= await _seedInitialChats();
    return List<Chat>.from(_chats!);
  }

  Future<Chat?> getChatById(String id) async {
    final chats = await getChats();
    try {
      return chats.firstWhere((chat) => chat.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Chat>> getChatsByUserId(String userId) async {
    final chats = await getChats();
    return chats.where((chat) => 
      (chat.type == ChatType.user && chat.participantId == userId)
    ).toList();
  }

  Future<List<Chat>> searchChats(String query) async {
    final chats = await getChats();
    final lowerQuery = query.toLowerCase();
    
    return chats.where((chat) {
      return chat.name.toLowerCase().contains(lowerQuery) ||
             (chat.lastMessage?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<Chat> saveChat(Chat chat) async {
    _chats ??= await _seedInitialChats();
    final existingIndex = _chats!.indexWhere((c) => c.id == chat.id);
    
    if (existingIndex != -1) {
      _chats![existingIndex] = chat.copyWith(updatedAt: DateTime.now());
    } else {
      _chats!.add(chat);
    }
    
    return _chats!.firstWhere((c) => c.id == chat.id);
  }

  Future<Chat> updateChatStatus(String id, {
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) async {
    _chats ??= await _seedInitialChats();
    final chatIndex = _chats!.indexWhere((chat) => chat.id == id);
    
    if (chatIndex == -1) {
      throw Exception('Chat not found');
    }
    
    final updatedChat = _chats![chatIndex].copyWith(
      isOnline: isOnline,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      updatedAt: DateTime.now(),
    );
    
    _chats![chatIndex] = updatedChat;
    
    return updatedChat;
  }

  Future<void> deleteChat(String id) async {
    _chats ??= await _seedInitialChats();
    _chats!.removeWhere((chat) => chat.id == id);
  }

  Future<List<Chat>> _seedInitialChats() async {
    final now = DateTime.now();
    final users = await _userService.getUsers();
    
    // Filter out Peerasak (current user) from chat list
    final otherUsers = users.where((user) => user.id != 'user_peerasak').toList();
    
    final chats = <Chat>[];
    
    // Create user chats with real users (excluding Peerasak)
    for (int i = 0; i < otherUsers.length; i++) {
      final user = otherUsers[i];
      final isOnline = i == 0; // Make first user online for realism
      
      final chat = Chat(
        id: 'chat_${user.id}',
        name: user.fullName,
        avatarUrl: user.avatarUrl,
        type: ChatType.user,
        participantId: user.id,
        lastMessage: _getRealisticMessage(i),
        lastMessageTime: now.subtract(Duration(
          minutes: 5 + (i * 30), // Stagger message times
        )),
        isOnline: isOnline,
        createdAt: now.subtract(Duration(days: 15 + (i * 5))),
        updatedAt: now.subtract(Duration(
          minutes: 5 + (i * 30),
        )),
      );
      
      chats.add(chat);
    }
    
    return chats;
  }
  
  String _getRealisticMessage(int index) {
    final messages = [
      'Active now',
      'The UI design looks great!',
      'Can we schedule a meeting?',
      'Good progress on the tasks',
    ];
    return messages[index % messages.length];
  }
}