part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatInitialEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ChatSendButtonEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ChatEmojiButtonEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ChatEmojiEvent extends ChatEvent {
  final String emoji;

  const ChatEmojiEvent({required this.emoji});

  @override
  List<Object?> get props => [emoji];
}

class ChatReceiveMessageEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ChatGetUsersEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ChatPushDetailEvent extends ChatEvent {
  final UserModel userModel;
  final BuildContext context;

  const ChatPushDetailEvent({required this.userModel, required this.context});

  @override
  List<Object?> get props => [userModel, context];
}

class ChatPushInfoEvent extends ChatEvent {
  final UserModel userModel;
  final BuildContext context;

  const ChatPushInfoEvent({required this.userModel, required this.context});

  @override
  List<Object?> get props => [userModel, context];
}
