// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointments_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppointmentsState {
  List<Appointment> get appointments => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentsStateCopyWith<AppointmentsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentsStateCopyWith<$Res> {
  factory $AppointmentsStateCopyWith(
          AppointmentsState value, $Res Function(AppointmentsState) then) =
      _$AppointmentsStateCopyWithImpl<$Res, AppointmentsState>;
  @useResult
  $Res call({List<Appointment> appointments, bool isLoading, String? error});
}

/// @nodoc
class _$AppointmentsStateCopyWithImpl<$Res, $Val extends AppointmentsState>
    implements $AppointmentsStateCopyWith<$Res> {
  _$AppointmentsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointments = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      appointments: null == appointments
          ? _value.appointments
          : appointments // ignore: cast_nullable_to_non_nullable
              as List<Appointment>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentsStateImplCopyWith<$Res>
    implements $AppointmentsStateCopyWith<$Res> {
  factory _$$AppointmentsStateImplCopyWith(_$AppointmentsStateImpl value,
          $Res Function(_$AppointmentsStateImpl) then) =
      __$$AppointmentsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Appointment> appointments, bool isLoading, String? error});
}

/// @nodoc
class __$$AppointmentsStateImplCopyWithImpl<$Res>
    extends _$AppointmentsStateCopyWithImpl<$Res, _$AppointmentsStateImpl>
    implements _$$AppointmentsStateImplCopyWith<$Res> {
  __$$AppointmentsStateImplCopyWithImpl(_$AppointmentsStateImpl _value,
      $Res Function(_$AppointmentsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppointmentsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointments = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$AppointmentsStateImpl(
      appointments: null == appointments
          ? _value._appointments
          : appointments // ignore: cast_nullable_to_non_nullable
              as List<Appointment>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AppointmentsStateImpl implements _AppointmentsState {
  const _$AppointmentsStateImpl(
      {final List<Appointment> appointments = const [],
      this.isLoading = false,
      this.error})
      : _appointments = appointments;

  final List<Appointment> _appointments;
  @override
  @JsonKey()
  List<Appointment> get appointments {
    if (_appointments is EqualUnmodifiableListView) return _appointments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appointments);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'AppointmentsState(appointments: $appointments, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._appointments, _appointments) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_appointments), isLoading, error);

  /// Create a copy of AppointmentsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentsStateImplCopyWith<_$AppointmentsStateImpl> get copyWith =>
      __$$AppointmentsStateImplCopyWithImpl<_$AppointmentsStateImpl>(
          this, _$identity);
}

abstract class _AppointmentsState implements AppointmentsState {
  const factory _AppointmentsState(
      {final List<Appointment> appointments,
      final bool isLoading,
      final String? error}) = _$AppointmentsStateImpl;

  @override
  List<Appointment> get appointments;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of AppointmentsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentsStateImplCopyWith<_$AppointmentsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
