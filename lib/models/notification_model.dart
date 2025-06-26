import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String uid,
    required String title,
    required String message,
    @Default('general') String type,
    @Default(false) bool read,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default([]) List<NotificationModel> notifications,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _NotificationState;
}

// For API responses
@freezed
class NotificationsResponse with _$NotificationsResponse {
  const factory NotificationsResponse({
    required List<NotificationModel> notifications,
  }) = _NotificationsResponse;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}

@freezed
@JsonSerializable(explicitToJson: true)
class CreateNotificationRequest with _$CreateNotificationRequest {
  const factory CreateNotificationRequest({
    required String uid,
    required String message,
    String? title,
    @Default('general') String type,
  }) = _CreateNotificationRequest;

  factory CreateNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateNotificationRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateNotificationRequestToJson(this);
}
