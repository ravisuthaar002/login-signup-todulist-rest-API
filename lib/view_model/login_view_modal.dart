

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signup_firebase_project/dataSave.dart';
import 'package:signup_firebase_project/login.dart';
import 'package:signup_firebase_project/modal/login/user_modal.dart';
import 'package:signup_firebase_project/rest_api.dart';
import 'package:signup_firebase_project/view_model/user_preference/user_preference_view_modal.dart';

import '../data/response/app_exceptions.dart';
import '../res/components/utils.dart';

class LoginViewModal extends GetxController{


  RxBool obsecurePassword = true.obs;
  RxBool loading = false.obs;

  var userPreference = UserPreference();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();



 Future<dynamic> loginApi() async {
  loading.value = true;

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final user = FirebaseAuth.instance.currentUser;
    final idToken = user != null ? await user.getIdToken() : null;

    if (idToken != null) {
      await userPreference.saveUser(UserModal(token: idToken));
    }

    Get.offAll(TasksPage());

  } on FirebaseAuthException catch (e) {
    String errorMessage = "";

    switch (e.code) {
      case 'user-not-found':
        errorMessage = "No user found for that email.";
        break;
      case 'wrong-password':
        errorMessage = "Incorrect password.";
        break;
      case 'invalid-email':
        errorMessage = "Invalid email address.";
        break;
      default:
        errorMessage = e.message ?? "Login failed";
    }

    Utils.toastMessageTop(errorMessage);

  } catch (e) {
    Utils.toastMessageTop("Something went wrong");
  }

  loading.value = false;
}




}