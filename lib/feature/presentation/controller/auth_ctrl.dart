import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/networking/urls.dart';
import '../../../services/storage/preferences.dart';
import '../../../utils/appUtils.dart';
import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/responseDataModel.dart';
import '../../data/models/repository/iAuthRepository.dart';
import '../../domain/repository/authRepository.dart';


class AuthCtrl extends GetxController{
  static AuthCtrl get find  => Get.put(AuthCtrl(), permanent: true);
  final AuthRepository _repo = IAuthRepository();


  var searchedUsers = <Map<String, dynamic>>[].obs;


  RxBool isLoading = false.obs;


  Future<ResponseData<LoginModel>> register({
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
    String? device_type,
    String? device_token,
  }) async {
    final response = await _repo.register(
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
      device_type: device_type,
      device_token: device_token,
    );

    if (response.isSuccess) {
      final data = response.data;
      AppUtils.log("register successful: $data");
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      AppUtils.log("error>>>>$error");
      throw '';
    }
  }


  Future login(String email, String password) async {
    final response = await _repo.loginUser(
      email: email,
      password: password,
    );

    if (response.isSuccess) {
      final data = response.data;
      AppUtils.log("Login successful: $data");
      Preferences.savePrefOnLogin = data;

      return;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      AppUtils.log("error>>>>$error");
      throw '';
    }
  }

  Future<ResponseData> checkEmailAndMobile(String email, String mobileNumber) async {
    final response = await _repo.checkEmailAndMobile(
      email: email,
      mobileNumber: mobileNumber,
    );

    if (response.isSuccess) {
      AppUtils.log("Verify successful: ${response.data}");
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      return response;
    }
  }

  Future<String?> VerifyOtp(String action, String mobile, int otp, String hash) async {
    final response = await _repo.VerifyOtp(
      action: action,
      mobile: mobile,
      hash: hash,
      otp: otp,
    );

    if (response.isSuccess) {
      final data = response.data;
      AppUtils.log("Otp send:  $data");


      final responseHash = data;

      if (responseHash != null) {
        AppUtils.log("Hash::::::::: $responseHash");
      } else {
        AppUtils.log("Hash not found in response");
      }

      return data?.name;
    } else {
      final error = response.getError;
      if (error != null) {
        AppUtils.toastError(error is Exception ? error : Exception('Unknown error'));
      } else {
        AppUtils.toastError(response.getError!);
      }
      throw '';
    }
  }






  Future<String> changePassword(int userId, String type, String newPassword, String mobile, String hash) async {
    final response = await _repo.changePassword(
      action: type,
      userID: userId,
      password: newPassword,
      mobile: mobile,
      hash: hash,
    );

    if (response.isSuccess) {
      final data = response.data;
      AppUtils.log("password successful: $data");
      // final hash = data?.hash;
      AppUtils.log("Hash: $hash");
      return hash ?? '';
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      if (error != null) {
        AppUtils.toastError(error is Exception ? error : Exception('Unknown error'));
      } else {
        AppUtils.toastError(response.getError!);
      }
      throw Exception('Verification failed');
    }
  }




  Future<LoginModel?> profileChangePassword(String existingPassword, String newPassword) async {
    final response = await _repo.profileChangePassword(
      existingPassword: existingPassword,
      newPassword: newPassword
    );

    if (response.isSuccess) {
      final data = response.data;
      // final hash = data?.hash;
      return data ;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      AppUtils.log("Password change failed: $error");
      if (error != null) {
        AppUtils.toastError(error is Exception ? error : Exception(error.toString()));
      } else {
        AppUtils.toastError(Exception('Unknown error'));
      }
      throw Exception(error?.toString() ?? 'Verification failed');
    }

  }





}




