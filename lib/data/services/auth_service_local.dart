import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/user.dart';

class AuthServiceLocal {
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _isOnboardingCompletedKey = 'onboarding_completed';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userFullNameKey = 'user_full_name';
  static const String _userAvatarUrlKey = 'user_avatar_url';

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAuthenticatedKey) ?? false;
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOnboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardingCompletedKey, true);
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userEmailKey, user.email);
    await prefs.setString(_userFullNameKey, user.fullName);
    if (user.avatarUrl != null) {
      await prefs.setString(_userAvatarUrlKey, user.avatarUrl!);
    }
  }

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

  Future<void> setAuthenticationStatus(bool isAuthenticated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, isAuthenticated);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, false);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userFullNameKey);
    await prefs.remove(_userAvatarUrlKey);
  }
}