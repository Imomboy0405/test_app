part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitialState extends ChatState {
  final bool showEmojis;
  final List<MessageModel> messages;
  final int length;
  final UserModel user;
  final bool focusNode;
  final bool shimmer;

  const ChatInitialState({
    required this.showEmojis,
    required this.messages,
    required this.length,
    required this.user,
    required this.focusNode,
    required this.shimmer,
  });

  @override
  List<Object> get props => [showEmojis, messages, length, user, focusNode, shimmer];
}

final class ChatAdminState extends ChatState {
  final List<UserModel> users;

  const ChatAdminState({required this.users});

  @override
  List<Object> get props => [users];
}
