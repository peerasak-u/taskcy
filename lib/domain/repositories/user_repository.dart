import '../models/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();

  Future<User> getUserById(String id);

  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
  });

  Future<User> updateUser(
    String id, {
    String? fullName,
    String? avatarUrl,
  });

  Future<void> deleteUser(String id);
}