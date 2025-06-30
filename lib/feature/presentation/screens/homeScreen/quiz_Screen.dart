import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/homeScreen/web_view_screen.dart';
import 'package:question_app/services/storage/preferences.dart';
import 'package:question_app/utils/appUtils.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../components/appLoader.dart';
import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/appRadio.dart';
import '../../../../components/coreComponents/showLoginOptionsDilog.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../data/models/dataModels/question_model.dart';
import '../../controller/auth_ctrl.dart';
import '../../controller/profile_user_controller.dart';
import '../loginScreen/login_screen.dart';
import '../loginScreen/signup_screen.dart';
import 'home_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<QuestionModel> questions;
  String? guestid;

  QuizScreen({super.key, required this.questions, this.guestid});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? selectedOption;

  List<String> get options =>
      widget.questions.isNotEmpty ? widget.questions[0].options ?? [] : [];

  String get question =>
      widget.questions.isNotEmpty ? widget.questions[0].question ?? "" : "";

  String get questionId =>
      widget.questions.isNotEmpty ? widget.questions[0].id ?? "" : "";




  Future<String> getDeviceCountryParam() async {
    try {
      // Try to get current system locale
      String? countryCode = ui.PlatformDispatcher.instance.locale.countryCode;

      if (countryCode != null && countryCode.isNotEmpty) {
        return _mapCountryCodeToParam(countryCode.toUpperCase());
      }
    } catch (_) {}

    // Fallback
    return "uk";
  }

  String _mapCountryCodeToParam(String isoCode) {
    switch (isoCode) {
      case "US":
        return "uk";
      case "GB": // UK
        return "uk";
      case "IN":
        return "india";
      default:
        return "uk";
    }
  }




  Future<void> _submitForm() async {
    if (selectedOption == null) {
      AppUtils.log("No option selected");
      return;
    }

    AppUtils.log(
      "Submitting data => Question: $question, Selected Option: $selectedOption",
    );

    final token = Preferences.profile?.token;

    if (token == null || token.isEmpty) {
      final guestUserId = Preferences.guestUserId;
      if (guestUserId == null || guestUserId.isEmpty) {
        AppUtils.log("No guest user ID found");
        return;
      }

      try {
        var data = await AuthCtrl.find.checkout(guestUserId,await getDeviceCountryParam());

        if (data.statusCode == 200) {
          var value = await context.pushNavigator(
            WebViewScreen(url: data.data!.url.toString()),
          );

          print("Return Data = $value");

          if (value == "success") {
            print("Return Data = $value");
            final response =
                await AuthCtrl.find
                    .submitQuestionsGuestUser(
                      guestUserId,
                      questionId,
                      question,
                      selectedOption ?? "",
                    )
                    .applyLoader;
            if (response.isSuccess) {
              AppUtils.toast("Answer Submit Successfully");
              Preferences.guestUserId="";

              Navigator.pop(context, "success");
            }
          }

          /*final response = await AuthCtrl.find.submitQuestion(questionId,question, selectedOption ?? "").applyLoader;
         if (response.isSuccess) {
           AppUtils.toast("Answer Submit Successfully");

           context.pop();
         }*/
        }

        /*final response = await AuthCtrl.find.submitQuestionsGuestUser(guestUserId,questionId,question, selectedOption ?? "").applyLoader;
        if (response.isSuccess) {
          AppUtils.toast("Answer Submit Successfully");
          context.pop();
        }*/
      } catch (e) {
        AppUtils.log('Guest question submit error: $e');
      }
    } else {
      try {
        var data = await AuthCtrl.find.checkout(
          Preferences.profile!.id.toString(),await getDeviceCountryParam());
        if (data.statusCode == 200) {
          var value = await context.pushNavigator(
            WebViewScreen(url: data.data!.url.toString()),
          );
          if (value == "success") {
            print("Return Data = $value");
            final response =
                await AuthCtrl.find
                    .submitQuestion(questionId, question, selectedOption ?? "")
                    .applyLoader;
            if (response.isSuccess) {
              AppUtils.toast("Answer Submit Successfully");
              Navigator.pop(context, "success");

            }
          }
        }
      } catch (e) {
        AppUtils.log('Submit question error: $e');
      }
    }
  }

  void _handleLoginOptions(BuildContext context) async {
    final result = await showLoginOptionsDialog(context: context);

    if (result == 'login') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else if (result == 'signup') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SignupScreen()),
      );
    } else if (result == 'guest') {
      final guestInfo = await showGuestInfoDialog(context);
      if (guestInfo != null) {
        AppUtils.log('Guest Data: $guestInfo');

        try {
          final response =
              await AuthCtrl.find
                  .guestLogin(
                    name: guestInfo['name'],
                    email: guestInfo['email'],
                    mobileNumber: guestInfo['phone'],
                  )
                  .applyLoader;

          AppUtils.log('Guest Login Response: $response');
          final loginData = response.data;
          AppUtils.log(
            'Guest Login Response Data: name=${loginData?.name ?? ""}, email=${loginData?.email}, id=${loginData?.id}',
          );
          widget.guestid = loginData?.id;
          Preferences.guestUserId=loginData?.id;
          // context.pop();
          _submitForm();



        } catch (e) {
          AppUtils.log('Guest Login Error: $e');
        }
      }
    }
  }

  Future<Map<String, String>?> showGuestInfoDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            titlePadding: const EdgeInsets.only(
              left: 24,
              right: 8,
              top: 24,
              bottom: 0,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextView(text: 'Continue as Guest', style: 20.txtBoldBlack),
                IconButton(
                  icon: const Icon(Icons.close),
                  splashRadius: 20,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    8.height,
                    EditText(
                      controller: nameController,
                      hint: AppStrings.enterYourName,
                      hintStyle: 16.txtRegularGrey,
                      prefixIcon: _pfIcon(AppImages.nameImage),
                      validator:
                          (v) =>
                              v.isNotNullEmpty
                                  ? null
                                  : 'Please enter your name',
                      margin: 12.bottom,
                    ),
                    EditText(
                      controller: emailController,
                      hint: AppStrings.Enteremail,
                      inputType: TextInputType.emailAddress,
                      hintStyle: 16.txtRegularGrey,
                      prefixIcon: _pfIcon(AppImages.email),
                      validator: (v) {
                        if (!v.isNotNullEmpty)
                          return AppStrings.pleaseEnterYourEmail;
                        if (!v.isEmailAddress)
                          return AppStrings.pleaseEnterValidEmail;
                        return null;
                      },
                      margin: 12.bottom,
                    ),
                    EditText(
                      maxLength: 10,
                      controller: phoneController,
                      hint: AppStrings.enterMobileNumber,
                      inputType: TextInputType.phone,
                      hintStyle: 16.txtRegularGrey,
                      prefixIcon: _pfIcon(AppImages.phoneIcon),
                      validator:
                          (v) =>
                              v.isNotNullEmpty
                                  ? null
                                  : AppStrings.pleaseEnterYourPhoneNumber,
                    ),
                  ],
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              AppButton(
                label: 'Continue as Guest',
                isFilledButton: true,
                width: MediaQuery.of(context).size.width * 0.6,
                padding: 15.top + 15.bottom,
                labelStyle: 14.txtMediumWhite,
                buttonColor: AppColors.btnColor,
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context, {
                      'name': nameController.text.trim(),
                      'email': emailController.text.trim(),
                      'phone': phoneController.text.trim(),
                    });
                  }
                },
              ),
            ],
          ),
    );
  }

  Widget _pfIcon(String asset) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [ImageView(url: asset, size: 20.sdp, tintColor: AppColors.grey)],
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(AppStrings.question),
        titleTextStyle: 24.txtBoldWhite,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: "Test Your Knowledge\nwith Quizzes",
                    style: 25.txtsemiBoldWhite,
                  ),
                  ImageView(
                    url: AppImages.quizetimeimg,
                    height: 60.sdp,
                    width: 60.sdp,
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(text: "Question", style: 14.txtMediumgrey),
                    10.height,
                    TextView(text: question, style: 22.txtSBoldBlack),
                    const SizedBox(height: 12),
                    ...options.map((option) {
                      final isSelected = selectedOption == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = option;
                          });
                        },
                        child: Padding(
                          padding: 12.vertical,
                          child: Row(
                            children: [
                              AppRadio(
                                status: isSelected,
                                onChange: (value) {
                                  setState(() {
                                    selectedOption = option;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              TextView(text: option, style: 16.txtBoldBtncolor),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    16.height,
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedOption != null) {
                              final token = Preferences.profile?.token;

                              if (token != null && token.isNotEmpty) {
                                _submitForm();
                              } else {
                                _handleLoginOptions(context);
                              }
                            } else {
                              AppUtils.toast(
                                "Please select an option before submitting.",
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.btnColor,
                            padding: 14.vertical,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextView(
                            text: AppStrings.submit,
                            style: 16.txtBoldWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
