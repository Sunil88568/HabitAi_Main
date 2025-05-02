import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'appColors.dart';
import 'textStyles.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
      // primarySwatch: Colors.blue,
      //
      // // Define the system overlay style here.
      // appBarTheme: AppBarTheme(
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: Colors.green,
      //   ),
      // ),
    // applyElevationOverlayColor: ,
    //   systemOverlayStyle: SystemUiOverlayStyle(
    //     statusBarColor: Colors.green,
    //   ),
      textTheme: const TextTheme(
      ),
      fontFamily: Family.regular,
      // scaffoldBackgroundColor: AppColors.primaryBackground,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
    // background: AppColors.primaryColor,
    background: AppColors.primaryColor,
  ),
      // primaryColor: AppColors.primaryGreen,
      primaryColor: AppColors.primaryColor,
      inputDecorationTheme: EditTextTheme.editTextTheme,
      floatingActionButtonTheme: _floatingButtonTheme,
      checkboxTheme: _checkboxThemeData,
  // dialogBackgroundColor: Colors.transparent,
    dialogTheme: const DialogTheme(
        // backgroundColor: canvasColor,
        surfaceTintColor: Colors.transparent,
    )

  );
  static final ThemeData dark = ThemeData(
      primarySwatch: Colors.blue,
      // Define the system overlay style here.
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.green,
        ),
      ),
      textTheme: const TextTheme(),
      fontFamily: Family.regular,
      // scaffoldBackgroundColor: AppColors.primaryBackground,
      scaffoldBackgroundColor: AppColors.white,

      colorScheme: const ColorScheme.light(
    // background: AppColors.primaryColor,
    background: AppColors.primaryColor,
      ),
      primaryColor: AppColors.primaryColor,

      inputDecorationTheme: EditTextTheme.editTextTheme,
      floatingActionButtonTheme: _floatingButtonTheme, checkboxTheme: _checkboxThemeData,
      dialogTheme: const DialogTheme(
        surfaceTintColor: Colors.transparent,
      )
  );
  static FloatingActionButtonThemeData get _floatingButtonTheme => FloatingActionButtonThemeData(
    // backgroundColor: AppColors.primaryBackground,
    backgroundColor: AppColors.white,


    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)), );
  static CheckboxThemeData get _checkboxThemeData => CheckboxThemeData( fillColor: MaterialStateColor.resolveWith((states) {
    if (states.contains(MaterialState.selected)) {
      return AppColors.primaryColor;
      // return AppColors.primaryColor;
    }
    return Colors.transparent; },
  ),
      side: const BorderSide(
        color: Colors.grey,
        width: 2.0, )
  ); }
class EditTextTheme {
  static InputDecorationTheme get editTextTheme => InputDecorationTheme(
    focusColor: AppColors.primaryColor,
    // focusColor: AppColors.primaryColor,

    disabledBorder: disableBorder, errorBorder: errorBorder, focusedErrorBorder: setErrorBorder, labelStyle: 14.txtRegularBlack, outlineBorder: outlinedBorder, focusedBorder: focusedBorder, enabledBorder: enabledBorder,
  );
  static InputBorder get disableBorder => InputBorder.none; static BorderSide get outlinedBorder => BorderSide.none; static InputBorder get focusedBorder => setBorder;
  static InputBorder get enabledBorder => setBorder;
  static InputBorder get errorBorder => setErrorBorder;
  static InputBorder get setBorder => OutlineInputBorder( borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color:
      // AppColors.grey20,
      AppColors.primaryColor,

          width: 2));
  static InputBorder get setErrorBorder => OutlineInputBorder( borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryColor, width: 2));
}