import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import '../styles/appColors.dart';
import 'TextView.dart';
import 'appDialog.dart';


void loader(BuildContext context, {Key? key}){
  var  child =  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     const CircularProgressIndicator(
        backgroundColor: AppColors.white,
        strokeAlign: 2.5,
        strokeCap: StrokeCap.round,
        strokeWidth: 6.5,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
      TextView(text: 'Loading...', style: 20.txtBoldWhite,
        margin:  const EdgeInsets.only(top: 20),
      )
    ],
  );

  final alertDialog = AlertDialog(
    key: key,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(
            6))),
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40
      // horizontal: AppFonts.s16, vertical: AppFonts.s40
    ),
    content:  SizedBox(width: double.maxFinite, child: child),
  );

  showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AnimateDialog(
          childView: alertDialog,
        ),
      ));
}