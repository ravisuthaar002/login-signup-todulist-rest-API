import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:signup_firebase_project/res/colors/app_colors.dart';
import 'package:signup_firebase_project/res/components/email_input_filed.dart';
import 'package:signup_firebase_project/res/components/password_input_filed.dart';
import 'package:signup_firebase_project/res/font_size/app_font_size.dart';
import 'package:signup_firebase_project/sighup.dart';
import 'package:signup_firebase_project/view_model/login_view_modal.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {

  final LoginViewModal loginViewModal = LoginViewModal();


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 70),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Login to your account.',style: TextStyle(fontSize: AppFontSize.large,fontWeight: FontWeight.bold),),
                Text('Please sign in to your account',style: TextStyle(fontSize: AppFontSize.small,color: AppColors.black54),),
                SizedBox(height: MediaQuery.of(context).size.height * .03,),
              
                Text('Email Address',style: TextStyle(fontSize: AppFontSize.small),),
                SizedBox(height: MediaQuery.of(context).size.height * .01,),
                EmailInputFiled(
                    controller: loginViewModal.emailController,
                    focusNode: loginViewModal.emailFocusNode,
                    nextFocusNode: loginViewModal.passwordFocusNode),
                SizedBox(height: MediaQuery.of(context).size.height * .02,),

                Text('Password',style: TextStyle(fontSize: AppFontSize.small),),
                SizedBox(height: MediaQuery.of(context).size.height * .01,),
                PasswordInputFiled(
                  controller: loginViewModal.passwordController,
                  obscureText: loginViewModal.obsecurePassword,
                  focusNode: loginViewModal.passwordFocusNode,),

                SizedBox(height: MediaQuery.of(context).size.height * .03,),


                Center(
                  child: Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange800,
                        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 40)),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        loginViewModal.loginApi();
                      }
                    },
                    child: loginViewModal.loading.value ?
                    CircularProgressIndicator(color: AppColors.white,) :
                    Text("Log In",style: TextStyle(fontSize: AppFontSize.medium,color: AppColors.white)),
                  ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * .03,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don`t have an account?',style: TextStyle(fontSize: AppFontSize.small),),
                      TextButton(onPressed: (){
                        debugPrint('Register button pressed');
                        try {
                          Get.to(() => SignupPage());
                        } catch (e) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupPage()));
                        }
                      }, child: Text('Register',style: TextStyle(fontSize: 14,color: AppColors.orange800),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
