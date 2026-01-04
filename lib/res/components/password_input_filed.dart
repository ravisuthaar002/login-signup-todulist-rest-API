import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../colors/app_colors.dart';

class PasswordInputFiled extends StatelessWidget {
  final TextEditingController controller;
  final RxBool obscureText;
  final FocusNode focusNode;

  const PasswordInputFiled({Key?key,
    required this.controller,
    required this.obscureText,
    required this.focusNode,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        TextFormField(
          controller: controller,
          obscureText: obscureText.value,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(width: 2, color: AppColors.orange800)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(width: 2, color: AppColors.grey)),
            suffixIcon: IconButton(
              icon: Icon(obscureText.value ? Icons.visibility_off : Icons.visibility ),
              onPressed: () {
                obscureText.value = !obscureText.value;
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Please enter password';
            else if (value.length < 6)
              return 'Password must be at least 6 characters';
            return null;
          },
        ));
  }
}
