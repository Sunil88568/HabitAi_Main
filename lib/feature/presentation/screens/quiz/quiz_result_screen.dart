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

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = QuizController.find;
    final result = controller.getQuizResult();
    
    return Padding(
      padding: 20.all,
      child: Column(
        children: [
          // Result summary
          Container(
            width: double.infinity,
            padding: 30.all,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  result.correctAnswers == result.totalQuestions
                      ? Icons.emoji_events
                      : result.correctAnswers >= result.totalQuestions * 0.7
                          ? Icons.thumb_up
                          : Icons.refresh,
                  size: 80,
                  color: result.correctAnswers == result.totalQuestions
                      ? Colors.amber
                      : result.correctAnswers >= result.totalQuestions * 0.7
                          ? Colors.green
                          : Colors.orange,
                ),
                
                20.height,
                
                TextView(
                  text: result.correctAnswers == result.totalQuestions
                      ? 'Perfect Score!'
                      : result.correctAnswers >= result.totalQuestions * 0.7
                          ? 'Great Job!'
                          : 'Keep Practicing!',
                  style: 24.txtBoldBlack,
                  textAlign: TextAlign.center,
                ),
                
                10.height,
                
                TextView(
                  text: '${result.correctAnswers}/${result.totalQuestions} Correct',
                  style: 18.txtMediumBlack,
                ),
                
                TextView(
                  text: '${result.percentage.toStringAsFixed(1)}%',
                  style: 16.txtRegularBlack,
                ),
                
                20.height,
                
                Container(
                  padding: 16.all,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      8.width,
                      TextView(
                        text: 'Coins Earned: ${result.coinsEarned}',
                        style: 18.txtBoldBlack,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          20.height,
          
          // Question review
          Expanded(
            child: Container(
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
                    text: 'Review Answers',
                    style: 20.txtBoldBlack,
                  ),
                  
                  10.height,
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: result.questions.length,
                      itemBuilder: (context, index) {
                        final question = result.questions[index];
                        final userAnswer = result.userAnswers[index];
                        final isCorrect = controller.isAnswerCorrect(index);
                        final correctAnswer = controller.getCorrectAnswerText(index);
                        
                        return Container(
                          margin: 12.bottom,
                          padding: 16.all,
                          decoration: BoxDecoration(
                            color: isCorrect 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            border: Border.all(
                              color: isCorrect ? Colors.green : Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                  8.width,
                                  Expanded(
                                    child: TextView(
                                      text: 'Q${index + 1}: ${question.question}',
                                      style: 14.txtMediumBlack,
                                      maxlines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              
                              8.height,
                              
                              TextView(
                                text: 'Your answer: $userAnswer. ${question.options[userAnswer.codeUnitAt(0) - 65]}',
                                style: 12.txtRegularBlack,
                              ),
                              
                              if (!isCorrect) ...[
                                TextView(
                                  text: 'Correct answer: $correctAnswer',
                                  style: 12.txtRegularBlack.copyWith(color: Colors.green),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          20.height,
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Try Again',
                  labelStyle: 16.txtMediumBlack,
                  buttonColor: Colors.white,
                  buttonBorderColor: AppColors.primaryColor,
                  onTap: () {
                    controller.resetQuiz();
                    controller.startQuiz();
                  },
                  margin: 8.right,
                ),
              ),
              
              Expanded(
                child: AppButton(
                  label: 'Back to Home',
                  labelStyle: 16.txtBoldWhite,
                  buttonColor: AppColors.primaryColor,
                  onTap: () => context.pop(),
                  margin: 8.left,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}