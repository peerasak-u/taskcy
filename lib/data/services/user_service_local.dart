import '../../domain/models/user.dart';

class UserServiceLocal {
  static List<User>? _users;

  Future<List<User>> getUsers() async {
    _users ??= _seedInitialUsers();
    return List<User>.from(_users!);
  }

  Future<User?> getUserById(String id) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> searchUsers(String query) async {
    final users = await getUsers();
    final lowerQuery = query.toLowerCase();
    
    return users.where((user) {
      return user.fullName.toLowerCase().contains(lowerQuery) ||
             user.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<User> saveUser(User user) async {
    _users ??= _seedInitialUsers();
    final existingIndex = _users!.indexWhere((u) => u.id == user.id);
    
    if (existingIndex != -1) {
      _users![existingIndex] = user.copyWith(updatedAt: DateTime.now());
    } else {
      _users!.add(user);
    }
    
    return _users!.firstWhere((u) => u.id == user.id);
  }

  Future<User> updateUser(String id, {
    String? fullName,
    String? avatarUrl,
  }) async {
    _users ??= _seedInitialUsers();
    final userIndex = _users!.indexWhere((user) => user.id == id);
    
    if (userIndex == -1) {
      throw Exception('User not found');
    }
    
    final updatedUser = _users![userIndex].copyWith(
      fullName: fullName,
      avatarUrl: avatarUrl,
      updatedAt: DateTime.now(),
    );
    
    _users![userIndex] = updatedUser;
    
    return updatedUser;
  }

  Future<void> deleteUser(String id) async {
    _users ??= _seedInitialUsers();
    _users!.removeWhere((user) => user.id == id);
  }

  List<User> _seedInitialUsers() {
    final now = DateTime.now();
    
    return [
      User(
        id: 'user_peerasak',
        email: 'peerasak.dev@example.com',
        fullName: 'Peerasak',
        avatarUrl: 'https://ui-avatars.com/api/?name=Peerasak&background=756EF3&color=fff&size=200',
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      User(
        id: 'user_claude',
        email: 'claude@anthropic.ai',
        fullName: 'Claude',
        avatarUrl: 'https://ui-avatars.com/api/?name=Claude&background=63B4FF&color=fff&size=200',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      User(
        id: 'user_sarah',
        email: 'sarah.chen@creativeworks.com',
        fullName: 'Sarah Chen',
        avatarUrl: 'https://ui-avatars.com/api/?name=Sarah+Chen&background=B1D199&color=fff&size=200',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),
      User(
        id: 'user_alex',
        email: 'alex.rivera@creativeworks.com',
        fullName: 'Alex Rivera',
        avatarUrl: 'https://ui-avatars.com/api/?name=Alex+Rivera&background=FFB35A&color=fff&size=200',
        createdAt: now.subtract(const Duration(days: 35)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }
}