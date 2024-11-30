part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String mobile;
  final File? profilePhoto;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    this.profilePhoto,
  });

  @override
  List<Object?> get props =>
      [email, password, firstName, lastName, mobile, profilePhoto];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class UpdateUserRequested extends AuthEvent {
  final UserModel? user;
  final File? newProfilePhoto;

  UpdateUserRequested({required this.user, this.newProfilePhoto});

  @override
  List<Object?> get props => [user, newProfilePhoto];
}

class DeleteUserRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
