import 'package:get/get.dart';
import 'package:question_app/feature/data/models/dataModels/login_model/login_model.dart';
import 'package:question_app/feature/data/models/repository/iAuthRepository.dart';
import 'package:question_app/utils/appUtils.dart';

class PersonalInfoController extends GetxController {
  Rx<LoginModel?> userData = Rx<LoginModel?>(null);
  final IAuthRepository _authRepository = IAuthRepository();

  void setUser(LoginModel? data) {
    userData.value = data;
  }

  void updateName(String newName) {
    if (userData.value != null) {
      userData.value = userData.value!.copyWith(name: newName);
    }
  }

  void updatePhoneNumber(String newCountryCode, String newMobileNumber) {
    if (userData.value != null) {
      userData.value = userData.value!.copyWith(
        countryCode: newCountryCode,
        mobileNumber: newMobileNumber,
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? password,
    String? email,
    String? age,
    String? gender,
    String? mobileNumber,
    String? dob,
    String? countryCode,
    String? education,
    String? image,
    String? deviceType,
    String? deviceToken,
  }) async {
    try {
      final Map<String, dynamic> updatedFields = {};

      if (name != null && name.isNotEmpty) updatedFields['name'] = name;
      if (password != null && password.isNotEmpty) updatedFields['password'] = password;
      if (email != null && email.isNotEmpty) updatedFields['email'] = email;
      if (age != null && age.isNotEmpty) updatedFields['age'] = age;
      if (gender != null && gender.isNotEmpty) updatedFields['gender'] = gender;
      if (mobileNumber != null && mobileNumber.isNotEmpty) updatedFields['mobileNumber'] = mobileNumber;
      if (dob != null && dob.isNotEmpty) updatedFields['dob'] = dob;
      if (countryCode != null && countryCode.isNotEmpty) updatedFields['countryCode'] = countryCode;
      if (education != null && education.isNotEmpty) updatedFields['education'] = education;
      if (image != null && image.isNotEmpty) updatedFields['image'] = image;
      if (deviceType != null && deviceType.isNotEmpty) updatedFields['deviceType'] = deviceType;
      if (deviceToken != null && deviceToken.isNotEmpty) updatedFields['deviceToken'] = deviceToken;

      if (updatedFields.isEmpty) {
        AppUtils.toastError("No fields to update.");
        return;
      }

      AppUtils.log("Calling editProfile API with fields: $updatedFields");
      final response = await _authRepository.editProfile(
        name: updatedFields['name'],
        password: updatedFields['password'],
        email: updatedFields['email'],
        age: updatedFields['age'],
        gender: updatedFields['gender'],
        mobileNumber: updatedFields['mobileNumber'],
        dob: updatedFields['dob'],
        countryCode: updatedFields['countryCode'],
        education: updatedFields['education'],
        image: updatedFields['image'],
        device_type: updatedFields['device_type'],
        device_token: updatedFields['device_token'],
      );

      if (response.isSuccess && response.data != null) {
        userData.value = response.data!;
        AppUtils.toast("Profile updated successfully");
        AppUtils.log("Profile updated: ${userData.value}");
      } else {
        AppUtils.toastError(response.message ?? "Failed to update profile");
      }
    } catch (e) {
      AppUtils.log("Profile update error: $e");
      AppUtils.toastError("An error occurred while updating profile");
    }
  }


}
