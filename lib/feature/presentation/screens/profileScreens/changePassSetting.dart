import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/appBar2.dart';
import '../../../../components/coreComponents/common_password_input_field.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../../utils/appUtils.dart';
import '../../../data/models/repository/iAuthRepository.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool _isValid = RxBool(false);
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_updateButtonState);
    _newPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _currentPasswordController.getText.isNotEmpty &&
          _newPasswordController.getText.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!formKey.currentState!.validate()) {
      AppUtils.log("Form validation failed");
      return;
    }
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    try {
      AppUtils.log("Calling change password API...");
      final authService = IAuthRepository();
      final response = await authService
          .profileChangePassword(
           existingPassword: currentPassword, newPassword: newPassword
      ).applyLoader;

      if (response.isSuccess) {
        AppUtils.toast("Password Changed Successfully");
        context.pop();
      } else {
        AppUtils.toastError("Passwords do not match");
      }
    } catch (e) {
      AppUtils.log("Error: $e");
      AppUtils.toastError(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text("Change Password"),
          titleTextStyle: 24.txtBoldBlack,
          actions: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Icon(
                Icons.close,
                color: AppColors.black,
              ),
            ),
            16.width
          ],
        ),


        Expanded(
          child: SingleChildScrollView(
            padding: 20.left + 20.right,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonPasswordInputField(
                    leading: Padding(
                      padding: 16.all,
                      child: ImageView(url: AppImages.passimg, size: 16.sdp),
                    ),
                    marginBottom: 30,
                    controller: _currentPasswordController,
                    hint: "Current Password",
                    validator: (value) {
                      final trimmedValue = value?.trim() ?? '';
                      if (trimmedValue.isEmpty)
                        return AppStrings.pleaseEnterYourPassword;
                      if (trimmedValue.contains(' '))
                        return AppStrings.passwordMustNotContainSpace;
                      if (!trimmedValue.isPassword)
                        return AppStrings.passwordMustBeAtLeast;
                      return null;
                    },
                  ),
                  CommonPasswordInputField(
                    controller: _newPasswordController,
                    hint: AppStrings.newPassword,
                    leading: Padding(
                      padding: 16.all,
                      child: ImageView(url: AppImages.passimg, size: 16.sdp),
                    ),
                    validator: (value) {
                      final trimmedValue = value?.trim() ?? '';
                      final currentPassword = _currentPasswordController.text.trim();

                      if (trimmedValue.isEmpty)
                        return AppStrings.pleaseEnterYourPassword;
                      if (trimmedValue.contains(' '))
                        return AppStrings.passwordMustNotContainSpace;
                      if (!trimmedValue.isPassword)
                        return AppStrings.passwordMustBeAtLeast;
                      if (trimmedValue == currentPassword)
                        return "New password must be different from current password";
                      return null;
                    },

                  ),
                  AppButton(
                    radius: 10,
                    margin: 50.top,
                    label: "Save & Continue",
                    labelStyle: 18.txtMediumWhite,
                    buttonColor:
                    isButtonEnabled ? AppColors.btnColor : Colors.grey,
                    onTap:

                    isButtonEnabled ? _updatePassword : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
