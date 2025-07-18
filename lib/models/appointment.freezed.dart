// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  String? get id =>
      throw _privateConstructorUsedError; // Add id field for Firestore document ID
  String get customerId => throw _privateConstructorUsedError;
  bool get reviewed => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get staffId => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  AppointmentStatus get status => throw _privateConstructorUsedError;
  PaymentType? get paymentType => throw _privateConstructorUsedError;
  PaymentStatus? get paymentStatus => throw _privateConstructorUsedError;
  List<String> get serviceIds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;
  int? get totalTimeframe => throw _privateConstructorUsedError;
  BookingType? get bookingType => throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
          Appointment value, $Res Function(Appointment) then) =
      _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call(
      {String? id,
      String customerId,
      bool reviewed,
      DateTime startTime,
      DateTime endTime,
      String staffId,
      String? paymentReference,
      AppointmentStatus status,
      PaymentType? paymentType,
      PaymentStatus? paymentStatus,
      List<String> serviceIds,
      DateTime? createdAt,
      DateTime? updatedAt,
      double? totalPrice,
      int? totalTimeframe,
      BookingType? bookingType});
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? customerId = null,
    Object? reviewed = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? staffId = null,
    Object? paymentReference = freezed,
    Object? status = null,
    Object? paymentType = freezed,
    Object? paymentStatus = freezed,
    Object? serviceIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? totalPrice = freezed,
    Object? totalTimeframe = freezed,
    Object? bookingType = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewed: null == reviewed
          ? _value.reviewed
          : reviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AppointmentStatus,
      paymentType: freezed == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as PaymentType?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus?,
      serviceIds: null == serviceIds
          ? _value.serviceIds
          : serviceIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      totalTimeframe: freezed == totalTimeframe
          ? _value.totalTimeframe
          : totalTimeframe // ignore: cast_nullable_to_non_nullable
              as int?,
      bookingType: freezed == bookingType
          ? _value.bookingType
          : bookingType // ignore: cast_nullable_to_non_nullable
              as BookingType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
          _$AppointmentImpl value, $Res Function(_$AppointmentImpl) then) =
      __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String customerId,
      bool reviewed,
      DateTime startTime,
      DateTime endTime,
      String staffId,
      String? paymentReference,
      AppointmentStatus status,
      PaymentType? paymentType,
      PaymentStatus? paymentStatus,
      List<String> serviceIds,
      DateTime? createdAt,
      DateTime? updatedAt,
      double? totalPrice,
      int? totalTimeframe,
      BookingType? bookingType});
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
      _$AppointmentImpl _value, $Res Function(_$AppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? customerId = null,
    Object? reviewed = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? staffId = null,
    Object? paymentReference = freezed,
    Object? status = null,
    Object? paymentType = freezed,
    Object? paymentStatus = freezed,
    Object? serviceIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? totalPrice = freezed,
    Object? totalTimeframe = freezed,
    Object? bookingType = freezed,
  }) {
    return _then(_$AppointmentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewed: null == reviewed
          ? _value.reviewed
          : reviewed // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      staffId: null == staffId
          ? _value.staffId
          : staffId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentReference: freezed == paymentReference
          ? _value.paymentReference
          : paymentReference // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AppointmentStatus,
      paymentType: freezed == paymentType
          ? _value.paymentType
          : paymentType // ignore: cast_nullable_to_non_nullable
              as PaymentType?,
      paymentStatus: freezed == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus?,
      serviceIds: null == serviceIds
          ? _value._serviceIds
          : serviceIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      totalTimeframe: freezed == totalTimeframe
          ? _value.totalTimeframe
          : totalTimeframe // ignore: cast_nullable_to_non_nullable
              as int?,
      bookingType: freezed == bookingType
          ? _value.bookingType
          : bookingType // ignore: cast_nullable_to_non_nullable
              as BookingType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl implements _Appointment {
  const _$AppointmentImpl(
      {this.id,
      required this.customerId,
      this.reviewed = false,
      required this.startTime,
      required this.endTime,
      required this.staffId,
      required this.paymentReference,
      this.status = AppointmentStatus.pending,
      this.paymentType = PaymentType.cash,
      this.paymentStatus = PaymentStatus.pending,
      required final List<String> serviceIds,
      this.createdAt,
      this.updatedAt,
      this.totalPrice,
      this.totalTimeframe,
      this.bookingType})
      : _serviceIds = serviceIds;

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final String? id;
// Add id field for Firestore document ID
  @override
  final String customerId;
  @override
  @JsonKey()
  final bool reviewed;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String staffId;
  @override
  final String? paymentReference;
  @override
  @JsonKey()
  final AppointmentStatus status;
  @override
  @JsonKey()
  final PaymentType? paymentType;
  @override
  @JsonKey()
  final PaymentStatus? paymentStatus;
  final List<String> _serviceIds;
  @override
  List<String> get serviceIds {
    if (_serviceIds is EqualUnmodifiableListView) return _serviceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceIds);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final double? totalPrice;
  @override
  final int? totalTimeframe;
  @override
  final BookingType? bookingType;

  @override
  String toString() {
    return 'Appointment(id: $id, customerId: $customerId, reviewed: $reviewed, startTime: $startTime, endTime: $endTime, staffId: $staffId, paymentReference: $paymentReference, status: $status, paymentType: $paymentType, paymentStatus: $paymentStatus, serviceIds: $serviceIds, createdAt: $createdAt, updatedAt: $updatedAt, totalPrice: $totalPrice, totalTimeframe: $totalTimeframe, bookingType: $bookingType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.reviewed, reviewed) ||
                other.reviewed == reviewed) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            const DeepCollectionEquality()
                .equals(other._serviceIds, _serviceIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.totalTimeframe, totalTimeframe) ||
                other.totalTimeframe == totalTimeframe) &&
            (identical(other.bookingType, bookingType) ||
                other.bookingType == bookingType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      customerId,
      reviewed,
      startTime,
      endTime,
      staffId,
      paymentReference,
      status,
      paymentType,
      paymentStatus,
      const DeepCollectionEquality().hash(_serviceIds),
      createdAt,
      updatedAt,
      totalPrice,
      totalTimeframe,
      bookingType);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(
      this,
    );
  }
}

abstract class _Appointment implements Appointment {
  const factory _Appointment(
      {final String? id,
      required final String customerId,
      final bool reviewed,
      required final DateTime startTime,
      required final DateTime endTime,
      required final String staffId,
      required final String? paymentReference,
      final AppointmentStatus status,
      final PaymentType? paymentType,
      final PaymentStatus? paymentStatus,
      required final List<String> serviceIds,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final double? totalPrice,
      final int? totalTimeframe,
      final BookingType? bookingType}) = _$AppointmentImpl;

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  String? get id; // Add id field for Firestore document ID
  @override
  String get customerId;
  @override
  bool get reviewed;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get staffId;
  @override
  String? get paymentReference;
  @override
  AppointmentStatus get status;
  @override
  PaymentType? get paymentType;
  @override
  PaymentStatus? get paymentStatus;
  @override
  List<String> get serviceIds;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  double? get totalPrice;
  @override
  int? get totalTimeframe;
  @override
  BookingType? get bookingType;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
