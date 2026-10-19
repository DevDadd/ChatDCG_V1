import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/conversation_list_dto.dart';
import 'package:chatdcg_demo/data/models/message_baseresponse.dart';
import 'package:chatdcg_demo/data/models/message_history.dart';
import 'package:chatdcg_demo/data/models/send_message_request.dart';
import 'package:chatdcg_demo/data/models/sync_message_response.dart';
import 'package:chatdcg_demo/data/models/type_status_stream_dto.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';

abstract class AuthenRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<UserStatusDto> getUserStatus();

  /// Messages with [otherUserId], oldest first. Empty if the two never chatted.
  Future<MessageHistoryDto> getHistory(int otherUserId);
  Future<MessageBaseResponse> sendMessage(SendMessageRequest request);
  Stream<Message> streamMessages(int conversationid);
  Future<void> sentTypingStatus(int conversationid, bool isTyping, int userId);
  Stream<TypingStreamDto> streamTypingStatus(int conversationid, int userid);
  Future<SyncMessageResponse> syncMessages(List<SendMessageRequest> requests);
  Future<ConversationListDto> getConversation();

  /// Online/offline changes of other users. The caller counts as online
  /// while this stream is open.
  Stream<UserStatus> presence();
}
