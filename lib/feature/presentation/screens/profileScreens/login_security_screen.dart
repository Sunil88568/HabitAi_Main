import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

import '../../../../../components/coreComponents/AppButton.dart';
import '../../../../../components/coreComponents/TextView.dart';
import '../../../../../components/styles/appColors.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/styles/appImages.dart';
import 'changePassSetting.dart';

class LoginSecurityScreen extends StatelessWidget {
  const LoginSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text("Login & Security"),
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
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: 20.vertical + 20.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageView(url: AppImages.loginSecurityImg,size:40 ,margin: 20.bottom,),
            TextView(text: "Keep your account secure",style:20.txtBoldWhite ,margin: 10.bottom,),
            TextView(text: "We regularly review accounts to make sure they are as secure as possible. We'll also let you know if there's more  we can do to increase the security of your account.",style:16.txtMediumWhite ,margin: 10.bottom,),

            Divider(),
            TextView(text: "Password",style:20.txtBoldWhite ,margin: 15.bottom  +5.top,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(text: "Change Password",style: 16.txtRegularWhite,),
                TextView(text: "Change",style: 18.txtMediumWhite,

                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sdp)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.sdp),
                                topRight: Radius.circular(20.sdp),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: 10.vertical,
                                  child: Center(
                                    child: Container(
                                      width: 70.sdp,
                                      height: 5.sdp,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey,
                                        borderRadius: BorderRadius.circular(10.sdp),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: ChangePasswordScreen(),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  underlineColor: AppColors.white,
                  underline: true,
                ),

              ],
            ),

            Divider(),
            TextView(text: "Account",style:20.txtBoldWhite ,margin: 15.bottom  +5.top,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(text: "Deactivate your account",style: 16.txtRegularWhite,),
                TextView(text: "Deactivate",style: 18.txtMediumbtnred,onTap: () {
                  showConfirmationDialog(context);
                },
                underlineColor: AppColors.red,
                  underline: true,
                ),

              ],
            )
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
                      text: "Deactivate",
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
                      text: "Are you sure you want to deactivate your account ?",
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
                            label: "No",
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
                            label: "Yes",
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
