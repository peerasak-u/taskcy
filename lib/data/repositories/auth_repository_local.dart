import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_service_local.dart';

class AuthRepositoryLocal implements AuthRepository {
  final AuthServiceLocal _authService = AuthServiceLocal();

  @override
  Future<bool> isAuthenticated() async {
    return _authService.isAuthenticated();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _authService.isOnboardingCompleted();
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

    await _authService.saveUser(user);
    await _authService.setAuthenticationStatus(true);
    
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

    await _authService.saveUser(user);
    await _authService.setAuthenticationStatus(true);
    
    return user;
  }

  @override
  Future<void> signOut() async {
    await _authService.clearUserData();
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await _authService.setOnboardingCompleted();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _authService.getCurrentUser();
  }

}