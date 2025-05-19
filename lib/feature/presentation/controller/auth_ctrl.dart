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
      Preferences.savePrefOnLogin = data;
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      AppUtils.log("error>>>>$error");
      throw '';
    }
  }



  Future<ResponseData<LoginModel>> guestLogin({
    String? name,
    String? email,
    String? mobileNumber,
  }) async {
    final response = await _repo.guestLogin(
      name: name,
      email: email,
      mobileNumber: mobileNumber,
    );

    if (response.isSuccess) {
      final data = response.data;
      AppUtils.log("register successful: $data");
      Preferences.savePrefOnLogin = data;
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
      // final error = response.getError;
      // AppUtils.toastError(error);
      return response;
    }
  }


  Future<ResponseData> contactUs(String title, String message) async {
    final response = await _repo.contactUs(
        title: title,
        message: message,
    );

    if (response.isSuccess) {
      AppUtils.log("contact us successful: ${response.data}");
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      return response;
    }
  }

  Future<ResponseData> forgotPassword(String email) async {
    final response = await _repo.forgotPassword(
      email: email,
    );

    if (response.isSuccess) {
      AppUtils.log("forgot Pass Success: ${response.data}");
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      return response;
    }
  }



  Future<ResponseData> submitQuestion(String question, String answer) async {
    final response = await _repo.submitQuestions(
      question: question,
      answer: answer,
    );

    if (response.isSuccess) {
      AppUtils.log("submit question successful: ${response.data}");
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      return response;
    }
  }




  Future<ResponseData> submitQuestionsGuestUser(String guestUserId) async {
    final response = await _repo.submitQuestionsGuestUser(guestUserId: guestUserId);
    if (response.isSuccess) {
      AppUtils.toast("Answer Submit Successfully");
      AppUtils.log("guest submit question successful: ${response.data}");
      return response;
    } else {
      final error = response.getError;
      AppUtils.toastError(error);
      return response;
    }
  }
}




