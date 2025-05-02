import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:question_app/components/styles/textStyles.dart';
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

class PersonalInfoScreen extends StatelessWidget {
   PersonalInfoScreen({super.key});


  @override
  Widget build(BuildContext context) {
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
            _imageWidget(),
            _buildInfoTile("Name", "John", context),
            _buildInfoTile("Email", "e**le@gmail.com", context),
            _buildInfoTile("Phone number", "+91 *****3210", context),
          _buildInfoTile("Date of Birth", "Feb 25, 2000", context),
          _buildInfoTile("Gender", "Male", context),
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
            style:  15.txtRegularWhite,
          ),
          trailing: isEditable
              ? GestureDetector(
            onTap: () {
              _showEditBottomSheet(context, title, value);
            },
            child:  TextView(
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
    TextEditingController controller = TextEditingController(text: currentValue);

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
                  TextView(text: AppStrings.name,
                  style: 14.txtRegularBlack,
                  ),
                ],
              ),
              EditText(
                controller: controller,
                hint: title ,
               hintStyle: 14.txtRegularBlack,
                margin: 20.bottom + 10.top,
              ),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  radius: 10.sdp,
                  label: "Save & Continue",
                  onTap: () {
                    Navigator.pop(context);
                  },
                  labelStyle: 16.txtBoldWhite,
                  buttonColor: AppColors.btnColor,
                )
              ),
            ],
          ),
        );
      },
    );
  }

   Widget _imageWidget() {
     return Column(
       children: [
         Center(
           child: ImageView(
             url: AppImages.dummyImg,
             size: 107,
             margin: 20.bottom,
           ),
         ),
         TextView(
           margin: 10.top + 10.bottom,
           text: "John",
           style: 24.txtBoldWhite,
         )
       ],
     );
   }
}
