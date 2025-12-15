import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_app/components/coreComponents/AppButton.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/controller/quiz_controller.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = QuizController.find;
    
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Obx(() => Text(
          controller.isPremiumQuiz.value ? "Premium Quiz" : "Free Quiz",
        )),
        titleTextStyle: 24.txtBoldWhite,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: 20.all,
          child: Column(
            children: [
              // Timer (only for free quiz)
              Obx(() {
                if (!controller.isPremiumQuiz.value) {
                  return Container(
                    padding: 15.all,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextView(text: "Time Remaining:", style: 16.txtMediumBlack),
                        TextView(
                          text: "${controller.timeRemaining.value}s",
                          style: 20.txtBoldBlack,
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
              
              if (!controller.isPremiumQuiz.value) 20.height,
              
              // Question Progress
              Obx(() => Container(
                padding: 15.all,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      text: "Question ${controller.currentQuestionIndex.value + 1} of ${controller.questions.length}",
                      style: 16.txtMediumBlack,
                    ),
                    if (!controller.isPremiumQuiz.value)
                      TextView(
                        text: "Coins: ${controller.userCoins.value}",
                        style: 16.txtMediumBlack,
                      ),
                  ],
                ),
              )),
              
              20.height,
              
              // Question Card
              Expanded(
                child: Obx(() {
                  if (controller.questions.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.white),
                    );
                  }
                  
                  final question = controller.questions[controller.currentQuestionIndex.value];
                  
                  return Container(
                    width: double.infinity,
                    padding: 20.all,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          text: question.question,
                          style: 20.txtBoldBlack,
                          margin: 20.bottom,
                        ),
                        
                        // Options
                        ...question.options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
                          
                          return Obx(() => GestureDetector(
                            onTap: () => controller.selectAnswer(optionLetter),
                            child: Container(
                              width: double.infinity,
                              padding: 15.all,
                              margin: 10.bottom,
                              decoration: BoxDecoration(
                                color: controller.selectedAnswer.value == optionLetter
                                    ? AppColors.primaryColor.withOpacity(0.2)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: controller.selectedAnswer.value == optionLetter
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: controller.selectedAnswer.value == optionLetter
                                          ? AppColors.primaryColor
                                          : Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: TextView(
                                        text: optionLetter,
                                        style: 14.txtBoldWhite,
                                      ),
                                    ),
                                  ),
                                  15.width,
                                  Expanded(
                                    child: TextView(
                                      text: option,
                                      style: 16.txtMediumBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        }).toList(),
                        
                        Spacer(),
                        
                        // Navigation Buttons
                        Row(
                          children: [
                            if (controller.currentQuestionIndex.value > 0)
                              Expanded(
                                child: AppButton(
                                  label: "Previous",
                                  labelStyle: 16.txtBoldWhite,
                                  buttonColor: Colors.grey,
                                  onTap: () => controller.previousQuestion(),
                                ),
                              ),
                            
                            if (controller.currentQuestionIndex.value > 0) 10.width,
                            
                            Expanded(
                              child: Obx(() => AppButton(
                                label: controller.currentQuestionIndex.value < controller.questions.length - 1
                                    ? "Next"
                                    : "Finish",
                                labelStyle: 16.txtBoldWhite,
                                buttonColor: controller.selectedAnswer.value.isNotEmpty
                                    ? AppColors.btnColor
                                    : Colors.grey,
                                onTap: controller.selectedAnswer.value.isNotEmpty
                                    ? () {
                                        if (controller.currentQuestionIndex.value < controller.questions.length - 1) {
                                          controller.nextQuestion();
                                        } else {
                                          controller.completeQuiz();
                                          _showResultDialog(context, controller);
                                        }
                                      }
                                    : null,
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showResultDialog(BuildContext context, QuizController controller) {
    final result = controller.getQuizResult();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: TextView(
          text: controller.isPremiumQuiz.value ? "Premium Quiz Complete!" : "Quiz Complete!",
          style: 20.txtBoldBlack,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextView(
              text: "Correct Answers: ${result.correctAnswers}/${result.totalQuestions}",
              style: 16.txtMediumBlack,
              textAlign: TextAlign.center,
            ),
            if (!controller.isPremiumQuiz.value) ...[
              10.height,
              TextView(
                text: "Coins Earned: ${result.coinsEarned}",
                style: 16.txtMediumBlack,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actions: [
          AppButton(
            label: "Continue",
            labelStyle: 16.txtBoldWhite,
            buttonColor: AppColors.btnColor,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop("success");
            },
          ),
        ],
      ),
    );
  }
}