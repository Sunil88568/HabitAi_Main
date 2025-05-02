import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/app_strings.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/login_screen.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';

import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/styles/appColors.dart';

class ForgotPassSuccessScreen extends StatelessWidget {
   ForgotPassSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageView(url: AppImages.tickIconImg,
                height:120.sdp,
                width: 120.sdp,
              ),
            ],
          ),
          TextView(
            margin: 30.top,
            text: AppStrings.success,
          style: 30.txtBoldWhite,
          ),

          TextView(
            margin: 30.top,
            text: AppStrings.passChangeSucceess,
            style: 20.txtBoldWhite,
            textAlign: TextAlign.center,
          ),
      AppButton(
        margin: 100.top + 20.left + 20.right,
        radius: 10.sdp,
        buttonColor: AppColors.white,
        labelStyle: 18.txtBoldBlack,
        label: AppStrings.goToLogin,
        onTap:(){
          context.pushAndClearNavigator(LoginScreen());
        }
    )

        ],
      ),
    );
  }
}
