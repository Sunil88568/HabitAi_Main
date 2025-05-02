import 'package:flutter/material.dart';
import '../../components/coreComponents/appDialog.dart';
import '../../components/styles/appColors.dart';
import 'loader_utils.dart';

//------------------------------[dimensions]------------------------------------
extension DimensionExtn on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get getHeight => MediaQuery.of(this).size.height;
  Size get size => MediaQuery.of(this).size;
  double get width => MediaQuery.of(this).size.width;
  double get bottomSafeArea => MediaQuery.of(this).viewPadding.bottom;
  double get topSafeArea => MediaQuery.of(this).viewPadding.top;
}
//--------------------------------[ Navigation ]-------------------------------
extension NavigatorExtn on BuildContext {
// navigate to next screen
  Future<dynamic> pushNavigator(Widget screen) => Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => screen,
      ));

// push and replace ......
  Future<dynamic> replaceNavigator(Widget screen) => Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        builder: (context) => screen,
      ));

// clear stack and navigate to screen....
  void pushAndClearNavigator(Widget screen) {
    LoaderUtils.dismiss();
    LoaderUtils.dismiss();
    Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        (route) => false);
  }

//pop back...
  void pop({value}) => Navigator.pop(this, value);
}




//------------------------------[Locale]----------------------------------------------
extension LocaleExtn on BuildContext {
  // AppLocalizations get locale => AppLocalizations.of(this)!;
  // Future<AppLocalizations> get localeEn => AppLocalizations.delegate.load(Locale('en'));
  // Future<AppLocalizations> get localeHi => AppLocalizations.delegate.load(Locale('hi'));
  // bool get isHindi => locale.lang == 'hi';
  // bool get isEnglish => locale.lang == 'en';
}

//--------------------------[Dialog]--------------------------------------------
extension AppStateExtn on BuildContext {
// close progressLoader or dialog .....
  void get stopLoader => Navigator.of(this, rootNavigator: true).pop('dialog');

// show popup dialog ....
  void openDialog(Widget child,
          {bool barrierDismissible = true,
          Color bgColor = AppColors.white,
          Key? key}) =>
      appDialog(this, child,
          barrierDismissible: barrierDismissible, bgColor: bgColor);
}
