import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/appUtils.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../components/appLoader.dart';
import '../../../../components/coreComponents/appRadio.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../data/models/dataModels/question_model.dart';
import '../../controller/auth_ctrl.dart';
import '../../controller/profile_user_controller.dart';


class QuizScreen extends StatefulWidget {
  final List<QuestionModel> questions;

  QuizScreen({super.key, required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? selectedOption;

  List<String> get options => widget.questions.isNotEmpty ? widget.questions[0].options ?? [] : [];
  String get question => widget.questions.isNotEmpty ? widget.questions[0].question ?? "" : "";

  Future<void> _submitForm() async {
    if (selectedOption == null) {
      AppUtils.log("No option selected");
      return;
    }

    AppUtils.log("Submitting data => Question: $question, Selected Option: $selectedOption");

    AuthCtrl.find.submitQuestion(question, selectedOption ?? "").applyLoader.then((value) {
      context.pop();
    });
  }

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
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
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
                  )
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
                              _submitForm();
                            } else {
                              AppUtils.toast("Please select an option before submitting.");
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
                    )
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
