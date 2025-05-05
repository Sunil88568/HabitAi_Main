import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/data/models/dataModels/login_model/login_model.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/coreComponents/AppButton.dart';
import '../../../../../components/styles/appColors.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import '../../controller/profile_Info_controller.dart';

class PersonalInfoScreen extends StatefulWidget {
  final LoginModel? userData;
  PersonalInfoScreen({super.key, this.userData});


  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {

  final PersonalInfoController controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    controller.setUser(widget.userData);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text("Personal Information"),
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
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: 16.horizontal,
        child: Column(
          children: [
            20.height,
            Center(
              child: ImageView(
                url: AppImages.dummyImg,
                size: 107,
                margin: 20.bottom,
              ),
            ),
            TextView(
              margin: 10.top + 10.bottom,
              text: widget.userData?.name ?? "",
              style: 24.txtBoldWhite,
            ),

            _buildInfoTile("Name", widget.userData?.name ?? "", context),
            _buildInfoTile("Email", widget.userData?.email ?? "", context),
            _buildInfoTile("Phone number", "${widget.userData?.countryCode ?? ""}  ${widget.userData?.mobileNumber ?? ""}", context),
            _buildInfoTile("Date of Birth", widget.userData?.dob != null ? DateFormat('MMM dd, yyyy').format(widget.userData!.dob!) : "N/A", context),
            _buildInfoTile("Gender", widget.userData?.gender ?? "", context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, BuildContext context, {bool isEditable = true}) {
    return Column(
      children: [
        ListTile(
          title: TextView(
            text: title,
            style: 18.txtBoldWhite,
          ),
          subtitle: TextView(
            text: value,
            style: 15.txtRegularWhite,
          ),
          trailing: isEditable
              ? GestureDetector(
            onTap: () {
              _showEditBottomSheet(context, title, value);
            },
            child: TextView(
              text: "Edit",
              style: 16.txtMediumWhite,
              underline: true,
              underlineColor: AppColors.white,
            ),
          )
              : null,
        ),
        const Divider(),
      ],
    );
  }

  void _showEditBottomSheet(BuildContext context, String title, String currentValue) {
    final textController = TextEditingController(text: currentValue);

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(
                    text: "Edit $title",
                    style: 20.txtBoldBlack,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Row(
                children: [
                  TextView(
                    text: title,
                    style: 14.txtRegularBlack,
                  ),
                ],
              ),
              EditText(
                controller: textController,
                hint: title,
                hintStyle: 14.txtRegularBlack,
                margin: 20.bottom + 10.top,
              ),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  radius: 10.sdp,
                  label: "Save & Continue",
                  onTap: () async {
                    String newValue = textController.text.trim();
                    if (newValue.isNotEmpty) {
                      switch (title.toLowerCase()) {
                        case "name":
                          await controller.updateProfile(name: newValue);
                          break;
                        case "email":
                          await controller.updateProfile(email: newValue);
                          break;
                        case "phone number":
                        // Optional: Split country code and number if needed
                          await controller.updateProfile(mobileNumber: newValue);
                          break;
                        case "gender":
                          await controller.updateProfile(gender: newValue);
                          break;
                        case "date of birth":
                          await controller.updateProfile(dob: newValue);
                          break;
                      // Add more fields if needed
                      }
                      Navigator.pop(context);
                      setState(() {}); // refresh UI
                    }
                  },
                  labelStyle: 16.txtBoldWhite,
                  buttonColor: AppColors.btnColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}

