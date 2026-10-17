class TypingStreamDto {
  String? conversationId;
  String? userId;
  String? username;
  String? displayName;
  bool? isTyping;
  DateTime? timestamp;

  TypingStreamDto({
    this.conversationId,
    this.userId,
    this.username,
    this.displayName,
    this.isTyping,
    this.timestamp,
  });
}
