import 'package:flutter/material.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/homeScreen/home_screen.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/appBar2.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/app_strings.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int maxScore;
  final String userName;

  const ResultScreen({
    super.key,
    required this.score,
    required this.maxScore,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text( AppStrings.result,),
        titleTextStyle: 24.txtBoldWhite,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              40.height,
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 493,
                    height: 353,
                    child: ImageView(url: AppImages.resultbackImg, fit: BoxFit.contain,)
                  ),
                  Container(
                    width: 187,
                    height: 187,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.scorecolor,
                        width: 6,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           TextView(
                            text:
                            "Your Score",
                            style: 24.txtregularBtncolor,
                          ),
                          10.height,
                          TextView(
                            text:
                            "$score/$maxScore",
                            style: 34.txtRegularbtncolor
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
               TextView(
                 margin: 40.top+  12.bottom,
                text:
                "Congratulation",
                style: 30.txtBoldWhite
              ),
              TextView(
                text:
                "Great job, $userName! You Did It",
                style: 18.txtMediumWhite
              ),
              AppButton(
                label: AppStrings.backtoHome,
                labelStyle:18.txtBoldBlack ,
                buttonColor: AppColors.white,
                radius: 10.sdp,
                margin: 30.bottom+ 70.top,
                onTap: (){
                  context.pushAndClearNavigator(HomeScreen());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
