import 'dart:async';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/presentation/screens/loginScreen/signup_success.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/dateTimeUtils.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';

import '../../../../components/appLoader.dart';
import '../../../../components/coreComponents/AppButton.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/coreComponents/appBSheet.dart';
import '../../../../components/coreComponents/appBar2.dart';
import '../../../../components/coreComponents/appDropDown.dart';
import '../../../../components/coreComponents/common_password_input_field.dart';
import '../../../../components/coreComponents/editProfileImage.dart';
import '../../../../components/styles/appColors.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../../services/firebase/firebaseServices.dart';
import '../../../../services/storage/preferences.dart';
import '../../../../utils/appUtils.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../data/models/imageDataModel.dart';
import '../../../data/models/repository/iAuthRepository.dart';
import '../../../domain/repository/authRepository.dart';
import '../../controller/auth_ctrl.dart';
import '../homeScreen/home_screen.dart';

class AddprofileScreen extends StatefulWidget {
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? password;

  AddprofileScreen({
    super.key,
    this.name,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
  });

  @override
  State<AddprofileScreen> createState() => _addProfileState();
}

class _addProfileState extends State<AddprofileScreen> {
  Rx<ImageDataModel> imageData = Rx(ImageDataModel());

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
        title: Text(AppStrings.signUp),
        titleTextStyle: 24.txtBoldWhite,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Obx(
                        () => EditProfileImage(
                          isEditable: true,
                          size: 120.sdp,
                          imageData: imageData.value,
                          onChange: (newImage) {
                            if (newImage.file != null) {
                              imageData.value = newImage;
                              imageData.refresh();
                              AppUtils.log("Image selected: ${newImage.file}");
                            }
                          },
                        ),
                      ),

                      GestureDetector(
                        onTap: () => _showImagePicker(context),
                        child: TextView(
                          text: AppStrings.uploadPhoto,
                          style: 14.txtMediumWhite,
                          margin: 10.top + 20.bottom,
                        ),
                      ),
                    ],
                  ),
                ),
                EmailLoginForm(
                  name: widget.name,
                  email: widget.email,
                  countryCode: widget.countryCode,
                  phoneNumber: widget.phoneNumber,
                  password: widget.password,
                  imageData: imageData.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    appBSheet(
      context,
      EditImageBSheetView(
        onItemTap: (source) async {
          Navigator.pop(context);
          final path = await _pickImage(source.imageSource);
          if (path != null) {
            imageData.value.file = path;
            imageData.value.type = ImageType.file;
            imageData.refresh();
          }
        },
      ),
    );
  }

  Future<String?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      imageData.value.file = image.path;
      imageData.value.type = ImageType.file;
      imageData.refresh();

      AppUtils.log("Picked Image Path: ${image.path}");

      // signupController.updateImage(image.path);
      return image.path;
    }
    return null;
  }
}

class EmailLoginForm extends StatefulWidget {
  final String? name;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final String? password;
  final ImageDataModel imageData;

  const EmailLoginForm({
    super.key,
    this.name,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.password,
    required this.imageData,
  });

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String uploadedImageUrl = "";
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  Rx<Country?> countryData = Rx(null);
  RxString dateOfBirth = RxString('');
  String gender = "";
  bool isCheckedTerms = false;
  bool isCheckedPrivacy = false;
  final AuthRepository authRepository = IAuthRepository();

