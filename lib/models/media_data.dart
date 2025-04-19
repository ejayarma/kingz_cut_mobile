import 'package:json_annotation/json_annotation.dart';
part 'media_data.g.dart';

@JsonSerializable()
class MediaData {
  final String name;
  @JsonKey(name: 'file_name')
  final String fileName;
  final int size;
  @JsonKey(name: 'human_readable_size')
  final String humanReadableSize;
  final String url;

  MediaData({
    required this.name,
    required this.fileName,
    required this.size,
    required this.humanReadableSize,
    required this.url,
  });

  factory MediaData.fromJson(Map<String, dynamic> json) =>
      _$MediaDataFromJson(json);
  Map<String, dynamic> toJson() => _$MediaDataToJson(this);
}
