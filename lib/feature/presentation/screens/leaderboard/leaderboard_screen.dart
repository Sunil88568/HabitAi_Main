import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_app/components/coreComponents/AppButton.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/controller/leaderboard_controller.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LeaderboardController.find;
    
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            bottom: 0,
            right: 20,
            child: ImageView(
              url: AppImages.giftImg,
              size: 100,
              tintColor: Colors.orange.withOpacity(0.3),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: 20.all,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: 20.vertical,
                            child: TextView(
                              text: "Leaderboard",
                              style: 22.txtBoldBlack,
                            ),
                          ),
                          Expanded(
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                );
                              }
                              
                              return controller.leaderboardUsers.isEmpty
                                  ? Center(
                                      child: TextView(
                                        text: "No leaderboard data available",
                                        style: 16.txtMediumBlack,
                                      ),
                                    )
                                  : ListView(
                                      padding: 20.horizontal,
                                      children: [
                                        // Top users
                                        ...controller.leaderboardUsers.asMap().entries.map((entry) {
                                          final index = entry.key;
                                          final user = entry.value;
                                          return _buildItem(
                                            user.name,
                                            "${user.points} Pts",
                                            index == 0, // First place gets crown
                                          );
                                        }).toList(),
                                  
                                  // Dashed line separator
                                  if (controller.currentUser.value != null)
                                    Container(
                                      margin: 15.vertical,
                                      child: Row(
                                        children: List.generate(50, (index) => 
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              margin: 1.horizontal,
                                              color: index % 2 == 0 ? Colors.grey : Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  
                                  // Current user
                                  if (controller.currentUser.value != null)
                                    _buildItem(
                                      "You",
                                      "${controller.currentUser.value!.points} Pts",
                                      false,
                                      isUser: true,
                                    ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.height,
                  Container(
                    width: double.infinity,
                    child: AppButton(
                      label: "Back to Home",
                      labelStyle: 18.txtBoldBlack,
                      buttonColor: Colors.white,
                      radius: 15,
                      padding: 16.vertical,
                      onTap: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String name, String points, bool hasWinner, {bool isUser = false}) {
    return Container(
      margin: 8.bottom,
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, color: Colors.grey.shade600, size: 20),
              ),
              if (hasWinner)
                Positioned(
                  top: -2,
                  left: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          12.width,
          Expanded(
            child: TextView(
              text: name,
              style: 16.txtMediumBlack,
            ),
          ),
          TextView(
            text: points,
            style: 16.txtMediumBlack,
          ),
        ],
      ),
    );
  }
}