import 'package:json_annotation/json_annotation.dart';

part 'message_history.g.dart';

@JsonSerializable()
class MessageHistoryDto {
  @JsonKey(name: "messages")
  List<Message>? messages;
  @JsonKey(name: "total_count")
  int? totalCount;

  MessageHistoryDto({this.messages, this.totalCount});

  factory MessageHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$MessageHistoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageHistoryDtoToJson(this);
}

@JsonSerializable()
class Message {
  @JsonKey(name: "message_id")
  int? messageId;
  @JsonKey(name: "conversation_id")
  int? conversationId;
  @JsonKey(name: "sender_id")
  int? senderId;
  @JsonKey(name: "sender_name")
  String? senderName;
  @JsonKey(name: "content")
  String? content;
  @JsonKey(name: "timestamp")
  DateTime? timestamp;
  bool isOffline;

  Message({
    this.messageId,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.content,
    this.timestamp,
    this.isOffline = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
