import 'dart:convert';
import 'package:question_app/utils/extensions/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/data/models/dataModels/login_model/login_model.dart';


class Preferences {
  static const _langKey = 'language_bwssb';
  static const _uidKey = 'uid_bwssb';
  static const _userPDataKey = 'profileData_bwssb';
  static const _authTokenPDataKey = 'authTokenData_bwssb';
  static const _fcmTokenKey = 'fcmToken_bwssb';
  static const _uploadedImageKey = 'uploadedImage_bwssb';
  static const _emailKey = 'email_bwssb';
  static const _seemypost = 'seemypost_bwssb';
  static const _sharepost = 'sharepost_bwssb';


  static late SharedPreferences _prefs;

  static Future<void> createInstance() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static set uid(String? uid) =>
      uid != null ? _prefs.setString(_uidKey, uid) : _prefs.remove(_uidKey);

  static String? get uid => _prefs.getString(_uidKey);

  static set email(String? email) =>
      email != null ? _prefs.setString(_emailKey, email) : _prefs.remove(_emailKey);

  static String? get email => _prefs.getString(_emailKey);


  static set seemypost(String? email) =>
      email != null ? _prefs.setString(_seemypost, email) : _prefs.remove(_seemypost);

  static String? get seemypost => _prefs.getString(_seemypost);



  static set shareMypost(String? email) =>
      email != null ? _prefs.setString(_sharepost, email) : _prefs.remove(_sharepost);

  static String? get shareMypost => _prefs.getString(_sharepost);



  static set profile(LoginModel? data) {
    if (data != null) {
      final json = jsonEncode(data);
      _prefs.setString(_userPDataKey, json);
    } else {
      _prefs.remove(_userPDataKey);
    }
  }

  static LoginModel? get profile {
    final jsonString = _prefs.getString(_userPDataKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString);
        return LoginModel.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static set authToken(String? value) =>
      value != null
          ? _prefs.setString(_authTokenPDataKey, value)
          : _prefs.remove(_authTokenPDataKey);

  static String? get authToken => _prefs.getString(_authTokenPDataKey);

  static bool get hasSession => authToken.isNotNullEmpty;

  static set fcmToken(String? value) =>
      value != null ? _prefs.setString(_fcmTokenKey, value) : _prefs.remove(
          _fcmTokenKey);

  static String? get fcmToken => _prefs.getString(_fcmTokenKey);

  static set savePrefOnLogin(LoginModel? data) {
    profile = data;
    // uid = data?.id;
    // authToken = data?.authToken;
  }

  static set savePrefOnSocialLogin(LoginModel? data) {
    profile = data;
    // uid = data?.userId;
    // authToken = data?.authToken;
  }

  static Future<void> onLogout() async {
    uid = null;
    profile = null;
    authToken = null;
    fcmToken = null;
    uploadedImage = null;
  }



  static set language(String? value) =>
      value != null ? _prefs.setString(_langKey, value) : _prefs.remove(
          _langKey);

  static String? get language => _prefs.getString(_langKey);


  static set uploadedImage(String? imageUrl) =>
      imageUrl != null ? _prefs.setString(_uploadedImageKey, imageUrl) : _prefs
          .remove(_uploadedImageKey);

  static String? get uploadedImage => _prefs.getString(_uploadedImageKey);

  static String? getImage() => _prefs.getString(_uploadedImageKey);


  static Future<void> clearAuthData() async {
    await Preferences._prefs.remove(Preferences._authTokenPDataKey);
    await Preferences._prefs.remove(Preferences._uidKey);
  }


  static Future<void> clearLanguage() async {
    await Preferences._prefs.remove(Preferences._langKey);
  }


  static Future<void> clearUploadedImage() async {
    await Preferences._prefs.remove(Preferences._uploadedImageKey);
  }


  static void clearUserData()  {
    uid = null;
    profile = null;
    authToken = null;
    uploadedImage = null;

    // await _prefs.remove(_uidKey);
    // await _prefs.remove(_userPDataKey);
    // await _prefs.remove(_authTokenPDataKey);
    // await _prefs.remove(_fcmTokenKey);
    // await _prefs.remove(_uploadedImageKey);
    // await _prefs.clear();
  }

}


