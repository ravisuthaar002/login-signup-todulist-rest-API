import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signup_firebase_project/dataSave.dart';
import 'package:signup_firebase_project/modal/login/user_modal.dart';
import 'package:signup_firebase_project/rest_api.dart';
import 'package:signup_firebase_project/sighup.dart';
import 'package:signup_firebase_project/view_model/user_preference/user_preference_view_modal.dart';
import '../data/response/app_exceptions.dart';
import '../res/components/utils.dart';

class SignupViewModal extends GetxController{


  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode().obs;
  final passwordFocusNode = FocusNode().obs;

  RxBool obsecurePassword = true.obs;
  RxBool isChecked = false.obs;
  RxBool loading = false.obs;

  
  var userPreference = UserPreference();
  
  signup()async {
    loading.value = true;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.value.text,
          password: passwordController.value.text);

      final user = FirebaseAuth.instance.currentUser;    
      final idToken = user != null ? await user.getIdToken() : null;
      if (idToken != null) {
        await userPreference.saveUser(UserModal(token: idToken));
      }  
      Get.offAll(TasksPage());
      // Get.toNamed(RoutesName.personalData);

    }on SocketException{
      throw InternetException('');
    } on RequestTimeOut{
      throw RequestTimeOut('');
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found for that email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        default:
          errorMessage = "Login failed. ${e.message}";
      }

      Utils.toastMessageTopRed(errorMessage);
    } catch (e) {

      Utils.toastMessageTop("An error occurred. Please try again.");

    }
    loading.value = false;
  }
}