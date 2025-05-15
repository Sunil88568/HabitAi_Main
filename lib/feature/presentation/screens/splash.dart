
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import '../../../components/coreComponents/ImageView.dart';
import '../../../components/styles/appImages.dart';
import '../../../services/storage/preferences.dart';
import '../controller/profile_user_controller.dart';
import 'homeScreen/home_screen.dart';
import 'loginScreen/login_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }


  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    // if (Preferences.authToken != null) {
      context.pushAndClearNavigator(const HomeScreen());
    // } else {
      // context.pushAndClearNavigator(LoginScreen());
    }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SizedBox.expand(
          // child: ImageView(
          //   url: AppImages.loginimgLogo,
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}
