part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUpdated extends AuthState {}

class AuthLogoutDone extends AuthState {}

class AuthAccountDeleted extends AuthState {}

class Authenticated extends AuthState {
  final UserModel? user;

  Authenticated(this.user);

  @override
  List<Object> get props => [user ?? ''];
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}
