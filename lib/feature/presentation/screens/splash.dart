
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import '../../../components/coreComponents/ImageView.dart';
import '../../../components/styles/appImages.dart';
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
    Future.delayed( Duration(seconds: 3), () {
      context.pushAndClearNavigator(LoginScreen());
    });
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
