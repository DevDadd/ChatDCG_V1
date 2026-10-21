class ConversationListDto {
  List<Conversation>? conversations;

  ConversationListDto({this.conversations});
}

class Conversation {
  String? conversationId;
  OtherUser? otherUser;
  DateTime? createdAt;

  Conversation({this.conversationId, this.otherUser, this.createdAt});
}

class OtherUser {
  String? id;
  String? account;
  String? username;
  String? displayName;
  String? avatarUrl;

  OtherUser({
    this.id,
    this.account,
    this.username,
    this.displayName,
    this.avatarUrl,
  });
}
