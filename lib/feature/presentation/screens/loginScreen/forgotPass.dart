import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/coreComponents/appBar2.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../../utils/appUtils.dart';
import 'forgot_pass_success_screen.dart';

class Forgotpass extends StatefulWidget {
  Forgotpass({super.key});

  @override
  _ForgotpassState createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  RxBool isValid = RxBool(false);


  void _updateEmailValidation() {
    isValid.value = _formKey.currentState?.validate() ?? false;
  }

  // Future<int?> _forgotPassword(BuildContext context, String email) async {
  //   if (!_formKey.currentState!.validate()) return null;
  //
  //   try {
  //     final authService = IAuthRepository();
  //     final response = await authService.forgotPassword(email: email).applyLoader;
  //
  //     if (response.isSuccess) {
  //       final otp = response.data!.data?.otp;
  //       final id = response.data!.data?.id;
  //       if(otp != null && id != null){
  //         _showOtpBottomSheet(context, otp, email, id);
  //       }
  //       return otp;
  //     } else {
  //       AppUtils.toastError(AppStrings.emailNotFound);
  //       return null;
  //     }
  //   } catch (e) {
  //     AppUtils.log('Forgot Password API error: $e');
  //     AppUtils.toastError(AppStrings.somethingWentWrong);
  //     return null;
  //   }
  // }
  

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
        title: Text(AppStrings.forgotpass),
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
      body: Padding(
        padding: 15.all,
        child: Form(
          key: _formKey,
          onChanged: _updateEmailValidation,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(
                    text:AppStrings.enterYourRegisteredEmail,
                    margin: 25.top,
                    style: 14.txtMediumWhite,
                  ),

                  TextView(
                    textAlign: TextAlign.start,
                    text: AppStrings.email,
                    style: 14.txtRegularWhite,
                    margin: 20.top + 15.bottom,
                  ),

                  EditText(
                    hint: AppStrings.Enteremail,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageView(url: AppImages.email, size: 20.sdp),
                      ],
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (!value!.isNotNullEmpty) {
                        return AppStrings.pleaseEnterYourEmail;
                      }
                      if (!value.isEmailAddress) {
                        return AppStrings.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),

          AppButton(
                    margin: 100.top,
                    radius: 10.sdp,
                    buttonColor: isValid.value ? AppColors.white : Colors.grey,
                    labelStyle: 18.txtBoldBlack,

                    label: AppStrings.sendLink,
                    onTap:(){
                      context.pushNavigator(ForgotPassSuccessScreen());
                    }
                    // isValid.value
                    //     ? () async {
                    //   if (_formKey.currentState?.validate() ?? false) {
                    //     String email = _emailController.textim();
                    //     await _forgotPassword(context, email);
                    //   }
                    // }
                    //     : null,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
