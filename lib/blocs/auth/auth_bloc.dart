import 'dart:io';

import 'package:account_management_app/models/user_model.dart';
import 'package:account_management_app/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<RegisterRequested>(_handleRegister);
    on<LoginRequested>(_handleLogin);
    on<UpdateUserRequested>(_handleUpdateUser);
    on<DeleteUserRequested>(_handleDeleteUser);
    on<LogoutRequested>(_handleLogout);
  }

  Future<void> _handleRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.registerUser(
        userModel: UserModel(
          id: null,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          mobile: event.mobile,
        ),
        password: event.password,
        profilePhoto: event.profilePhoto,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleUpdateUser(
    UpdateUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.updateUser(event.user,
          newProfilePhoto: event.newProfilePhoto);
      emit(AuthUpdated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleDeleteUser(
    DeleteUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.deleteUser();
      emit(AuthAccountDeleted());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthLogoutDone());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
