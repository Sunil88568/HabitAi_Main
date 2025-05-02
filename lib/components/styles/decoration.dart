import 'package:flutter/material.dart';

import 'appColors.dart';

class AppDecoration {
  static BoxDecoration appBarDecoration({Color? color, bool hasShadow = true}) =>
      BoxDecoration(color: color ??
      AppColors.white,
      // Colors.black,
          boxShadow: hasShadow ?[
        BoxShadow(
            blurRadius: 5,
            color: AppColors.primaryColor.withOpacity(0.06),
            offset: const Offset(6, 11)
        )
      ] : null);

  static InputBorder inputBorder({double? radius, Color? borderColor}) =>OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ??
          // AppFonts.s10
          10),
      borderSide: BorderSide(
          color: borderColor ??
              // AppColors.primaryGreen
              AppColors.primaryColor,
          width: 0.5));

  static BoxDecoration bDecorationGreyR(
          {double radius = 10, double borderWidth = 2, Color? borderColor }) =>
      BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor ?? AppColors.primaryColor , width: borderWidth));

  static BoxDecoration bDecorationPBlue(
          {double radius = 10, double borderWidth = 2, Color? color}) =>
      BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: color ?? AppColors.primaryColor, width: borderWidth));

  static BoxDecoration bDecorationWhiteShadow(
          {double radius = 10, double borderWidth = 2, Color? color }) =>
      BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: AppColors.white,
          boxShadow:  [BoxShadow(color: color ?? AppColors.primaryColor, blurRadius: 10)]);
}
