import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_app/feature/data/models/dataModels/checkout_response.dart';
import 'package:question_app/services/firebase/firebaseServices.dart';

import '../../../services/networking/urls.dart';
import '../../../services/storage/preferences.dart';
import '../../../utils/appUtils.dart';
import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/notification_model.dart';
import '../../data/models/dataModels/responseDataModel.dart';
import '../../data/models/repository/iAuthRepository.dart';
import '../../domain/repository/authRepository.dart';


class AuthCtrl extends GetxController{
  static AuthCtrl get find  => Get.put(AuthCtrl(), permanent: true);
  final AuthRepository _repo = IAuthRepository();


  CheckoutResponse checkoutResponse = CheckoutResponse();
  NotificationModel notificationModel = NotificationModel();
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
    final deviceType = Platform.isAndroid ? "android" : "ios";

    final response = await _repo.loginUser(
      email: email,
      password: password,
      device_type: deviceType,
      device_token: FirebaseServices.fcmToken ??"",
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



  Future<ResponseData> submitQuestion(String questionId,String question, String answer) async {
    final response = await _repo.submitQuestions(
      questionId: questionId,
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




  Future<CheckoutResponse> checkout(String id,String country) async {
    final response = await _repo.checkout(id,country);

    checkoutResponse = CheckoutResponse.fromJson(response);
    if (checkoutResponse.statusCode == 200) {
      AppUtils.log("checkout question successful: ${checkoutResponse.data}");
      return checkoutResponse;
    } else {
      final error = checkoutResponse.message;
      AppUtils.toastError(error);
      return checkoutResponse;
    }
  }

  Future<NotificationModel> getNotifications(String id) async {
    final response = await _repo.getNotifications(id);

    notificationModel = NotificationModel.fromJson(response);
    if (notificationModel.statusCode == 200 || notificationModel.statusCode == 201) {
      AppUtils.log("checkout question successful: ${checkoutResponse.data}");
      return notificationModel;
    } else {
      final error = notificationModel.message;
      AppUtils.toastError(error);
      return notificationModel;
    }
  }



  Future<ResponseData> submitQuestionsGuestUser(String guestUserId,String questionId,String question, String answer) async {
    final response = await _repo.submitQuestionsGuestUser(guestUserId: guestUserId,questionId: questionId,
      question: question,
      answer: answer,);
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

  String timeAgo(String dateStr) {
    final date = DateTime.parse(dateStr).toUtc();
    final now = DateTime.now().toUtc();
    final diff = now.difference(date);

    if (diff.inDays >= 365) {
      final years = diff.inDays ~/ 365;
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 30) {
      final months = diff.inDays ~/ 30;
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return '${diff.inSeconds} second${diff.inSeconds > 1 ? 's' : ''} ago';
    }
  }
}




