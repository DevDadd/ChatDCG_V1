class SendMessageRequest {
  String? clientTimestampMs;
  String? content;
  String? conversationId;
  String? senderId;

  SendMessageRequest({
    this.clientTimestampMs,
    this.content,
    this.conversationId,
    this.senderId,
  });
}
