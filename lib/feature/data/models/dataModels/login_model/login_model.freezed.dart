// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) {
  return _LoginModel.fromJson(json);
}

/// @nodoc
mixin _$LoginModel {
  @JsonKey(name: "id")
  int? get id => throw _privateConstructorUsedError; // ✅ New field added
  @JsonKey(name: "user_id")
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: "username")
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: "name")
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: "mobile")
  String? get mobile => throw _privateConstructorUsedError;
  @JsonKey(name: "email")
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: "role_id")
  int? get roleId => throw _privateConstructorUsedError;
  @JsonKey(name: "role")
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: "isactive")
  int? get isactive => throw _privateConstructorUsedError;
  @JsonKey(name: "hash")
  String? get hash => throw _privateConstructorUsedError;

  /// Serializes this LoginModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginModelCopyWith<LoginModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginModelCopyWith<$Res> {
  factory $LoginModelCopyWith(
          LoginModel value, $Res Function(LoginModel) then) =
      _$LoginModelCopyWithImpl<$Res, LoginModel>;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "user_id") int? userId,
      @JsonKey(name: "username") String? username,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "mobile") String? mobile,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "role_id") int? roleId,
      @JsonKey(name: "role") String? role,
      @JsonKey(name: "isactive") int? isactive,
      @JsonKey(name: "hash") String? hash});
}

/// @nodoc
class _$LoginModelCopyWithImpl<$Res, $Val extends LoginModel>
    implements $LoginModelCopyWith<$Res> {
  _$LoginModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? username = freezed,
    Object? name = freezed,
    Object? mobile = freezed,
    Object? email = freezed,
    Object? roleId = freezed,
    Object? role = freezed,
    Object? isactive = freezed,
    Object? hash = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _value.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as int?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      isactive: freezed == isactive
          ? _value.isactive
          : isactive // ignore: cast_nullable_to_non_nullable
              as int?,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginModelImplCopyWith<$Res>
    implements $LoginModelCopyWith<$Res> {
  factory _$$LoginModelImplCopyWith(
          _$LoginModelImpl value, $Res Function(_$LoginModelImpl) then) =
      __$$LoginModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "user_id") int? userId,
      @JsonKey(name: "username") String? username,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "mobile") String? mobile,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "role_id") int? roleId,
      @JsonKey(name: "role") String? role,
      @JsonKey(name: "isactive") int? isactive,
      @JsonKey(name: "hash") String? hash});
}

/// @nodoc
class __$$LoginModelImplCopyWithImpl<$Res>
    extends _$LoginModelCopyWithImpl<$Res, _$LoginModelImpl>
    implements _$$LoginModelImplCopyWith<$Res> {
  __$$LoginModelImplCopyWithImpl(
      _$LoginModelImpl _value, $Res Function(_$LoginModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? username = freezed,
    Object? name = freezed,
    Object? mobile = freezed,
    Object? email = freezed,
    Object? roleId = freezed,
    Object? role = freezed,
    Object? isactive = freezed,
    Object? hash = freezed,
  }) {
    return _then(_$LoginModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _value.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as int?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      isactive: freezed == isactive
          ? _value.isactive
          : isactive // ignore: cast_nullable_to_non_nullable
              as int?,
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginModelImpl implements _LoginModel {
  const _$LoginModelImpl(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "user_id") this.userId,
      @JsonKey(name: "username") this.username,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "mobile") this.mobile,
      @JsonKey(name: "email") this.email,
      @JsonKey(name: "role_id") this.roleId,
      @JsonKey(name: "role") this.role,
      @JsonKey(name: "isactive") this.isactive,
      @JsonKey(name: "hash") this.hash});

  factory _$LoginModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginModelImplFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
// ✅ New field added
  @override
  @JsonKey(name: "user_id")
  final int? userId;
  @override
  @JsonKey(name: "username")
  final String? username;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "mobile")
  final String? mobile;
  @override
  @JsonKey(name: "email")
  final String? email;
  @override
  @JsonKey(name: "role_id")
  final int? roleId;
  @override
  @JsonKey(name: "role")
  final String? role;
  @override
  @JsonKey(name: "isactive")
  final int? isactive;
  @override
  @JsonKey(name: "hash")
  final String? hash;

  @override
  String toString() {
    return 'LoginModel(id: $id, userId: $userId, username: $username, name: $name, mobile: $mobile, email: $email, roleId: $roleId, role: $role, isactive: $isactive, hash: $hash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isactive, isactive) ||
                other.isactive == isactive) &&
            (identical(other.hash, hash) || other.hash == hash));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, username, name,
      mobile, email, roleId, role, isactive, hash);

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginModelImplCopyWith<_$LoginModelImpl> get copyWith =>
      __$$LoginModelImplCopyWithImpl<_$LoginModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginModelImplToJson(
      this,
    );
  }
}

abstract class _LoginModel implements LoginModel {
  const factory _LoginModel(
      {@JsonKey(name: "id") final int? id,
      @JsonKey(name: "user_id") final int? userId,
      @JsonKey(name: "username") final String? username,
      @JsonKey(name: "name") final String? name,
      @JsonKey(name: "mobile") final String? mobile,
      @JsonKey(name: "email") final String? email,
      @JsonKey(name: "role_id") final int? roleId,
      @JsonKey(name: "role") final String? role,
      @JsonKey(name: "isactive") final int? isactive,
      @JsonKey(name: "hash") final String? hash}) = _$LoginModelImpl;

  factory _LoginModel.fromJson(Map<String, dynamic> json) =
      _$LoginModelImpl.fromJson;

  @override
  @JsonKey(name: "id")
  int? get id; // ✅ New field added
  @override
  @JsonKey(name: "user_id")
  int? get userId;
  @override
  @JsonKey(name: "username")
  String? get username;
  @override
  @JsonKey(name: "name")
  String? get name;
  @override
  @JsonKey(name: "mobile")
  String? get mobile;
  @override
  @JsonKey(name: "email")
  String? get email;
  @override
  @JsonKey(name: "role_id")
  int? get roleId;
  @override
  @JsonKey(name: "role")
  String? get role;
  @override
  @JsonKey(name: "isactive")
  int? get isactive;
  @override
  @JsonKey(name: "hash")
  String? get hash;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginModelImplCopyWith<_$LoginModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
