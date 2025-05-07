import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:question_app/components/styles/appImages.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/data/models/dataModels/login_model/login_model.dart';
import 'package:question_app/feature/presentation/screens/homeScreen/home_screen.dart';
import 'package:question_app/utils/appUtils.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../../components/coreComponents/AppButton.dart';
import '../../../../../components/styles/appColors.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/coreComponents/appBSheet.dart';
import '../../../../components/coreComponents/appDropDown.dart';
import '../../../../components/coreComponents/editProfileImage.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../data/models/imageDataModel.dart';
import '../../../data/models/repository/iAuthRepository.dart';
import '../../../domain/repository/authRepository.dart';
import '../../controller/profile_Info_controller.dart';
import '../../controller/profile_user_controller.dart';

class PersonalInfoScreen extends StatefulWidget {
  LoginModel? userData;
  PersonalInfoScreen({super.key, this.userData});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {

  final PersonalInfoController controller = Get.put(PersonalInfoController());
  Rx<ImageDataModel> imageData = Rx(ImageDataModel());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final Rx<Country?> countryData = Rx<Country?>(null);
  DateTime? _selectedDob;
  String? gender;
  final AuthRepository authRepository = IAuthRepository();


  @override
  void initState() {
    super.initState();
    controller.setUser(widget.userData);
    if (widget.userData?.image != null) {
      imageData.value = ImageDataModel(
        type: ImageType.network,
        network: widget.userData!.image.fileUrl,
      );

      imageData.refresh();
      AppUtils.logEr(">>>>>>>>>${imageData.value}");
      AppUtils.logEr("image>>>>>>>>>${widget.userData!.image.fileUrl}");
    }
    _selectedDob = widget.userData?.dob;
    gender = widget.userData?.gender;
  }

  @override
  void dispose() {
    phoneController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }


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
            Obx(() => EditProfileImage(
              isEditable: true,
              size: 120.sdp,
              imageData: imageData.value,
              onChange: (newImage) async {
                if (newImage.file != null) {
                  imageData.value = newImage;
                  imageData.refresh();
                  AppUtils.log("Image selected: ${newImage.file}");
                  await controller.updateProfile(image: newImage.file).applyLoader;
                  // context.pushAndClearNavigator(HomeScreen());
                }
              },
            )),

            GestureDetector(
              onTap: () => _showImagePicker(context),
              child: TextView(
                text: AppStrings.uploadPhoto,
                style: 16.txtMediumWhite,
                margin: 10.top + 20.bottom,
              ),
            ),
            _buildInfoTile("Name", widget.userData?.name ?? "", context),
            _buildInfoTile("Email", widget.userData?.email ?? "", context),
            _buildPhoneField(),
            _buildInfoTile(
              "Date of Birth",
              widget.userData?.dob != null
                  ? DateFormat('MMM dd, yyyy').format(widget.userData!.dob!)
                  : "N/A",
              context,
              onEditTap: () {
                _showDobBottomSheet(context);
              },
            ),
            _buildInfoTile(
              "Gender",
              widget.userData?.gender ?? "",
              context,
              onEditTap: () => _showGenderEditBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPhoneField() {
    final phoneNumber =
        "${controller.userData.value?.countryCode ?? '+1'} ${controller.userData.value?.mobileNumber ?? ''}";
    return _buildInfoTile(
      "Phone Number",
      phoneNumber,
      context,
      isEditable: true,
      onEditTap: () => _showPhoneEditBottomSheet(context),
    );
  }




  Widget _buildInfoTile(
      String title,
      String value,
      BuildContext context, {
        bool isEditable = true,
        VoidCallback? onEditTap,
      }) {
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
            onTap: onEditTap ??
                    () {
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
                      final userData = controller.userData.value;
                      String? currentValue;

                      switch (title.toLowerCase()) {
                        case "name":
                          currentValue = userData?.name ?? "";
                          if (newValue != currentValue) {
                            await controller.updateProfile(name: newValue).applyLoader;
                            await authRepository.getUserProfile();
                          } else {
                            AppUtils.log("No change in name, skipping API call");
                          }
                          break;
                        case "email":
                          currentValue = userData?.email ?? "";
                          if (newValue != currentValue) {
                            await controller.updateProfile(email: newValue).applyLoader;
                            await authRepository.getUserProfile();
                          } else {
                            AppUtils.log("No change in email, skipping API call");
                          }
                          break;
                        case "phone number":
                          _showPhoneEditBottomSheet(context);
                          return;
                        case "gender":
                          currentValue = userData?.gender ?? "";
                          if (newValue != currentValue) {
                            await controller.updateProfile(gender: newValue).applyLoader;
                            await authRepository.getUserProfile();
                          } else {
                            AppUtils.log("No change in gender, skipping API call");
                          }
                          break;
                        case "date of birth":
                          currentValue = (userData?.dob is String) ? userData?.dob as String : "";
                          if (newValue != currentValue) {
                            await controller.updateProfile(dob: newValue).applyLoader;
                            await authRepository.getUserProfile();
                          } else {
                            AppUtils.log("No change in dob, skipping API call");
                          }
                          break;
                      }
                      context.pushAndClearNavigator(HomeScreen());
                     // context.pop();
                      await authRepository.getUserProfile();
                      if (mounted) {
                        setState(() {
                           authRepository.getUserProfile();
                        });
                      }
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

  void _showImagePicker(BuildContext context) {
    appBSheet(
      context,
      EditImageBSheetView(
        onItemTap: (source) async {
          Navigator.pop(context);
          final path = await _pickImage(source.imageSource);
          if (path != null) {
            _showPreviewDialog(context, path);
          }
        },
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, String filePath) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: EdgeInsets.only(top: 16, left: 16, right: 16),
        title: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: TextView(
                text: "Upload Photo",
                style: 20.txtBoldBlack,
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, color: Colors.black),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.file(
                File(filePath),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            20.height,
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AppButton(
                  radius: 25.sdp,
                  label: "Cancel",
                  labelStyle: 14.txtRegularBlack,
                  buttonColor: AppColors.white,
                  buttonBorderColor: AppColors.grey,
                  onTap: () => Navigator.of(context).pop(),
                  isFilledButton: false,
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: AppButton(
                  radius: 25.sdp,
                  label: "Upload",
                  labelStyle: 14.txtBoldWhite,
                  buttonColor: AppColors.btnColor,
                  onTap: () async {
                    Navigator.of(context).pop();

                    AppUtils.log("Uploading image...");

                    if (imageData.value.file != null) {
                      final File imageFile = File(imageData.value.file!);


                      final response = await authRepository.uploadPhoto(imageFile: imageFile).applyLoader;
                      AppUtils.log("Upload Photo Response: ${response.data}");

                      if (response.isSuccess) {

                        final uploadedImageUrl = response.data ?? "";

                        await controller.updateProfile(image: uploadedImageUrl).applyLoader;

                        AppUtils.log("Profile updated with image: $uploadedImageUrl");

                        imageData.value.file = uploadedImageUrl;
                        imageData.value.type = ImageType.network;
                        imageData.refresh();
                        context.pushAndClearNavigator(HomeScreen());
                        // context.pop();
                      } else {
                        AppUtils.toastError("Image upload failed: ${response.error ?? "Unknown error"}");
                        AppUtils.log("Image upload failed: ${response.error ?? "Unknown error"}");
                      }
                    } else {
                      AppUtils.toastError("No image selected to upload");
                    }
                  },

                  isFilledButton: false,
                ),
              ),
            ],
          ),
        ],
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


  void _showPhoneEditBottomSheet(BuildContext context) {
    final phoneController = TextEditingController(
      text: controller.userData.value?.mobileNumber ?? '',
    );

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Obx(() {
          final currentCode = controller.userData.value?.countryCode ?? '+1';

          return Padding(
            padding: EdgeInsets.only(
              left: 10,
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
                    TextView(text: "Edit Phone Number", style: 20.txtBoldBlack),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextView(text: "Phone Number", style: 14.txtRegularBlack),
                  ],
                ),
                10.height,
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            final newCode = '+${country.phoneCode}';
                            final newFlag = country.flagEmoji;
                            controller.userData.value = controller.userData.value?.copyWith(
                              countryCode: '$newFlag $newCode',
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            TextView(text: currentCode, style: 14.txtRegularBlack),
                            const Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.grey),
                          ],
                        ),
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: EditText(
                        controller: phoneController,
                        inputFormat: [LengthLimitingTextInputFormatter(10)],
                        inputType: TextInputType.phone,
                        hint: "Phone Number",
                        hintStyle: 14.txtRegularBlack,
                      ),
                    ),
                  ],
                ),
                20.height,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    radius: 10.sdp,
                    label: "Save & Continue",
                    onTap: () async {
                      String newPhoneNumber = phoneController.text.trim();
                      String newCountryCode = controller.userData.value?.countryCode ?? '+1';

                      if (newPhoneNumber.isNotEmpty) {
                        await controller.updateProfile(
                          mobileNumber: newPhoneNumber,
                          countryCode: newCountryCode,
                        ).applyLoader;

                        controller.userData.value = controller.userData.value?.copyWith(
                          mobileNumber: newPhoneNumber,
                          countryCode: newCountryCode,
                        );
                        context.pushAndClearNavigator(HomeScreen());
                        // Navigator.pop(context);
                      } else {
                        AppUtils.logEr("Please enter a valid phone number");
                      }
                    },

                    labelStyle: 16.txtBoldWhite,
                    buttonColor: AppColors.btnColor,
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }



  void _showDobBottomSheet(BuildContext context) {
    DateTime? tempSelectedDob = _selectedDob;
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        text: "Edit Date of Birth",
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
                        text: "Date of Birth",
                        style: 14.txtRegularBlack,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempSelectedDob ?? DateTime(1990, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() {
                          tempSelectedDob = picked;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextView(
                            text: tempSelectedDob != null
                                ? DateFormat('yyyy-MM-dd').format(tempSelectedDob!)
                                : 'Select date of birth',
                            style: 16.txtRegularBlack,
                          ),
                          ImageView(
                            url: AppImages.calanderimg,
                            tintColor: AppColors.grey,
                            size: 25.sdp,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      radius: 10.sdp,
                      label: "Save & Continue",
                      onTap: () async {
                        if (tempSelectedDob != null) {
                          String dobString = DateFormat('yyyy-MM-dd').format(tempSelectedDob!);
                          await controller.updateProfile(dob: dobString).applyLoader;
                          setState(() {
                            _selectedDob = tempSelectedDob;
                          });
                          context.pushAndClearNavigator(HomeScreen());
                          // Navigator.pop(context);
                        } else {
                          AppUtils.logEr("Please select a date of birth");
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
      },
    );
  }


  void _showGenderEditBottomSheet(BuildContext context) {
    String? tempSelectedGender = gender;
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView(
                        text: "Edit Gender",
                        style: 20.txtBoldBlack,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  // Label
                  Row(
                    children: [
                      TextView(
                        text: "Gender",
                        style: 14.txtRegularBlack,
                      ),
                    ],
                  ),
                  10.height,
                  // Dropdown
                  AppDropDown.singleSelect(
                    list: ["Male", "Female", "Other"],
                    selectedValue: tempSelectedGender,
                    hint: AppStrings.selectGender,
                    onSingleChange: (selectedValue) {
                      setModalState(() {
                        tempSelectedGender = selectedValue;
                      });
                    },
                    singleValueBuilder: (value) => value,
                    itemBuilder: (value) => value,
                    isFilled: true,
                    borderColor: AppColors.grey.withOpacity(0.3),
                    radius: 10,
                    error: "",
                    prefixIcon: ImageView(
                      url: AppImages.gender,
                      size: 20,
                      margin: 10.right,
                    ),
                  ),
                  20.height,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      radius: 10.sdp,
                      label: "Save & Continue",
                      onTap: () async {
                        if (tempSelectedGender != null && tempSelectedGender!.isNotEmpty) {
                          await controller.updateProfile(gender: tempSelectedGender).applyLoader;
                          setState(() {
                            gender = tempSelectedGender!;
                            widget.userData = widget.userData?.copyWith(gender: gender);
                          });
                          context.pushAndClearNavigator(HomeScreen());
                          // Navigator.pop(context);
                        } else {
                          AppUtils.logEr("Please select a gender");
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
      },
    );
  }



}
