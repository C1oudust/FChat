// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
      id: json['id'] as String,
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'isUser': instance.isUser,
      'id': instance.id,
    };
