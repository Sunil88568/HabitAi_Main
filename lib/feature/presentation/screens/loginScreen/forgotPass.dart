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
import '../../../data/models/dataModels/responseDataModel.dart';
import '../../controller/auth_ctrl.dart';
import 'forgot_pass_success_screen.dart';

class Forgotpass extends StatefulWidget {
  Forgotpass({super.key});

  @override
  _ForgotpassState createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isValid = false;


  void _updateEmailValidation() {
    setState(() {
      isValid = _formKey.currentState?.validate() ?? false;
    });
  }


  Future<bool> _forgotPassword() async {
    final ResponseData responseData = await AuthCtrl.find
        .forgotPassword(_emailController.getText)
        .applyLoader;

    if (responseData.isSuccess) {
      context.pushAndClearNavigator(ForgotPassSuccessScreen());
      return true;
    } else {
      AppUtils.toastError(responseData.getError);
      return false;
    }
  }

  

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
                    buttonColor: isValid ? AppColors.white : Colors.grey,
                    labelStyle: 18.txtBoldBlack,
                    label: AppStrings.sendLink,
                    onTap: isValid
                        ? () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _forgotPassword();
                      }
                    }
                        : null,
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
