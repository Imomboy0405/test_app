part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitialState extends ChatState {
  final bool showEmojis;
  final List<MessageModel> messages;
  final int length;

  const ChatInitialState({required this.showEmojis, required this.messages, required this.length});

  @override
  List<Object> get props => [showEmojis, messages, length];
}
