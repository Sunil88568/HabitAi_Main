import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../components/styles/appColors.dart';

class AppLoader {

  static Future<void> showLoader(BuildContext context) async {
    showDialog(
      barrierColor: AppColors.white.withOpacity(0.3),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SpinKitCircle(
            color: AppColors.primaryColor,
            size: 70.0,
          ),
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }


  static Widget loaderWidget() {
    return  Center(
      child: SpinKitCircle(
        color: AppColors.primaryColor,
        size: 70.0,
      ),
    );
  }
}
