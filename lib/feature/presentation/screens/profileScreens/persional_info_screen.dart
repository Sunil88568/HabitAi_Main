import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:question_app/components/styles/textStyles.dart';
import 'package:question_app/feature/data/models/dataModels/login_model/login_model.dart';
import 'package:question_app/utils/appUtils.dart';
import 'package:question_app/utils/extensions/context_extensions.dart';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:question_app/utils/extensions/size.dart';
import 'package:question_app/utils/extensions/widget.dart';
import '../../../../../components/constants.dart';
import '../../../../../components/coreComponents/AppButton.dart';
import '../../../../../components/styles/appColors.dart';
import '../../../../components/coreComponents/EditText.dart';
import '../../../../components/coreComponents/ImageView.dart';
import '../../../../components/coreComponents/TextView.dart';
import '../../../../components/coreComponents/appBSheet.dart';
import '../../../../components/coreComponents/editProfileImage.dart';
import '../../../../components/styles/appImages.dart';
import '../../../../components/styles/app_strings.dart';
import '../../../data/models/imageDataModel.dart';
import '../../controller/profile_Info_controller.dart';
import '../../controller/profile_user_controller.dart';

class PersonalInfoScreen extends StatefulWidget {
  final LoginModel? userData;
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


  @override
  void initState() {
    super.initState();
    controller.setUser(widget.userData);
    if (widget.userData?.image != null) {
      imageData.value = ImageDataModel(network: widget.userData!.image.fileUrl);
      imageData.refresh();
    }
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
            _buildInfoTile("Date of Birth", widget.userData?.dob != null ? DateFormat('MMM dd, yyyy').format(widget.userData!.dob!) : "N/A", context),
            _buildInfoTile("Gender", widget.userData?.gender ?? "", context),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    final phoneNumber = "${controller.userData.value?.countryCode ?? '+1'} ${controller.userData.value?.mobileNumber ?? ''}";
    return _buildInfoTile("Phone Number", phoneNumber, context, isEditable: true);
  }


  void _showPhoneEditBottomSheet(BuildContext context) {
    final phoneController = TextEditingController(text: controller.userData.value?.mobileNumber ?? '');
    String selectedCode = controller.userData.value?.countryCode ?? '+1';

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
                          selectedCode = '+${country.phoneCode}';
                          Navigator.pop(context);
                          _showPhoneEditBottomSheet(context); // re-open with updated code
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          TextView(text: selectedCode, style: 14.txtRegularBlack),
                          Icon(Icons.arrow_drop_down, color: AppColors.grey),
                        ],
                      ),
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: EditText(
                      controller: phoneController,
                      inputFormat: [LengthLimitingTextInputFormatter(10)],
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
                    String newPhone = phoneController.text.trim();
                    if (newPhone.isNotEmpty) {
                      await controller.updateProfile(
                        mobileNumber: newPhone,
                        countryCode: selectedCode,
                      ).applyLoader;
                      Get.put(ProfileUserController());
                      context.pop(); // close sheet
                      setState(() {});
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
                          await controller.updateProfile(name: newValue).applyLoader;
                          break;
                        case "email":
                          await controller.updateProfile(email: newValue).applyLoader;
                          break;
                        case "phone number":
                          _showPhoneEditBottomSheet(context);
                          return;

                        case "gender":
                          await controller.updateProfile(gender: newValue).applyLoader;
                          break;
                        case "date of birth":
                          await controller.updateProfile(dob: newValue).applyLoader;
                          break;
                      }

                      await Get.put(ProfileUserController());

                      context.pop();
                      setState(() {});
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
