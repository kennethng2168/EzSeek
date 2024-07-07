// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiktok_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TikTokVideo _$TikTokVideoFromJson(Map<String, dynamic> json) => TikTokVideo(
      version: json['version'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      authorUrl: json['authorUrl'] as String,
      authorName: json['authorName'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      html: json['html'] as String,
      thumbnailWidth: (json['thumbnailWidth'] as num).toInt(),
      thumbnailHeight: (json['thumbnailHeight'] as num).toInt(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      providerUrl: json['providerUrl'] as String,
      providerName: json['providerName'] as String,
      authorUniqueId: json['authorUniqueId'] as String,
      embedProductId: json['embedProductId'] as String,
      embedType: json['embedType'] as String,
    );

Map<String, dynamic> _$TikTokVideoToJson(TikTokVideo instance) =>
    <String, dynamic>{
      'version': instance.version,
      'type': instance.type,
      'title': instance.title,
      'authorUrl': instance.authorUrl,
      'authorName': instance.authorName,
      'width': instance.width,
      'height': instance.height,
      'html': instance.html,
      'thumbnailWidth': instance.thumbnailWidth,
      'thumbnailHeight': instance.thumbnailHeight,
      'thumbnailUrl': instance.thumbnailUrl,
      'providerUrl': instance.providerUrl,
      'providerName': instance.providerName,
      'authorUniqueId': instance.authorUniqueId,
      'embedProductId': instance.embedProductId,
      'embedType': instance.embedType,
    };
