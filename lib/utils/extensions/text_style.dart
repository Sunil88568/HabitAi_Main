
import 'package:flutter/material.dart';
import 'package:question_app/utils/extensions/extensions.dart';

import '../../components/styles/appColors.dart';
enum TextWeight {regular,medium, semiBold, bold,}

extension TextStyles on num{
  TextStyle get txtRegularBlackText => _textStyle(this, AppColors.black, Family.regular);

  TextStyle get txtRegularError => _textStyle(this, AppColors.red, Family.regular);

  TextStyle get txtRegularWhite => _textStyle(this,AppColors.white,Family.regular);
  TextStyle get txtRegularcolor => _textStyle(this,AppColors.primaryColor,Family.regular);
  TextStyle get txtRegularBlack => _textStyle(this,AppColors.black,Family.regular);

  TextStyle get txtMediumWhite => _textStyle(this,AppColors.white,Family.medium);
  TextStyle get txtSBoldBlack => _textStyle(this,AppColors.black,Family.semiBold);
  TextStyle get txtBoldWhite => _textStyle(this,AppColors.white,Family.bold);
  TextStyle get txtBoldBlack => _textStyle(this,AppColors.black,Family.bold);
  TextStyle get txtRegularGrey => _textStyle(this, AppColors.grey, Family.regular);
  TextStyle get txtMediumBlack => _textStyle(this,AppColors.black,Family.medium);

  TextStyle get mediumBlack => _textStyle(this,Colors.orange,Family.medium);
}

extension TextWeights on TextWeight{
  FontWeight get fontWeight {
    if(this == TextWeight.regular){
      return FontWeight.w400;
    }else if(this == TextWeight.medium){
      return FontWeight.w500;
    }else if(this == TextWeight.semiBold){
      return FontWeight.w600;
    }else if(this == TextWeight.bold){
      return FontWeight.w700;
    }else{
      return FontWeight.w400;
    }
  }
}




class Family{
  static const String light = 'Urbanist-Light';
  static const String regular = 'Urbanist-Regular';
  static const String medium = 'Urbanist-Medium';
  static const String semiBold = 'Urbanist-SemiBold';
  static const String bold = 'Urbanist-Bold';
  static const String extraBold = 'Urbanist-ExtraBold';
  static const String splash = 'UnifrakturMaguntia-Regular';
}



TextStyle _textStyle(num size, color, family) => TextStyle(
    fontSize: size.numToDouble,
    color: color,
    fontFamily: family
);