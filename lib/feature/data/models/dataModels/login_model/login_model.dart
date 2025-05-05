import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

/// For decoding from JSON string
LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

/// For encoding to JSON string
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

/// Wrapper class for the API response
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required LoginModel data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Actual user model
@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({
    @JsonKey(name: "_id") String? id,
    String? name,
    String? image,
    String? email,
    String? countryCode,
    @JsonKey(name: "device_type") String? deviceType,
    @JsonKey(name: "device_token") String? deviceToken,
    DateTime? dob,
    String? gender,
    String? mobileNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
    String? token,
  }) = _LoginModel;

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}
