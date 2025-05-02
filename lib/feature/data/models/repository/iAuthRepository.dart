// import 'dart:developer' as AppUtils;


import 'dart:developer' as AppUtils;

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
  Future<ResponseData<LoginModel>> loginUser({
    required String user,
    required String password,
  }) async {
    final body = {
      'username': user,
      'password': password,
    };

    AppUtils.log("Login API URL: ${Urls.login}");
    final result = await _apiMethod.post(
      url: Urls.login,
      body: body,
      headers: {
        "x-app-platform": "android",
        "x-app-version": "1.0",
      },
    );

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = rawData['data']?['user'] ?? {};
      final token = rawData['data']?['token'] ?? "";
      AppUtils.log("Token: $token");
      AppUtils.log("Parsed user data: $userData");
      final data = LoginModel.fromJson(userData);
      Preferences.authToken = token;
      Preferences.profile = data;
      return ResponseData(isSuccess: true, data: data);
    } else {
      return ResponseData(
        isSuccess: false,
        error: result.getError,
      );
    }
  }



  @override
  Future<ResponseData<LoginModel>> verifyUser({
    required String action,
    required String username,
    required String mobile,
  }) async {
    final body = {
      'action': action,
      'username': username,
      'mobile': mobile,
    };

    final result = await _apiMethod.post(
      url: Urls.verifyUser,
      body: body,
      headers: {
        "x-app-platform": "android",
        "x-app-version": "1.0",
      },
    );

    if (result.isSuccess) {
      final rawData = result.data ?? {};
      final userData = rawData['data']?['user'] ?? {};
      final hash = rawData['data']?['hash'];
      AppUtils.log("verification data : $userData");
      AppUtils.log("hash>>>>>: $hash");

      final data = LoginModel.fromJson(userData).copyWith(hash: hash);

      return ResponseData(isSuccess: true, data: data);
    } else {
      return ResponseData(
        isSuccess: false,
        error: result.getError,
      );
    }
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
      return ResponseData(isSuccess: true, data: data);
    } else {
      return ResponseData(
        isSuccess: false,
        error: result.getError,
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
      return ResponseData(isSuccess: true, data: data);
    } else {
      return ResponseData(
        isSuccess: false,
        error: result.getError,
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
      return ResponseData(isSuccess: true, data: data);
    } else {
      return ResponseData(
        isSuccess: false,
        error: result.getError,
      );
    }
  }



}