import 'dart:async';
import 'package:flutter/material.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/app_strings.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/homeScreen/home_screen.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/login_screen.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';

class SignupSuccess extends StatefulWidget {
  const SignupSuccess({super.key});

  @override
  State<SignupSuccess> createState() => _SignupSuccessState();
}

class _SignupSuccessState extends State<SignupSuccess> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // context.pushAndClearNavigator(LoginScreen()
      context.pushAndClearNavigator(HomeScreen()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageView(
                url: AppImages.successSignup,
                height: 208,
                width: 208,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              TextView(
                text: AppStrings.signupSuccess,
                style: 20.txtSBoldBlack,
              ),
              const SizedBox(height: 12),
              TextView(
                text:
                '',
                style: 14.txtregularBtncolor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
