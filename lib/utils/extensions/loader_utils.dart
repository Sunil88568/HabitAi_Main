import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../components/styles/appColors.dart';
import '../../main.dart';


class LoaderUtils{
  static BuildContext? get _context => navState.currentContext;

  static GlobalLoaderOverlay loaderInit({required Widget child}){
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (_){
        return  Center(
          child: SpinKitCircle(
            color: AppColors.btnColor, // Green Loader
            size: 70.0,
          ),


          // SpinKitCircle(
          //   color: AppColors.btnColor, // Green Loader
          //   size: 70.0,
          // )
        );
      },
      child: child,
    );
  }

  static openPopup(Widget child){
    _context?.loaderOverlay.show(
      widgetBuilder: (_){
        return child;
      },

    );
  }

  static show(){
    try{
      _context?.loaderOverlay.show();
      print('start');
    }catch(e){
      print('isssueeee ::: $e');
    }

  }

  static dismiss({String? msg}) async{
    _context?.loaderOverlay.hide();
    // if(msg!= null) AppUtils.toast(msg);
  }

  static showError(String error){
    _context?.loaderOverlay.hide();
    // AppUtils.toastEr(Exception(error));
    // AppUtils.toastFailure(error);
  }
}

// class LoaderUtils{
//
//   static TransitionBuilder init(){
//     configLoading();
//     return EasyLoading.init();
//   }
//
//   static void configLoading() {
//     EasyLoading.instance
//       ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//       ..loadingStyle = EasyLoadingStyle.dark
//       ..indicatorSize = 45.0
//       ..radius = 10.0
//       ..progressColor = Colors.yellow
//       ..backgroundColor = Colors.green
//       ..indicatorColor = Colors.yellow
//       ..textColor = Colors.yellow
//       ..maskColor = Colors.blue.withOpacity(0.5)
//       ..userInteractions = false;
//   }
//
//   static show(){
//     EasyLoading.show(
//       maskType: EasyLoadingMaskType.black,
//       dismissOnTap: false,
//       status: 'Loading...',
//     );
//   }
//
//   static dismiss(){
//   EasyLoading.dismiss();
//   }
//
//
//   static showError(String error){
//   EasyLoading.showError(error,);
//  }
//
//  static removeAll(){
//    EasyLoading.removeAllCallbacks();
//  }
//
// }
//
// class BackButtonInterceptor extends StatefulWidget {
//   final Widget child;
//
//   BackButtonInterceptor({required this.child});
//
//   @override
//   _BackButtonInterceptorState createState() => _BackButtonInterceptorState();
// }
//
// class _BackButtonInterceptorState extends State<BackButtonInterceptor> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   Future<bool> didPopRoute() async {
//     if (EasyLoading.isShow) {
//       // Prevent back navigation
//       return true;
//     }
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }