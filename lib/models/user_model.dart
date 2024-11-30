import 'package:account_management_app/utils/constants.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String? profilePhotoUrl;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    this.profilePhotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      Constants.KEY_ID: id,
      Constants.KEY_FIRST_NAME: firstName,
      Constants.KEY_LAST_NAME: lastName,
      Constants.KEY_EMAIL: email,
      Constants.KEY_USER: mobile,
      Constants.KEY_PROFILE_PHOTO_URL: profilePhotoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[Constants.KEY_ID] ?? '',
      firstName: map[Constants.KEY_FIRST_NAME] ?? '',
      lastName: map[Constants.KEY_LAST_NAME] ?? '',
      email: map[Constants.KEY_EMAIL] ?? '',
      mobile: map[Constants.KEY_MOBILE] ?? '',
      profilePhotoUrl: map[Constants.KEY_PROFILE_PHOTO_URL],
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, email, mobile, profilePhotoUrl];

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? profilePhotoUrl,
  }) {
    return UserModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }
}
