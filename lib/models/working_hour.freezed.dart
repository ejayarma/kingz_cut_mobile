// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'working_hour.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkingHour _$WorkingHourFromJson(Map<String, dynamic> json) {
  return _WorkingHour.fromJson(json);
}

/// @nodoc
mixin _$WorkingHour {
  String get dayName => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String get openingTime => throw _privateConstructorUsedError;
  String get closingTime => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this WorkingHour to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkingHourCopyWith<WorkingHour> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkingHourCopyWith<$Res> {
  factory $WorkingHourCopyWith(
          WorkingHour value, $Res Function(WorkingHour) then) =
      _$WorkingHourCopyWithImpl<$Res, WorkingHour>;
  @useResult
  $Res call(
      {String dayName,
      String shortName,
      String openingTime,
      String closingTime,
      bool isActive});
}

/// @nodoc
class _$WorkingHourCopyWithImpl<$Res, $Val extends WorkingHour>
    implements $WorkingHourCopyWith<$Res> {
  _$WorkingHourCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayName = null,
    Object? shortName = null,
    Object? openingTime = null,
    Object? closingTime = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      dayName: null == dayName
          ? _value.dayName
          : dayName // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      openingTime: null == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as String,
      closingTime: null == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkingHourImplCopyWith<$Res>
    implements $WorkingHourCopyWith<$Res> {
  factory _$$WorkingHourImplCopyWith(
          _$WorkingHourImpl value, $Res Function(_$WorkingHourImpl) then) =
      __$$WorkingHourImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dayName,
      String shortName,
      String openingTime,
      String closingTime,
      bool isActive});
}

/// @nodoc
class __$$WorkingHourImplCopyWithImpl<$Res>
    extends _$WorkingHourCopyWithImpl<$Res, _$WorkingHourImpl>
    implements _$$WorkingHourImplCopyWith<$Res> {
  __$$WorkingHourImplCopyWithImpl(
      _$WorkingHourImpl _value, $Res Function(_$WorkingHourImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayName = null,
    Object? shortName = null,
    Object? openingTime = null,
    Object? closingTime = null,
    Object? isActive = null,
  }) {
    return _then(_$WorkingHourImpl(
      dayName: null == dayName
          ? _value.dayName
          : dayName // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      openingTime: null == openingTime
          ? _value.openingTime
          : openingTime // ignore: cast_nullable_to_non_nullable
              as String,
      closingTime: null == closingTime
          ? _value.closingTime
          : closingTime // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkingHourImpl implements _WorkingHour {
  const _$WorkingHourImpl(
      {required this.dayName,
      required this.shortName,
      required this.openingTime,
      required this.closingTime,
      required this.isActive});

  factory _$WorkingHourImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkingHourImplFromJson(json);

  @override
  final String dayName;
  @override
  final String shortName;
  @override
  final String openingTime;
  @override
  final String closingTime;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'WorkingHour(dayName: $dayName, shortName: $shortName, openingTime: $openingTime, closingTime: $closingTime, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkingHourImpl &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.openingTime, openingTime) ||
                other.openingTime == openingTime) &&
            (identical(other.closingTime, closingTime) ||
                other.closingTime == closingTime) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, dayName, shortName, openingTime, closingTime, isActive);

  /// Create a copy of WorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkingHourImplCopyWith<_$WorkingHourImpl> get copyWith =>
      __$$WorkingHourImplCopyWithImpl<_$WorkingHourImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkingHourImplToJson(
      this,
    );
  }
}

abstract class _WorkingHour implements WorkingHour {
  const factory _WorkingHour(
      {required final String dayName,
      required final String shortName,
      required final String openingTime,
      required final String closingTime,
      required final bool isActive}) = _$WorkingHourImpl;

  factory _WorkingHour.fromJson(Map<String, dynamic> json) =
      _$WorkingHourImpl.fromJson;

  @override
  String get dayName;
  @override
  String get shortName;
  @override
  String get openingTime;
  @override
  String get closingTime;
  @override
  bool get isActive;

  /// Create a copy of WorkingHour
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkingHourImplCopyWith<_$WorkingHourImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
