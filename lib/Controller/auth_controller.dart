import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/auth_model.dart';
import '../View/auth_view.dart';
import '../View/home.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<UserModel> firebaseUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges().map(_userFromFirebase));
  }

  UserModel? _userFromFirebase(User? user) {
    if (user != null) {
      return UserModel(uid: user.uid, email: user.email);
    }
    return null;
  }

  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Success', 'User Created Successfully...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 8);
      Get.to(AuthView());
    } catch (e) {
      // Get.snackbar('Error', e.toString());
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 8);
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Successfully', 'Login Success',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 8);

      Get.to(HomeScreen());
    } catch (e) {
      // Get.snackbar('Error', e.toString());

      // if(e.toString()==''){
      //
      // }
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 8);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
