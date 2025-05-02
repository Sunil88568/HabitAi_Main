import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/profileScreens/contactus.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';

import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/coreComponents/listRow.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import 'login_security_screen.dart';

class SettingScreen extends StatefulWidget {
   SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();


}

class _SettingScreenState extends State<SettingScreen> {

  var isNotificationOn = false.obs;

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
        title: Text(AppStrings.Settings),
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
          CustomListRow(
            leading: Padding(
              padding: 16.top,
              child: ImageView(url: AppImages.contactUs,size: 25,),
            ),
            title: TextView(
              text: "Login & security",
              style: 18.txtMediumWhite,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sdp,
              color: AppColors.white,
            ),
            onTap: () async {
              context.pushNavigator(LoginSecurityScreen());
            },
          ),
          Container(
            child: Column(
              children: [
                CustomListRow(
                  leading: Padding(
                    padding: 16.top,
                    child: ImageView(
                      url: AppImages.settingNotification,
                      size: 24,
                    ),
                  ),
                  title: TextView(
                    text: "Notifications",
                    style: 18.txtMediumWhite,
                  ),
                  trailing: Obx(
                        () => Switch(
                      value: isNotificationOn.value,
                      activeColor: AppColors.quzeYellow,
                      onChanged: (value) {
                        isNotificationOn.value = value;
                      },
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          CustomListRow(
            leading: Padding(
              padding: 16.top,
              child: ImageView(url: AppImages.settingConact,size: 25,),
            ),
            title: TextView(
              text: "Contact Us",
              style: 18.txtMediumWhite,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sdp,
              color: AppColors.white,
            ),
            onTap: () async {
              context.pushNavigator(Contactus());
            },
          ),
        ],
      ),
    );
  }
}
