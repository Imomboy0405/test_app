part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitialState extends ChatState {
  final bool showEmojis;
  final Map<String, dynamic> values;
  final int length;
  final UserModel user;
  final bool focusNode;
  final bool shimmer;
  final List<MessageModel?> recentMessages;

  const ChatInitialState({
    required this.showEmojis,
    required this.values,
    required this.length,
    required this.user,
    required this.focusNode,
    required this.shimmer,
    required this.recentMessages,
  });

  @override
  List<Object> get props => [showEmojis, values, length, user, focusNode, shimmer, recentMessages];
}

final class ChatAdminState extends ChatState {
  final List<UserModel> doctorUsers;
  final List<UserModel> newUsers;

  const ChatAdminState({required this.doctorUsers, required this.newUsers});

  @override
  List<Object> get props => [doctorUsers, newUsers];
}

final class ChatLoadingState extends ChatState {
  @override
  List<Object?> get props => [];
}
