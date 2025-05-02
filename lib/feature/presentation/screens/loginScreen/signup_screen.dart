import 'dart:async';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/login_screen.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/coreComponents/appBar2.dart';
import '../../../../components/coreComponents/common_password_input_field.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../../utils/appUtils.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'addProfile_screen.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupState();
}

class _SignupState extends State<SignupScreen> {
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
        title: Text( AppStrings.signUp),
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
      body: Column(
        children: [
          Expanded(
            child: const EmailLoginForm()
          ),
        ],
      ),
    );
  }
}

class EmailLoginForm extends StatefulWidget {
  const EmailLoginForm({super.key});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  Rx<Country?> countryData  = Rx(null);


  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    //  _getFcmToken(); // Get FCM token on initialization

  }



  void _updateButtonState() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1), () {
      setState(() {});
    });
  }

  bool get _isFormValid =>
      emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          _formKey.currentState!.validate() ?? false;

  @override
  void dispose() {
    // emailController.removeListener(_updateButtonState);
    // passwordController.removeListener(_updateButtonState);
    emailController.dispose();
    passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // void _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //
  //     AuthCtrl.find.login(
  //       emailController.text,
  //       passwordController.text,
  //     ).applyLoader.then((value){
  //       //  _getFcmToken();
  //
  //       context.pushAndClearNavigator(HomeScreen());
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: 20.left + 20.right,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      40.height,
                      TextView(
                        textAlign: TextAlign.start,
                        text: AppStrings.name,
                        style: 14.txtRegularBlack,
                        margin: 8.vertical,
                      ),
                      EditText(
                        hint: AppStrings.enterYourName,
                        hintStyle: 16.txtRegularGrey,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageView(url: AppImages.nameImage, size: 20.sdp, tintColor: AppColors.grey),
                          ],
                        ),
                        margin: 20.bottom,
                        controller: emailController,
                        validator: (value) {
                          if (!value.isNotNullEmpty) return AppStrings.pleaseEnterYourEmail;
                          if (!value.isEmailAddress) return AppStrings.pleaseEnterValidEmail;
                          return null;
                        },
                      ),
                      TextView(
                        textAlign: TextAlign.start,
                        text: AppStrings.email,
                        style: 14.txtRegularBlack,
                        margin: 8.vertical,
                      ),
                      EditText(
                        hint: AppStrings.Enteremail,
                        hintStyle: 16.txtRegularGrey,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageView(url: AppImages.email, size: 20.sdp, tintColor: AppColors.grey),
                          ],
                        ),
                        margin: 20.bottom,
                        controller: emailController,
                        validator: (value) {
                          if (!value.isNotNullEmpty) return AppStrings.pleaseEnterYourEmail;
                          if (!value.isEmailAddress) return AppStrings.pleaseEnterValidEmail;
                          return null;
                        },
                      ),

                      TextView(
                        textAlign: TextAlign.start,
                        text: AppStrings.phone,
                        style: 14.txtRegularBlack,
                        margin: 8.vertical,
                      ),
                      _buildPhoneField(),
                      20.height,
                      TextView(
                        textAlign: TextAlign.start,
                        text: AppStrings.pass,
                        style: 14.txtRegularBlack,
                        margin: 4.bottom,
                      ),
                      CommonPasswordInputField(
                        controller: passwordController,
                        hint: AppStrings.EnterPass,
                        inputType: TextInputType.visiblePassword,
                        leading: Padding(
                          padding: 16.all,
                          child: ImageView(url: AppImages.passimg, size: 16.sdp),
                        ),
                        validator: (value) {
                          if (!value!.isNotNullEmpty) return AppStrings.pleaseEnterYourPassword;
                          if (!value.isPassword) return AppStrings.passwordMustBeAtLeast;
                          return null;
                        },
                        marginBottom: 20.sdp,
                      ),

                      TextView(
                        textAlign: TextAlign.start,
                        text: AppStrings.Confirpass,
                        style: 14.txtRegularBlack,
                        margin: 4.bottom,
                      ),
                      CommonPasswordInputField(
                        controller: passwordController,
                        hint: AppStrings.EnterPass,
                        inputType: TextInputType.visiblePassword,
                        leading: Padding(
                          padding: 16.all,
                          child: ImageView(url: AppImages.passimg, size: 16.sdp),
                        ),
                        validator: (value) {
                          if (!value!.isNotNullEmpty) return AppStrings.pleaseEnterYourPassword;
                          if (!value.isPassword) return AppStrings.passwordMustBeAtLeast;
                          return null;
                        },
                        marginBottom: 10.sdp,
                      ),

                      AppButton(
                        margin: 30.top,
                        radius: 10,
                        width: double.infinity,
                        label: AppStrings.next,
                        labelStyle: _isFormValid ? 17.txtBoldWhite : 17.txtBoldGrey,
                        onTap: () {context.pushNavigator(AddprofileScreen());},

                        // _isFormValid ? null : null,
                        buttonColor: _isFormValid
                            ? AppColors.btnColor
                            : AppColors.greyHint.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  text: AppStrings.alreadyHaveAcc,
                  style: 14.txtRegularBlack,
                ),
                TextView(
                  margin: 10.left,
                  text: AppStrings.signIn,
                  style: 14.txtregularBtncolor,
                  onTap: () {
                    context.pushNavigator(LoginScreen());
                  },
                ),
              ],
            ),
            30.height,
          ],
        ),
      ),
    );
  }



  Widget _buildPhoneField() {
    return Row(
      children: [
        Expanded(
          child: EditText(
            prefixIcon: Container(
              child: SizedBox(
                height: 30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                AppUtils.log(country.phoneCode);
                                countryData.value = country;
                                countryData.refresh();
                                // countryCode.value = country.phoneCode;
                                // countryCode.refresh();
                                AppUtils.log('Selected Country Code: ${country.phoneCode}');
                              },
                              countryListTheme: CountryListThemeData(
                                borderRadius: BorderRadius.circular(10.0),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search Country',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: AppColors.grey.withOpacity(0.6)),
                              ),
                            ),
                            child: Obx(
                                  () => Row(
                                children: [

                                  Text(
                                    countryData.value?.flagEmoji ?? '',
                                    style: TextStyle(fontSize: 26, color: AppColors.grey),
                                  ),
                                  Text(
                                     '+1',
                                    style: 14.txtMediumbtncolor,
                                  ),
                                  Icon(Icons.keyboard_arrow_down, size: 18.sdp, color: AppColors.primaryColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                        10.width,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // controller: phoneCtrl,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

}
