import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:question_app/components/coreComponents/AppButton.dart';
import 'package:question_app/components/coreComponents/ImageView.dart';
import 'package:question_app/components/coreComponents/TextView.dart';
import 'package:question_app/components/styles/appColors.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/controller/auth_ctrl.dart';
import 'package:question_app/feature/presentation/screens/homeScreen/quiz_Screen.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/login_screen.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/signup_screen.dart';
import 'package:question_app/utils/appUtils.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../components/coreComponents/appDialog.dart';
import '../../../../components/coreComponents/showAppDilog.dart';
import '../../../../services/storage/preferences.dart';
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
  void initState() {
    super.initState();
    AppUtils.log("image:::${profileCtrl.userProfile.value?.image?.fileUrl}");
    AppUtils.log("User Id:::${Preferences.uid}");
    profileCtrl.fetchUserProfile();
    questionCtrl.getQuestions();
    if( Preferences.authToken != null){
      AuthCtrl.find.getNotifications(Preferences.profile!.id.toString());
    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileCtrl.fetchUserProfile();
  }


  final questionCtrl = Get.put(ProfileUserController());



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;


    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Preferences.authToken != null
                ? Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.pushNavigator(ProfileScreen());
                        },
                        child: Center(
                          child: ClipOval(
                            child: Obx(() {
                              return profileCtrl.userProfile.value?.image?.fileUrl != null
                                  ? ImageView(
                                url: profileCtrl.userProfile.value?.image?.fileUrl ?? "",
                                defaultImage: AppImages.dummyImg,
                                size: 45.sdp,
                                imageType: ImageType.network,
                                fit: BoxFit.cover,
                              )
                                  : Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 45.sdp,
                                  height: 45.sdp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      10.width,
                      Obx(() {
                        return TextView(
                          text: 'Hello, ${profileCtrl.userProfile.value?.name ?? ""}',
                          style: 20.txtBoldWhite,
                        );
                      }),
                    ],
                  ),
                  ImageView(
                    url: AppImages.notificationImg,
                    size: width * 0.09,
                    onTap: () async {
                      await context.pushNavigator(Notificationscreen());
                      questionCtrl.getQuestions();
                    },
                  ),
                ],
              ),
            )
                :     Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      padding: 10.top+ 10.bottom,
                      margin: 20.right,
                      width: MediaQuery.of(context).size.width * 0.4,
                      isFilledButton: false,
                      radius: 10,
                      label: "Sign In / Register",
                      labelStyle: 14.txtSBoldBlack,
                      buttonColor: AppColors.white,
                      onTap: () {

                         showAppDialog(
                        context: context,
                        title: 'Sign In / Register',
                        message: 'Please Sign In / Register For Continue',
                        confirmLabel: 'Sign In',
                        cancelLabel: 'Register',
                        onConfirm: () {
                          context.pushAndClearNavigator(LoginScreen());
                        },
                             onCancel: (){

                           context.pushAndClearNavigator(SignupScreen());
                         }
                        );

                      },

                    ),
                  ],
                ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextView(
                                  margin: 30.top + 5.bottom,
                                  text: 'Ready to Win\nBig This\nWeek?',
                                  style: 27.txtBoldWhite
                              ),
                              TextView(
                                  margin: 20.bottom,
                                  text: 'This week quiz is closing down on Friday take part before it’s too late to win exciting prizes',
                                  style: 14.txtMediumWhite
                              ),
                            ],
                          ),
                        ),
                        ImageView(
                          url: AppImages.giftImg,
                          height: height * 0.25,
                          width: width * 0.4,
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
                          if(questionCtrl.questionList.isNotEmpty){

                            if(questionCtrl.questionList.first.isSubmitted==false) {
                              context.pushNavigator(QuizScreen(
                                  questions: questionCtrl.questionList));
                            }else{
                              AppUtils.toast("You already submitted the response");
                            }
                          }else{
                            AppUtils.toastError("No Quiz Found");
                          }

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
                        _buildStatCard(context, 'Current\nPrize Pool', (questionCtrl.questionList.isNotEmpty)?"\$${questionCtrl.questionList.first.pricePoll.toString()}":"\$0.00"),
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
          ],
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