  @override
  void initState() {
    super.initState();
    genderController.addListener(_updateButtonState);
    dobController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1), () {
      setState(() {});
    });
  }

  bool get _isFormValid =>
      genderController.text.isNotEmpty &&
          dobController.text.isNotEmpty &&
          _formKey.currentState!.validate() ??
      false;

  @override
  void dispose() {
    genderController.dispose();
    dobController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _submitForm() async {
    final deviceType = Platform.isAndroid ? "android" : "ios";

    if (!_formKey.currentState!.validate()) return;

    if (widget.imageData.file != null) {
      final File imageFile = File(widget.imageData.file!);
      final response =
          await authRepository.uploadPhoto(imageFile: imageFile).applyLoader;
      AppUtils.log("Response: ${response.data}");
      if (response.isSuccess) {
        setState(() {
          uploadedImageUrl = response.data ?? "";
        });
        AppUtils.log("Image uploaded: $uploadedImageUrl");
      } else {
        AppUtils.toastError(
          "Image upload failed: ${response.error ?? "Unknown error"}",
        );
        AppUtils.log(
          "Image upload failed: ${response.error ?? "Unknown error"}",
        );
        return;
      }
    }

    await AuthCtrl.find
        .register(
          email: widget.email ?? "",
          password: widget.password ?? "",
          name: widget.name ?? "",
          countryCode: widget.countryCode ?? "",
          mobileNumber: widget.phoneNumber ?? "",
          gender: genderController.text??"",
          dob: dobController.text??"",
          image: uploadedImageUrl,
          device_type: deviceType,
          device_token: FirebaseServices.fcmToken ??"",
        )
        .applyLoader
        .then((value) {
          context.pushAndClearNavigator(SignupSuccess());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: 20.left + 20.right,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      40.height,

                      TextView(
                        text: AppStrings.gender,
                        style: 14.txtRegularWhite,
                      ),
                      8.height,
                      _buildGenderDropdown(),
                      TextView(
                        text: AppStrings.dateOfBirth,
                        style: 14.txtRegularWhite,
                      ),
                      8.height,
                      _buildDateOfBirthField(),
                      10.height,
                      GestureDetector(
                        onTap: () {
                          // context.pushNavigator(TermsWebViewScreen());
                        },
                        child: _buildCheckbox(
                          AppStrings.acceptTermAndConditions,
                          isChecked: isCheckedTerms,
                          onChanged: (value) {
                            setState(() => isCheckedTerms = value!);
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // context.pushNavigator(Privacywebviewscreen());
                        },
                        child: _buildCheckbox(
                          AppStrings.iAgreePrivacyPolicy.tr,
                          isChecked: isCheckedPrivacy,
                          onChanged: (value) {
                            setState(() => isCheckedPrivacy = value!);
                          },
                        ),
                      ),

                      AppButton(
                        margin: 30.top,
                        radius: 10,
                        width: double.infinity,
                        label: AppStrings.Continue,
                     //   labelStyle: _isFormValid ? 17.txtBoldWhite : 17.txtBoldGrey,
                        labelStyle:  17.txtBoldWhite ,
                     //   onTap: _isFormValid ? _submitForm : null,
                        onTap: _submitForm ,
                     //   buttonColor: _isFormValid ? AppColors.btnColor : AppColors.greyHint.withOpacity(0.3),
                        buttonColor: AppColors.btnColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            30.height,
          ],
        ),
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditText(
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ImageView(url: AppImages.calanderimg, size: 20.sdp),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ImageView(
              url: AppImages.birthcake,
              size: 18,
              margin: 15.right + 12.left,
            ),
          ),
          hint: AppStrings.dateOfBirth,
          controller: dobController,
          readOnly: true,
          onTap: _selectDateOfBirth,
          /*validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.pleaseEnterYourDate;
            }
            return null;
          },*/
          margin: 10.bottom,
        ),
      ],
    );
  }

  void _selectDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formatted = pickedDate.ddcMMcyyyy;
      setState(() {
        dobController.text = formatted;
        dateOfBirth.value = formatted;
      });
    }
  }

  Widget _buildGenderDropdown() {
    return AppDropDown.singleSelect(
      list: ["Male", "Female", "Other"],
      selectedValue: gender,
      hint: AppStrings.selectGender,
      onSingleChange: (selectedValue) {
        setState(() {
          gender = selectedValue;
          genderController.text = selectedValue;
        });
      },
      singleValueBuilder: (value) => value,
      itemBuilder: (value) => value,
      isFilled: true,
      borderColor: AppColors.grey.withOpacity(0.3),
      radius: 10,
      error: "",
      prefixIcon: ImageView(url: AppImages.gender, size: 20, margin: 10.right),
    );
  }

  Widget _buildCheckbox(
    String label, {
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            child: Checkbox(
              splashRadius: 5,
              value: isChecked,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: AppColors.black, width: 1.5),
              checkColor: AppColors.white,
              activeColor: AppColors.btnColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text:
                    label.contains("Terms")
                        ? "${AppStrings.iAccept} "
                        : "${AppStrings.iAgree} ",

                style: 14.txtRegularBlack,
                children: [
                  TextSpan(
                    text:
                        label.contains("Terms")
                            ? AppStrings.termsandCondation.tr
                            : AppStrings.privacyPolicy.tr,
                    style: 14.txtRegularbtncolor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
