import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthInitial());

    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (!isAuthenticated) {
        final isOnboardingCompleted = await _authRepository.isOnboardingCompleted();
        if (!isOnboardingCompleted) {
          emit(const AuthOnboarding());
        } else {
          emit(const AuthUnauthenticated());
        }
        return;
      }

      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _authRepository.setOnboardingCompleted();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}