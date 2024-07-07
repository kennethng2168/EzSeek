import 'package:json_annotation/json_annotation.dart';

part 'tiktok_video.g.dart';

@JsonSerializable()
class TikTokVideo {
  final String version;
  final String type;
  final String title;
  final String authorUrl;
  final String authorName;
  final String width;
  final String height;
  final String html;
  final int thumbnailWidth;
  final int thumbnailHeight;
  final String thumbnailUrl;
  final String providerUrl;
  final String providerName;
  final String authorUniqueId;
  final String embedProductId;
  final String embedType;

  TikTokVideo({
    required this.version,
    required this.type,
    required this.title,
    required this.authorUrl,
    required this.authorName,
    required this.width,
    required this.height,
    required this.html,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    required this.thumbnailUrl,
    required this.providerUrl,
    required this.providerName,
    required this.authorUniqueId,
    required this.embedProductId,
    required this.embedType,
  });

  factory TikTokVideo.fromJson(Map<String, dynamic> json) =>
      _$TikTokVideoFromJson(json);

  Map<String, dynamic> toJson() => _$TikTokVideoToJson(this);
}
