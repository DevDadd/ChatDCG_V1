import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/conversation_list_dto.dart';
import 'package:chatdcg_demo/data/models/message_history.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'authen_state.g.dart';

enum AuthenStatus { initial, loading, authenticated, failure }

@CopyWith()
class AuthenState extends Equatable {
  const AuthenState({
    this.status = AuthenStatus.initial,
    this.user,
    this.errorMessage,
    this.userStatus,
    this.history,
    this.isHistoryLoading = false,
    this.isOtherTyping = false,
    this.conversations,
  });

  final AuthenStatus status;

  // Set once login/register succeeds, cleared on logout
  final User? user;

  // Only meaningful when status is failure
  final String? errorMessage;

  final UserStatusDto? userStatus;

  // Old messages of the chat being opened, oldest first
  final MessageHistoryDto? history;
  final bool isHistoryLoading;

  // The other person in the open chat is typing
  final bool isOtherTyping;

  final ConversationListDto? conversations;

  bool get isLoading => status == AuthenStatus.loading;
  bool get isAuthenticated => status == AuthenStatus.authenticated;

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    userStatus,
    history,
    isHistoryLoading,
    isOtherTyping,
    conversations,
  ];
}
