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
