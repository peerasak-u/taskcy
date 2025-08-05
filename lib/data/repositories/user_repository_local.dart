import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../services/user_service_local.dart';

class UserRepositoryLocal implements UserRepository {
  final UserServiceLocal _userService = UserServiceLocal();

  @override
  Future<User?> getCurrentUser() async {
    // This would typically return the authenticated user
    // For now, we'll return the first user if any exists
    final users = await _userService.getUsers();
    return users.isNotEmpty ? users.first : null;
  }

  @override
  Future<User> getUserById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    final user = await _userService.getUserById(id);
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }

  @override
  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    List<User> users;
    
    if (search != null && search.isNotEmpty) {
      users = await _userService.searchUsers(search);
    } else {
      users = await _userService.getUsers();
    }
    
    // Apply pagination
    final startIndex = (page - 1) * perPage;
    final endIndex = startIndex + perPage;
    
    if (startIndex >= users.length) {
      return [];
    }
    
    return users.sublist(
      startIndex,
      endIndex > users.length ? users.length : endIndex,
    );
  }

  @override
  Future<User> updateUser(
    String id, {
    String? fullName,
    String? avatarUrl,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    return await _userService.updateUser(
      id,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    await _userService.deleteUser(id);
  }
}