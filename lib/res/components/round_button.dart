


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../font_size/app_font_size.dart';

class RoundButton extends StatelessWidget {

  final bool loading;
  final String title;
  final double height, width;
  final VoidCallback onPress;
  final Color? textColor, buttonColor;
  final double redius;

  const RoundButton({Key? key,
    required this.title,
    required this.onPress,
    this.textColor = AppColors.primaryTextColor,
    this.buttonColor,
    this.width = 60,
    this.height = 50,
    this.loading = false,
    this.redius = 30,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.primaryButtonColor,
          borderRadius: BorderRadius.circular(redius),
        ),
        child: loading ? 
        const Center(child: CircularProgressIndicator()) :
        Center(child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor, fontSize: AppFontSize.medium)
              ?? TextStyle(color: textColor, fontSize: AppFontSize.medium),
        )),
      ),
    );
  }
}


