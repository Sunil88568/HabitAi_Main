import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../../components/coreComponents/AppButton.dart';
import '../../../../../components/coreComponents/EditText.dart';
import '../../../../../components/coreComponents/TextView.dart';
import '../../../../../components/coreComponents/appBar2.dart';
import '../../../../../components/styles/appColors.dart';
import '../../../../../components/styles/appImages.dart';
import '../../../../../components/styles/app_strings.dart';
import '../../../../../services/storage/preferences.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  // final ProfileCtrl profileCtrl = Get.find<ProfileCtrl>();


  bool isLoading = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //
  // Future<void> _submitForm() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   setState(() => isLoading = true);
  //   AppUtils.log("<><><><><><><><>><><${profileCtrl.profileData.value.email}>");
  //
  //   try {
  //      SettingsCtrl.find.contactuss(
  //        profileCtrl.profileData.value.email ?? "",
  //       titleController.text.trim(),
  //       messageController.text.trim(),
  //     ).applyLoader.then((value){
  //       AppUtils.log(Preferences.email);
  //       context.pop();
  //      } );
  //
  //
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text("Contact Us"),
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
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              children: [
                20.height,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(text: 'Title', style: 14.txtMediumWhite),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: EditText(
                              hint: 'Enter Your Title here',
                              hintStyle: 16.txtfieldgrey,
                              inputType: TextInputType.name,
                              controller: titleController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                            ),
                          ),
                          15.height,
                          TextView(text: 'Message',style: 14.txtMediumWhite),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              controller: messageController, // Bind controller
                              decoration: InputDecoration(
                                hintText: "Your Message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintStyle: 16.txtfieldgrey,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(10),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a message';
                                } else if (value.length < 2) {
                                  return 'Message must be at least 5 characters long';
                                }
                                return null;
                              },
                            ),
                          ),
                          20.height,
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : AppButton(
                            margin: 100.top ,
                            radius: 10.sdp,
                            label: 'Submit',
                            labelStyle: 18.txtBoldBlack,
                            buttonColor: AppColors.white,
                            // onTap: _submitForm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
