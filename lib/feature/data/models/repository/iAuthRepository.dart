// import 'dart:developer' as AppUtils;


import 'dart:developer' as AppUtils;
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:question_app/utils/extensions/extensions.dart';

import '../../../../services/networking/apiMethods.dart';
import '../../../../services/networking/urls.dart';
import '../../../../services/storage/preferences.dart';
import '../../../domain/repository/authRepository.dart';
import '../dataModels/login_model/login_model.dart';
import '../dataModels/responseDataModel.dart';


class IAuthRepository implements AuthRepository {
  final IApiMethod _apiMethod = IApiMethod(baseUrl: Urls.api);



  @override
  Future<ResponseData<LoginModel>> register({
    String ?name,
    String ?password,
    String ?email,
    String ?age,
    String ?gender,
    String ?mobileNumber,
    String ?dob,
    String? countryCode,
    String? education,
    String? image,
    String? device_type,
    String? device_token,
  }) async {
    final body = {
      'name': name,
      'password': password,
      'email': email,
      'age': age,
      'gender': gender,
      'mobileNumber': mobileNumber,
      'dob': dob,
      'countryCode': countryCode,
      'education': education,
      'image': image,
      'device_type': device_type,
      'device_token': device_token,
    };

    AppUtils.log("register API URL: ${Urls.register}");
    final result = await _apiMethod.post(
      url: Urls.register,
      body: body,
      headers: {},
    );

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = rawData['data'] ?? {};
      final token = rawData['token'] ?? "";

      AppUtils.log("Token: $token");
      AppUtils.log("Parsed user data: $userData");

      final data = LoginModel.fromJson(userData);
      Preferences.authToken = token;
      Preferences.profile = data;

      return ResponseData<LoginModel>(
        statusCode: result.statusCode,
        message: result.message,
        data: data,
      );
    } else {
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
      );
    }
  }

  @override
  Future<ResponseData<LoginModel>> loginUser({
    required String email,
    required String password,
     String? device_token,
     String? device_type,
  }) async {
    final token = Preferences.profile?.deviceToken ;
    final deviceType = Preferences.profile?.deviceType ;
    final body = {
      'email': email,
      'password': password,
      'device_token': token,
      'device_type': deviceType,
    };

    AppUtils.log("Login API URL: ${Urls.login}");
    final result = await _apiMethod.post(
      url: Urls.login,
      body: body,
      headers: {},
    );

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = rawData['data'] ?? {};
      final token = rawData['token'] ?? "";

      AppUtils.log("Token: $token");
      AppUtils.log("Parsed user data: $userData");

      final data = LoginModel.fromJson(userData);
      Preferences.authToken = token;
      Preferences.profile = data;

      return ResponseData<LoginModel>(
        statusCode: result.statusCode,
        message: result.message,
        data: data,
      );
    } else {
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
      );
    }
  }


  @override
  Future<ResponseData<LoginModel>> checkEmailAndMobile({
    required String email,
    required String mobileNumber,
  }) async {
    final body = {
      'email': email,
      'mobileNumber': mobileNumber,
    };

    final result = await _apiMethod.post(
      url: Urls.checkEmailAndMobile,
      body: body,
      headers: {},
    );

    if (result.isSuccess) {
      return ResponseData<LoginModel>(
        statusCode: result.statusCode,
        message: result.message ?? "Verification successful",
        data: null,
      );
    }

    String? message;
    String? error;
    final errorData = result.data;
    if (errorData is Map<String, dynamic>) {
      message = errorData['message']?.toString();
      error = errorData['error']?.toString();
    }

    return ResponseData<LoginModel>(
      statusCode: result.statusCode,
      message: message ?? "Verification failed",
      error: error != null ? Exception(error) : null,
      data: null,
    );
  }




  @override
  Future<ResponseData<LoginModel>> VerifyOtp({
    required String action,
    required String mobile,
    required String hash,
    required int ?otp,

  }) async {
    final body = {
      'action': action,
      'mobile': mobile,
      'hash': hash,
      'otp': 112200,
    };

    final result = await _apiMethod.post(
      url: Urls.verifyOtp,
      body: body,
      headers: {
        "x-app-platform": "android",
        "x-app-version": "10.0",
      },
    );

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = rawData['data'] ?? {};
      AppUtils.log("data::::$userData");
      final data = LoginModel.fromJson(userData);
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
        data: data,
      );
    } else {
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
      );
    }
  }



  @override
  Future<ResponseData<LoginModel>> changePassword({
    required String action,
    required int userID,
    required String password,
    required String mobile,
    required String hash,


  }) async {
    final body = {
      'action': action,
      'userID': userID,
      'password': password,
      'mobile': mobile,
      'hash': hash,
    };

    final result = await _apiMethod.post(
      url: Urls.changePassword,
      body: body,
      headers: {
        "x-app-platform": "android",
        "x-app-version": "10.0",
      },
    );

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = (rawData['data'] is Map)
          ? (rawData['data'] as Map)['user'] ?? {}
          : {};

      final data = LoginModel.fromJson(Map<String, dynamic>.from(userData));
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
        data: data,
      );
    } else {
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
      );
    }
  }


  @override
  Future<ResponseData<LoginModel>> profileChangePassword({
    required String existingPassword,
    required String newPassword,

  }) async {
    final body = {
      'existingPassword': existingPassword,
      'newPassword': newPassword,
    };

    final result = await _apiMethod.patch(
      url: Urls.profileChangePassword,
      body: body,
      headers: {
        "x-app-platform": "android",
        "x-app-version": "1.0",
        "Content-Type":" application/json",
      },
      authToken: Preferences.authToken.bearer
    );
    AppUtils.log("body:::$body");
    AppUtils.log("API Result::::: ${result.toJson()}");

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = (rawData['data'] is Map)
          ? (rawData['data'] as Map)['user'] ?? {}
          : {};

      final data = LoginModel.fromJson(Map<String, dynamic>.from(userData));
      return  ResponseData(
        statusCode: result.statusCode,
        message: result.message,
        data: data,
      );
    } else {
      return ResponseData(
        statusCode: result.statusCode,
        message: result.message,
      );
    }
  }


  @override
  Future<ResponseData<String>> uploadPhoto({
    required File imageFile,
  }) async {
      final multipartFile = {
        'file': imageFile.path,
      };
      AppUtils.log("Uploading photo: $multipartFile");

      final response = await _apiMethod.post(
        url: Urls.uploadPhoto,
        body: {},
        multipartFile: multipartFile,
        headers: {},
      );

      if (response.isSuccess) {
        final data = response.data?["data"] ?? "";
        String dataString = "";
        if (data is String && data.isNotEmpty) {
          dataString = data;
        }

        AppUtils.log("Image uploaded successfully: $dataString");
        return ResponseData<String>(
          data: dataString,
          statusCode: response.statusCode,
          message: response.data?["message"] ?? "",
        );

      } else {
        AppUtils.log("Photo upload failed with status: ${response.error}");
        throw Exception('Photo upload failed');
      }
    }



  }