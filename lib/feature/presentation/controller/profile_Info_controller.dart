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
      AppUtils.log("Calling editProfile API...");
      final response = await _authRepository.editProfile(
        name: name,
        password: password,
        email: email,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber,
        dob: dob,
        countryCode: countryCode,
        education: education,
        image: image,
        device_type: deviceType,
        device_token: deviceToken,
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
