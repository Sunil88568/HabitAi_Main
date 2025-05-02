// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginModelImpl _$$LoginModelImplFromJson(Map<String, dynamic> json) =>
    _$LoginModelImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      username: json['username'] as String?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      roleId: (json['role_id'] as num?)?.toInt(),
      role: json['role'] as String?,
      isactive: (json['isactive'] as num?)?.toInt(),
      hash: json['hash'] as String?,
    );

Map<String, dynamic> _$$LoginModelImplToJson(_$LoginModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'mobile': instance.mobile,
      'email': instance.email,
      'role_id': instance.roleId,
      'role': instance.role,
      'isactive': instance.isactive,
      'hash': instance.hash,
    };
