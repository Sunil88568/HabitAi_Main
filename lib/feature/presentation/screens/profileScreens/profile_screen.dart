
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/login_screen.dart';
import 'package:question_app/feature/presentation/screens/profileScreens/persional_info_screen.dart';
import 'package:question_app/feature/presentation/screens/profileScreens/privacypolicy.dart';
import 'package:question_app/feature/presentation/screens/profileScreens/setting_screen.dart';
import 'package:question_app/feature/presentation/screens/profileScreens/termandconditions.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: Text(AppStrings.Profile),
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
        actions: [
          ImageView(
            url: AppImages.settingiconImg,
            size: 25,
            margin: 10.vertical + 16.horizontal,
            onTap: (){
              context.pushNavigator(SettingScreen());
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: 20.left + 20.right + 20.top,
            child: Column(
              children: [
                _imageWidget(),
                _commonWidget(
                  image: AppImages.persionalInfo,
                  text: AppStrings.persionalInfo,
                  onTap: () {
                    context.pushNavigator(PersonalInfoScreen());
                  },
                ),
                _commonWidget(
                  image: AppImages.termAndCondation,
                  text: "Terms & Conditions",
                  onTap: () {
                    context.pushNavigator(Termandconditions());
                  },
                ),
                _commonWidget(
                  onTap: () {
                    context.pushNavigator(PrivacyPolicy());
                  },
                  image: AppImages.privacyIconImage,
                  text: "Privacy Policy",
                ),
                _commonWidget(
                  onTap: () {
                    showConfirmationDialog(context);
                  },
                  image: AppImages.logoutImg,
                  text: "Log Out",
                  iconColor: AppColors.red,
                  textStyle: 18.txtMediumbtnred
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return Column(
      children: [
        Center(
          child: ImageView(
            url: AppImages.dummyImg,
            size: 107,
            margin: 20.bottom,
          ),
        ),
        TextView(
          margin: 10.top + 10.bottom,
          text: "John",
          style: 24.txtBoldWhite,
        )
      ],
    );
  }

  Widget _commonWidget({
    required String image,
    required String text,
    required GestureTapCallback onTap,
    TextStyle? textStyle,
    Color? iconColor,
    double? iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: 20.top,
        padding: 16.horizontal + 14.vertical,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.white,
          ),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            ImageView(
              url: image,
              size: 25,
            ),
            16.width,
            Expanded(
              child: TextView(
                text: text,
                style: textStyle ?? 18.txtMediumBlack,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: iconSize ?? 16,
              color: iconColor ?? AppColors.black,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> showConfirmationDialog(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    bool? confirmDeletion = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: width * 0.1),
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.02),
                    TextView(
                      text: "Log Out",
                      style: 24.txtBoldBlack,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.02),
                    Divider(
                      color: AppColors.Grey,
                      thickness: 1,
                      height: 1,
                    ),
                    SizedBox(height: height * 0.02),
                    TextView(
                      text: "Are you sure you want to log out?",
                      textAlign: TextAlign.center,
                      style: 16.txtRegularBlack,
                      margin: EdgeInsets.only(top: height * 0.02),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: height * 0.07,
                          child: AppButton(
                            radius: 25.sdp,
                            label: "Cancel",
                            labelStyle: 14.txtRegularBlack,
                            buttonColor: AppColors.white,
                            buttonBorderColor: AppColors.grey,
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            isFilledButton: false,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Flexible(
                        child: SizedBox(
                          height: height * 0.07,
                          child: AppButton(
                            radius: 25.sdp,
                            label: "Log Out",
                            labelStyle: 14.txtBoldWhite,
                            buttonColor: AppColors.btnColor,
                            onTap: () {
                              context.pop();
                            },
                            isFilledButton: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.01),
              ],
            ),
          ],
        );
      },
    );
  }




}
