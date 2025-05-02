import 'dart:io';

import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/responseDataModel.dart';


abstract class AuthRepository {
  Future<ResponseData<LoginModel>> loginUser({
    required String user,
    required String password,
  });

  Future<ResponseData<LoginModel>> verifyUser({
    required String action,
    required String username,
    required String mobile,
  });


  Future<ResponseData<LoginModel>> VerifyOtp({
    required String action,
    required String mobile,
    required String hash,
    required int? otp,

  });


  Future<ResponseData<LoginModel>> changePassword({
    required int userID,
    required String action,
    required String password,
    required String mobile,
    required String hash,

  });


  Future<ResponseData<LoginModel>> profileChangePassword({
    required String existingPassword,
    required String newPassword,

  });
}