import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Data/Models/chat_model.dart';
import 'package:test_app/Data/Models/message_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MainBloc mainBloc = locator<MainBloc>();
  DatabaseReference messagesRef = FirebaseDatabase.instance.ref();
  TextEditingController controller = TextEditingController();
  List<MessageModel> messages = [];
  bool showEmojis = false;
  bool initial = true;
  final List<String> emojis = [
    '😀', '😃', '😄', '😁', '😆', '🥹', '😅', '😂', '🤣', '🥲',
    '☺️', '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘',
    '😗', '😙', '😚', '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐',
    '🤓', '😎', '🥸', '🤩', '🥳', '😏', '😒', '😞', '😔', '😟',
    '😕', '🙁', '☹️', '😣', '😖', '😫', '😩', '🥺', '😢', '😭',
    '😤', '😠', '😡', '🤬', '🤯', '😳', '🥵', '🥶', '😶‍🌫️', '😱',
    '😨', '😰', '😥', '😓', '🤗', '🤔', '🫣', '🤭', '🫢', '🫡',
    '🤫', '🫠', '🤥', '😶', '🫥', '😐', '🫤', '😑', '🫨', '😬',
    '🙄', '😯', '😦', '😧', '😮', '😲', '🥱', '😴', '🤤', '😪',
    '😮‍💨', '😵', '😵‍💫', '🤐', '🥴', '🤢', '🤮', '🤧', '😷', '🤒',
    '🤕', '🤑', '🤠', '😈', '👿'
  ];

  ChatBloc() : super(const ChatInitialState(showEmojis: false, messages: [], length: 0)) {
    on<ChatEmojiEvent>(pressEmoji);
    on<ChatEmojiButtonEvent>(pressEmojiButton);
    on<ChatSendButtonEvent>(pressSendButton);
    on<ChatReceiveMessageEvent>(emitMessage);
    on<ChatInitialEvent>((event, emit) {
      if (initial) {
        messagesRef = FirebaseDatabase.instance.ref('chat/${mainBloc.userModel!.uId}/messages');
        initial = false;
        add(ChatReceiveMessageEvent());
      }
    });
  }

  Future<void> emitMessage(ChatReceiveMessageEvent event, Emitter<ChatState> emit) async {
    await for (var event in messagesRef.onChildAdded) {
      if (event.snapshot.value is Map) {
        final newMsg = MessageModel.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));if (!messages.contains(newMsg)) {
          messages.add(newMsg);
          if (!isClosed) {
            emit(ChatInitialState(showEmojis: showEmojis, messages: messages, length: messages.length));
          }
        }
      }
    }
  }

  Future<void> pressSendButton(ChatSendButtonEvent event, Emitter<ChatState> emit) async {
    final msgModel = MessageModel(
      msg: controller.text,
      typeUser: true,
      dateTime: DateTime.now().toString().substring(11,16),
      id: DateTime.now().toString().substring(11,16),
    );
    messages.add(msgModel);
    controller.clear();

    await messagesRef.push().set(msgModel.toJson());
    if (!isClosed) {
      emit(ChatInitialState(showEmojis: showEmojis, messages: messages, length: messages.length));
    }
  }



  void pressEmoji(ChatEmojiEvent event, Emitter<ChatState> emit) {
    controller.text = controller.text + event.emoji;
    emit(ChatInitialState(showEmojis: showEmojis, messages: messages, length: messages.length));
  }

  void pressEmojiButton(ChatEmojiButtonEvent event, Emitter<ChatState> emit) {
    showEmojis = !showEmojis;
    emit(ChatInitialState(showEmojis: showEmojis, messages: messages, length: messages.length));
  }

}
