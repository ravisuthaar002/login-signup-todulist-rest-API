import 'package:flutter/material.dart';
import 'package:signup_firebase_project/res/components/utils.dart';

import '../colors/app_colors.dart';

class EmailInputFiled extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const EmailInputFiled({Key?key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
  }) : super (key: key);






  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(width: 2, color: Colors.orange.shade800)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 2, color: AppColors.grey))
      ),
      onFieldSubmitted: (value){
         Utils.fieldFocusChange(context, focusNode!, nextFocusNode!);
      },
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Please enter email';
        else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
          return 'Enter valid email';
        return null;
      },
    );
  }
}
