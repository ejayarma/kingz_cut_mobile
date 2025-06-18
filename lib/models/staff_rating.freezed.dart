// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_rating.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffRating _$StaffRatingFromJson(Map<String, dynamic> json) {
  return _StaffRating.fromJson(json);
}

/// @nodoc
mixin _$StaffRating {
  String get id => throw _privateConstructorUsedError;
  double? get value => throw _privateConstructorUsedError;
  String? get staffId => throw _privateConstructorUsedError;
  String? get appointmentId => throw _privateConstructorUsedError;
  String? get customerId => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StaffRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffRatingCopyWith<StaffRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffRatingCopyWith<$Res> {
  factory $StaffRatingCopyWith(
          StaffRating value, $Res Function(StaffRating) then) =
      _$StaffRatingCopyWithImpl<$Res, StaffRating>;
  @useResult
  $Res call(
      {String id,
      double? value,
      String? staffId,
      String? appointmentId,
      String? customerId,
      String? comment,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$StaffRatingCopyWithImpl<$Res, $Val extends StaffRating>
    implements $StaffRatingCopyWith<$Res> {
  _$StaffRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? value = freezed,
    Object? staffId = freezed,
    Object? appointmentId = freezed,
    Object? customerId = freezed,
    Object? comment = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      staffId: freezed == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentId: freezed == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffRatingImplCopyWith<$Res>
    implements $StaffRatingCopyWith<$Res> {
  factory _$$StaffRatingImplCopyWith(
          _$StaffRatingImpl value, $Res Function(_$StaffRatingImpl) then) =
      __$$StaffRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double? value,
      String? staffId,
      String? appointmentId,
      String? customerId,
      String? comment,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$StaffRatingImplCopyWithImpl<$Res>
    extends _$StaffRatingCopyWithImpl<$Res, _$StaffRatingImpl>
    implements _$$StaffRatingImplCopyWith<$Res> {
  __$$StaffRatingImplCopyWithImpl(
      _$StaffRatingImpl _value, $Res Function(_$StaffRatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? value = freezed,
    Object? staffId = freezed,
    Object? appointmentId = freezed,
    Object? customerId = freezed,
    Object? comment = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$StaffRatingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double?,
      staffId: freezed == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String?,
      appointmentId: freezed == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffRatingImpl implements _StaffRating {
  const _$StaffRatingImpl(
      {required this.id,
      required this.value,
      required this.staffId,
      required this.appointmentId,
      required this.customerId,
      required this.comment,
      required this.createdAt,
      required this.updatedAt});

  factory _$StaffRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffRatingImplFromJson(json);

  @override
  final String id;
  @override
  final double? value;
  @override
  final String? staffId;
  @override
  final String? appointmentId;
  @override
  final String? customerId;
  @override
  final String? comment;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StaffRating(id: $id, value: $value, staffId: $staffId, appointmentId: $appointmentId, customerId: $customerId, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffRatingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, value, staffId,
      appointmentId, customerId, comment, createdAt, updatedAt);

  /// Create a copy of StaffRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffRatingImplCopyWith<_$StaffRatingImpl> get copyWith =>
      __$$StaffRatingImplCopyWithImpl<_$StaffRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffRatingImplToJson(
      this,
    );
  }
}

abstract class _StaffRating implements StaffRating {
  const factory _StaffRating(
      {required final String id,
      required final double? value,
      required final String? staffId,
      required final String? appointmentId,
      required final String? customerId,
      required final String? comment,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$StaffRatingImpl;

  factory _StaffRating.fromJson(Map<String, dynamic> json) =
      _$StaffRatingImpl.fromJson;

  @override
  String get id;
  @override
  double? get value;
  @override
  String? get staffId;
  @override
  String? get appointmentId;
  @override
  String? get customerId;
  @override
  String? get comment;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of StaffRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffRatingImplCopyWith<_$StaffRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
