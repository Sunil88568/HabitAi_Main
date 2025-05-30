import 'dart:io';

import '../../data/models/dataModels/login_model/login_model.dart';
import '../../data/models/dataModels/question_model.dart';
import '../../data/models/dataModels/responseDataModel.dart';


abstract class AuthRepository {

  Future<ResponseData<LoginModel>> loginUser({
    required String email,
    required String password,
    String? device_type,
    String? device_token,
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


  Future<ResponseData<LoginModel>> guestLogin({
    String ?name,
    String ?email,
    String ?mobileNumber,
  });

  Future<ResponseData<LoginModel>> checkEmailAndMobile({
    required String email,
    required String mobileNumber,
  });

  Future<ResponseData<LoginModel>> forgotPassword({
    required String email,
  });


  Future<ResponseData<LoginModel>> getUserProfile();

  Future<ResponseData<LoginModel>> logOut();


  Future<ResponseData<LoginModel>> profileChangePassword({
    required String existingPassword,
    required String newPassword,

  });

  Future<ResponseData<LoginModel>> contactUs({
    required String title,
    required String message,

  });

  Future<ResponseData<String>> uploadPhoto({ required File imageFile });


  Future<ResponseData<LoginModel>> editProfile({
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

  Future<ResponseData<List<QuestionModel>>> getQuestions();


  Future<ResponseData<LoginModel>> submitQuestions({
    required String questionId,
    required String question,
    required String answer,
  });


  Future<ResponseData<LoginModel>> submitQuestionsGuestUser({
    required String guestUserId,
    required String questionId,
    required String question,
    required String answer,
});


  Future<Map<String,dynamic>> checkout(String id);
  Future<Map<String,dynamic>> getNotifications(String id);

}