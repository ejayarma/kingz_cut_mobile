import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/models/customer.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required UserType userType,
    required bool hasOnboarded,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
