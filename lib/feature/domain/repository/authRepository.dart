import 'dart:io';

import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/responseDataModel.dart';


abstract class AuthRepository {
  Future<ResponseData<LoginModel>> loginUser({
    required String email,
    required String password,
  });

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
  });



  Future<ResponseData<LoginModel>> checkEmailAndMobile({
    required String email,
    required String mobileNumber,
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

  Future<ResponseData<String>> uploadPhoto({ required File imageFile });
}