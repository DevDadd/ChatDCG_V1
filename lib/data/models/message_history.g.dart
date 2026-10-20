// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageHistoryDto _$MessageHistoryDtoFromJson(Map<String, dynamic> json) =>
    MessageHistoryDto(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt(),
      conversationId: (json['conversation_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageHistoryDtoToJson(MessageHistoryDto instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'total_count': instance.totalCount,
      'conversation_id': instance.conversationId,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  messageId: (json['message_id'] as num?)?.toInt(),
  conversationId: (json['conversation_id'] as num?)?.toInt(),
  senderId: (json['sender_id'] as num?)?.toInt(),
  senderName: json['sender_name'] as String?,
  content: json['content'] as String?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  isOffline: json['isOffline'] as bool? ?? false,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'message_id': instance.messageId,
  'conversation_id': instance.conversationId,
  'sender_id': instance.senderId,
  'sender_name': instance.senderName,
  'content': instance.content,
  'timestamp': instance.timestamp?.toIso8601String(),
  'isOffline': instance.isOffline,
};
