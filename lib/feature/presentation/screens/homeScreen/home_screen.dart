import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:question_app/components/coreComponents/AppButton.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/homeScreen/quiz_Screen.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../controller/profile_user_controller.dart';
import '../notificationScreens/notificationScreen.dart';
import '../profileScreens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final profileCtrl = Get.put(ProfileUserController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          context.pushNavigator(ProfileScreen());
                        },
                        child:

                        // ImageView(
                        //     url: profileCtrl.userProfile.value?.image.fileUrl ?? "",
                        //   radius: width * 0.05,
                        //   defaultImage: AppImages.dummyImg,
                        // )

                        CircleAvatar(
                          radius: width * 0.05,
                          backgroundImage: AssetImage(
                            AppImages.dummyImg,
                          ),
                        ),
                      ),
                      10.width,
                      TextView(
                          text:
                          'Hello, ${profileCtrl.userProfile.value?.name ?? ""}',
                          style: 20.txtBoldWhite
                      ),
                    ],
                  ),
                  ImageView(url: AppImages.notificationImg,
                    size: width * 0.09,
                    onTap: (){
                      context.pushNavigator(Notificationscreen());
                    },
                  )
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextView(
                            margin: 30.top + 12.bottom,
                            text: 'Ready to Win\nBig This\nWeek?',
                            style: 30.txtBoldWhite
                        ),
                        TextView(
                            margin: 20.bottom,
                            text: 'This week quiz is closing\ndown on Friday take\npart before it’s too late to\nwin exciting prizes',
                            style: 16.txtMediumWhite
                        ),
                      ],
                    ),
                  ),
                  ImageView(
                    url: AppImages.giftImg,
                    height: height * 0.25,
                    width: width * 0.5,
                    margin: 20.bottom,
                  ),
                ],
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: AppButton(
                  radius: 10,
                  label: "Join This Week’s\nQuiz",
                  labelStyle: 18.txtBoldBlack,
                  buttonColor: AppColors.quzeYellow,
                  alignment: Alignment.center,
                  onTap: (){
                    context.pushNavigator(QuizScreen());
                  },
                ),
              ),

              Row(
                  children:[ TextView(
                    text:
                    'Ends in: 5 Days',
                    style: 16.txtMediumWhite,
                    margin: 20.bottom + 5.top,
                  ),
                  ]
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(context, 'Total Players\nThis Week', '8,542'),
                  _buildStatCard(context, 'Current\nPrize Pool', '\$5,542'),
                  _buildStatCard(context, 'Winners\nAnnounced In', '5 Days'),
                ],
              ),
              30.height,
              Center(
                  child:
                  ImageView(url: AppImages.enterToWinPrice,
                    height: 232.sdp,
                    width: 340.sdp,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBagroundHome,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            TextView(
              text:
              label,
              style: 12.txtBoldWhite,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
                value,
                textAlign: TextAlign.center,
                style: 20.txtMediumWhite
            ),
          ],
        ),
      ),
    );
  }
}
