import 'dart:async';
import 'package:flutter/material.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/signup_screen.dart';
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
import '../../../../services/firebase/firebaseServices.dart';
import '../../controller/auth_ctrl.dart';
import '../homeScreen/home_screen.dart';
import 'forgotPass.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseServices.init(context).then((value){
      FirebaseServices.listener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar2(
                  padding: 10.top,
                  title: AppStrings.logIn,
                  titleAlign: TextAlign.center,
                  titleStyle: 24.txtBoldWhite,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: ImageView(
                                margin: 30.top + 40.bottom,
                                height: 146.sdp,
                                width: 165.sdp,
                                url: AppImages.loginimgLogo,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                padding: 15.vertical,
                                child: const EmailLoginForm(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
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
    emailController.dispose();
    passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

      AuthCtrl.find.login(
        emailController.text,
        passwordController.text,
      ).applyLoader.then((value){
        //  _getFcmToken();

        context.pushAndClearNavigator(HomeScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      marginBottom: 10.sdp,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: 17.top,
                        child: TextView(
                          textAlign: TextAlign.right,
                          text: AppStrings.forgotPassword,
                          style: 17.txtMediumbtncolor,
                          onTap: () {
                            context.pushNavigator(Forgotpass());
                          },
                          margin: 30.bottom,
                        ),
                      ),
                    ),
                    AppButton(
                      radius: 10,
                      width: double.infinity,
                      label: AppStrings.Continue,
                      labelStyle: _isFormValid ? 17.txtBoldWhite : 17.txtBoldGrey,
                      onTap: _isFormValid ? _submitForm : null,
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
                text: AppStrings.donthave,
                style: 14.txtRegularBlack,
              ),
              TextView(
                margin: 10.left,
                text: AppStrings.signUp,
                style: 14.txtregularBtncolor,
                onTap: () {
                  context.pushNavigator( SignupScreen());
                },
              ),
            ],
          ),
          30.height,
        ],
      ),
    );
  }

}
