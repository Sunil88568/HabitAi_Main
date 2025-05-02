import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({
    @JsonKey(name: "id")
    int? id,
    @JsonKey(name: "user_id")
    int? userId,
    @JsonKey(name: "username")
    String? username,
    @JsonKey(name: "name")
    String? name,
    @JsonKey(name: "mobile")
    String? mobile,
    @JsonKey(name: "email")
    String? email,
    @JsonKey(name: "role_id")
    int? roleId,
    @JsonKey(name: "role")
    String? role,
    @JsonKey(name: "isactive")
    int? isactive,
    @JsonKey(name: "hash") String? hash,
  }) = _LoginModel;

  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);
}
