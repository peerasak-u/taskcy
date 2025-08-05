import '../models/user.dart';

abstract class AuthRepository {
  Future<bool> isAuthenticated();

  Future<bool> isOnboardingCompleted();

  Future<User> signIn({
    required String email,
    required String password,
  });

  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> signOut();

  Future<void> setOnboardingCompleted();

  Future<User?> getCurrentUser();
}