
import 'package:flutter/material.dart';
import 'package:interior_design/core/constants/color_constant.dart';

class AppTextStyles {
  AppTextStyles._();

  /* NORMAL TEXTS*/
  static TextStyle? whiteNormalText({Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: color ?? ColorConstant.appWhite
    );
  }

  /* BOLD TEXTS*/

  static TextStyle? blackBoldText22({Color? color}) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: color ?? ColorConstant.black
    );
  }
}