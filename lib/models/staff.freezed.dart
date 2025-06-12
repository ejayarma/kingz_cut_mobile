// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Staff _$StaffFromJson(Map<String, dynamic> json) {
  return _Staff.fromJson(json);
}

/// @nodoc
mixin _$Staff {
  bool get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  String? get imageUrl => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'services')
  List<String> get serviceIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this Staff to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Staff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffCopyWith<Staff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffCopyWith<$Res> {
  factory $StaffCopyWith(Staff value, $Res Function(Staff) then) =
      _$StaffCopyWithImpl<$Res, Staff>;
  @useResult
  $Res call(
      {bool active,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      String email,
      String id,
      @JsonKey(name: 'image') String? imageUrl,
      String name,
      String phone,
      String role,
      @JsonKey(name: 'services') List<String> serviceIds,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      String? url,
      @JsonKey(name: 'userId') String userId});
}

/// @nodoc
class _$StaffCopyWithImpl<$Res, $Val extends Staff>
    implements $StaffCopyWith<$Res> {
  _$StaffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Staff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? createdAt = null,
    Object? email = null,
    Object? id = null,
    Object? imageUrl = freezed,
    Object? name = null,
    Object? phone = null,
    Object? role = null,
    Object? serviceIds = null,
    Object? updatedAt = null,
    Object? url = freezed,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      serviceIds: null == serviceIds
          ? _value.serviceIds
          : serviceIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffImplCopyWith<$Res> implements $StaffCopyWith<$Res> {
  factory _$$StaffImplCopyWith(
          _$StaffImpl value, $Res Function(_$StaffImpl) then) =
      __$$StaffImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool active,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      String email,
      String id,
      @JsonKey(name: 'image') String? imageUrl,
      String name,
      String phone,
      String role,
      @JsonKey(name: 'services') List<String> serviceIds,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      String? url,
      @JsonKey(name: 'userId') String userId});
}

/// @nodoc
class __$$StaffImplCopyWithImpl<$Res>
    extends _$StaffCopyWithImpl<$Res, _$StaffImpl>
    implements _$$StaffImplCopyWith<$Res> {
  __$$StaffImplCopyWithImpl(
      _$StaffImpl _value, $Res Function(_$StaffImpl) _then)
      : super(_value, _then);

  /// Create a copy of Staff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? active = null,
    Object? createdAt = null,
    Object? email = null,
    Object? id = null,
    Object? imageUrl = freezed,
    Object? name = null,
    Object? phone = null,
    Object? role = null,
    Object? serviceIds = null,
    Object? updatedAt = null,
    Object? url = freezed,
    Object? userId = null,
  }) {
    return _then(_$StaffImpl(
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      serviceIds: null == serviceIds
          ? _value._serviceIds
          : serviceIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffImpl implements _Staff {
  const _$StaffImpl(
      {required this.active,
      @JsonKey(name: 'createdAt') required this.createdAt,
      required this.email,
      required this.id,
      @JsonKey(name: 'image') this.imageUrl,
      required this.name,
      required this.phone,
      required this.role,
      @JsonKey(name: 'services') required final List<String> serviceIds,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      this.url,
      @JsonKey(name: 'userId') required this.userId})
      : _serviceIds = serviceIds;

  factory _$StaffImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffImplFromJson(json);

  @override
  final bool active;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  final String email;
  @override
  final String id;
  @override
  @JsonKey(name: 'image')
  final String? imageUrl;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String role;
  final List<String> _serviceIds;
  @override
  @JsonKey(name: 'services')
  List<String> get serviceIds {
    if (_serviceIds is EqualUnmodifiableListView) return _serviceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceIds);
  }

  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @override
  final String? url;
  @override
  @JsonKey(name: 'userId')
  final String userId;

  @override
  String toString() {
    return 'Staff(active: $active, createdAt: $createdAt, email: $email, id: $id, imageUrl: $imageUrl, name: $name, phone: $phone, role: $role, serviceIds: $serviceIds, updatedAt: $updatedAt, url: $url, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffImpl &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._serviceIds, _serviceIds) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      active,
      createdAt,
      email,
      id,
      imageUrl,
      name,
      phone,
      role,
      const DeepCollectionEquality().hash(_serviceIds),
      updatedAt,
      url,
      userId);

  /// Create a copy of Staff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffImplCopyWith<_$StaffImpl> get copyWith =>
      __$$StaffImplCopyWithImpl<_$StaffImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffImplToJson(
      this,
    );
  }
}

abstract class _Staff implements Staff {
  const factory _Staff(
      {required final bool active,
      @JsonKey(name: 'createdAt') required final DateTime createdAt,
      required final String email,
      required final String id,
      @JsonKey(name: 'image') final String? imageUrl,
      required final String name,
      required final String phone,
      required final String role,
      @JsonKey(name: 'services') required final List<String> serviceIds,
      @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
      final String? url,
      @JsonKey(name: 'userId') required final String userId}) = _$StaffImpl;

  factory _Staff.fromJson(Map<String, dynamic> json) = _$StaffImpl.fromJson;

  @override
  bool get active;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  String get email;
  @override
  String get id;
  @override
  @JsonKey(name: 'image')
  String? get imageUrl;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get role;
  @override
  @JsonKey(name: 'services')
  List<String> get serviceIds;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override
  String? get url;
  @override
  @JsonKey(name: 'userId')
  String get userId;

  /// Create a copy of Staff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffImplCopyWith<_$StaffImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
