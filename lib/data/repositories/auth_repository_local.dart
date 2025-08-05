import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryLocal implements AuthRepository {
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _isOnboardingCompletedKey = 'onboarding_completed';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userFullNameKey = 'user_full_name';
  static const String _userAvatarUrlKey = 'user_avatar_url';

  @override
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOnboardingCompletedKey) ?? false;
  }

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    final user = User(
      id: '1',
      email: email,
      fullName: 'John Doe',
      avatarUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveUser(user);
    await _setAuthenticationStatus(true);
    
    return user;
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    final user = User(
      id: '1',
      email: email,
      fullName: fullName,
      avatarUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveUser(user);
    await _setAuthenticationStatus(true);
    
    return user;
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, false);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userFullNameKey);
    await prefs.remove(_userAvatarUrlKey);
  }

  @override
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardingCompletedKey, true);
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    
    if (userId == null) return null;
    
    return User(
      id: userId,
      email: prefs.getString(_userEmailKey) ?? '',
      fullName: prefs.getString(_userFullNameKey) ?? '',
      avatarUrl: prefs.getString(_userAvatarUrlKey),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userEmailKey, user.email);
    await prefs.setString(_userFullNameKey, user.fullName);
    if (user.avatarUrl != null) {
      await prefs.setString(_userAvatarUrlKey, user.avatarUrl!);
    }
  }

  Future<void> _setAuthenticationStatus(bool isAuthenticated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, isAuthenticated);
  }
}