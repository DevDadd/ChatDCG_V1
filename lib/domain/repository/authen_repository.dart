import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/conversation_list_dto.dart';
import 'package:chatdcg_demo/data/models/message_history.dart';
import 'package:chatdcg_demo/data/models/send_message_request.dart';
import 'package:chatdcg_demo/data/models/sync_message_response.dart';
import 'package:chatdcg_demo/data/models/type_status_stream_dto.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';

abstract class AuthenRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<UserStatusDto> getUserStatus();

  /// Messages with [otherUserId], oldest first. Empty if the two never chatted;
  /// the server then creates the conversation and returns its id.
  Future<MessageHistoryDto> getHistory(int otherUserId);

  /// Bidirectional Chat RPC. Each request added to [outgoing] is sent as a
  /// message; the returned stream carries messages from the other
  /// participants of all the caller's conversations (never the caller's own).
  /// A rejected message (wrong conversation, wrong sender) ends the stream.
  Stream<Message> chat(Stream<SendMessageRequest> outgoing);
  Future<void> sentTypingStatus(int conversationid, bool isTyping, int userId);
  Stream<TypingStreamDto> streamTypingStatus(int conversationid, int userid);
  Future<SyncMessageResponse> syncMessages(List<SendMessageRequest> requests);
  Future<ConversationListDto> getConversation();

  /// Online/offline changes of other users. The caller counts as online
  /// while this stream is open.
  Stream<UserStatus> presence();
}
