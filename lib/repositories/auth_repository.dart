import 'dart:developer';
import 'dart:io';

import 'package:account_management_app/models/user_model.dart';
import 'package:account_management_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserModel?> registerUser({
    required UserModel userModel,
    required String password,
    File? profilePhoto,
  }) async {
    try {
      final mobileCheck = await _firestore
          .collection(Constants.KEY_USER)
          .where(Constants.KEY_MOBILE, isEqualTo: userModel.mobile)
          .get();

      if (mobileCheck.docs.isNotEmpty) {
        throw Exception('Mobile number already registered');
      }

      // Creating credential
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );

      String? photoUrl =
          await _getImageUrl(profilePhoto, userCredential.user!.uid);

      final user = UserModel(
        id: userCredential.user!.uid,
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        mobile: userModel.mobile,
        profilePhotoUrl: photoUrl,
      );

      // Saving user's data to Firestore
      await _firestore
          .collection(Constants.KEY_USER)
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      return user;
    } catch (e, s) {
      log("Error: $e", stackTrace: s);
      throw Exception(e.toString());
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = await _firestore
          .collection(Constants.KEY_USER)
          .doc(userCredential.user!.uid)
          .get();

      return UserModel.fromMap(userData.data()!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUser(UserModel? user, {File? newProfilePhoto}) async {
    try {
      if (user == null) return;
      String? photoUrl =
          await _getImageUrl(newProfilePhoto, user.id) ?? user.profilePhotoUrl;
      log(photoUrl.toString());
      await _firestore.collection(Constants.KEY_USER).doc(user.id).update({
        ...user.toMap(),
        if (photoUrl != null) Constants.KEY_PROFILE_PHOTO_URL: photoUrl,
      });
    } catch (e, s) {
      log("Error: $e", stackTrace: s);
      throw Exception(e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _firestore.collection(Constants.KEY_USER).doc(user.uid).delete();
      await user.delete();
    } catch (e, s) {
      log("Error: $e", stackTrace: s);
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e, s) {
      log("Error: $e", stackTrace: s);
      throw Exception(e.toString());
    }
  }

  Future<bool> isUserLoggedIn() async => _auth.currentUser != null;

  Future<UserModel?> getUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      final userData =
          await _firestore.collection(Constants.KEY_USER).doc(user.uid).get();
      log("user data: ${userData.data()}");
      return UserModel.fromMap(userData.data()!);
    } catch (e, s) {
      log("Error: $e", stackTrace: s);
      throw Exception(e.toString());
    }
  }

  // Uploading profile photo to Firebase Storage and geting URL if received photo is not null
  Future<String?> _getImageUrl(File? newFile, String? id) async {
    //! as firebase storage requires blaze plan (upgraded plan), i couldn't get url
    return null;
    // try {
    //   if (newFile == null) return null;
    //   final ref = _storage.ref().child('${Constants.STR_PROFILE_PHOTOS}/$id');
    //   await ref.putFile(newFile);
    //   final url = await ref.getDownloadURL();
    //   log("Image URL: $url");
    //   return url;
    // } catch (e, s) {
    //   log("Error: $e", stackTrace: s);
    //   throw Exception(e.toString());
    // }
  }
}
