import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/user.dart';

class UserServiceLocal {
  static const String _usersKey = 'users';

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    return usersJson.map((json) {
      final Map<String, dynamic> userMap = jsonDecode(json);
      return User(
        id: userMap['id'],
        email: userMap['email'],
        fullName: userMap['fullName'],
        avatarUrl: userMap['avatarUrl'],
        createdAt: DateTime.parse(userMap['createdAt']),
        updatedAt: DateTime.parse(userMap['updatedAt']),
      );
    }).toList();
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
    final users = await getUsers();
    final existingIndex = users.indexWhere((u) => u.id == user.id);
    
    if (existingIndex != -1) {
      users[existingIndex] = user.copyWith(updatedAt: DateTime.now());
    } else {
      users.add(user);
    }
    
    await _saveUsers(users);
    return users.firstWhere((u) => u.id == user.id);
  }

  Future<User> updateUser(String id, {
    String? fullName,
    String? avatarUrl,
  }) async {
    final users = await getUsers();
    final userIndex = users.indexWhere((user) => user.id == id);
    
    if (userIndex == -1) {
      throw Exception('User not found');
    }
    
    final updatedUser = users[userIndex].copyWith(
      fullName: fullName,
      avatarUrl: avatarUrl,
      updatedAt: DateTime.now(),
    );
    
    users[userIndex] = updatedUser;
    await _saveUsers(users);
    
    return updatedUser;
  }

  Future<void> deleteUser(String id) async {
    final users = await getUsers();
    users.removeWhere((user) => user.id == id);
    await _saveUsers(users);
  }


  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = users.map((user) {
      return jsonEncode({
        'id': user.id,
        'email': user.email,
        'fullName': user.fullName,
        'avatarUrl': user.avatarUrl,
        'createdAt': user.createdAt.toIso8601String(),
        'updatedAt': user.updatedAt.toIso8601String(),
      });
    }).toList();
    
    await prefs.setStringList(_usersKey, usersJson);
  }
}