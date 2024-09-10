import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_user_info_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Models/message_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/firestore_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/util_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  MainBloc mainBloc = locator<MainBloc>();
  DatabaseReference messagesRef = FirebaseDatabase.instance.ref();
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<MessageModel>? messages;
  bool showEmojis = false;
  bool showKeyboard = false;
  bool initial = true;
  bool shimmer = true;
  List<UserModel> newUsers = [];
  List<UserModel> doctorUsers = [];
  UserModel? user;
  List<List> userDetailList = [];
  FocusNode focusNode = FocusNode();
  bool focus = true;
  double keyboardHeight = 0;

  final List<String> emojis = [
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '🥹',
    '😅',
    '😂',
    '🤣',
    '🥲',
    '☺️',
    '😊',
    '😇',
    '🙂',
    '🙃',
    '😉',
    '😌',
    '😍',
    '🥰',
    '😘',
    '😗',
    '😙',
    '😚',
    '😋',
    '😛',
    '😝',
    '😜',
    '🤪',
    '🤨',
    '🧐',
    '🤓',
    '😎',
    '🥸',
    '🤩',
    '🥳',
    '😏',
    '😒',
    '😞',
    '😔',
    '😟',
    '😕',
    '🙁',
    '☹️',
    '😣',
    '😖',
    '😫',
    '😩',
    '🥺',
    '😢',
    '😭',
    '😤',
    '😠',
    '😡',
    '🤬',
    '🤯',
    '😳',
    '🥵',
    '🥶',
    '😶‍🌫️',
    '😱',
    '😨',
    '😰',
    '😥',
    '😓',
    '🤗',
    '🤔',
    '🫣',
    '🤭',
    '🫢',
    '🫡',
    '🤫',
    '🫠',
    '🤥',
    '😶',
    '🫥',
    '😐',
    '🫤',
    '😑',
    '🫨',
    '😬',
    '🙄',
    '😯',
    '😦',
    '😧',
    '😮',
    '😲',
    '🥱',
    '😴',
    '🤤',
    '😪',
    '😮‍💨',
    '😵',
    '😵‍💫',
    '🤐',
    '🥴',
    '🤢',
    '🤮',
    '🤧',
    '😷',
    '🤒',
    '🤕',
    '🤑',
    '🤠',
    '😈',
    '👿'
  ];
  List<Widget> icons = [
    Icon(Icons.medical_information, color: AppColors.purple),
    Icon(Icons.medication_liquid, color: AppColors.purple),
    Icon(Icons.medical_services, color: AppColors.purple),
    Row(
      children: [
        Icon(Icons.elderly_woman, color: AppColors.purple),
        Icon(Icons.elderly, color: AppColors.purple),
      ],
    ),
    Icon(Icons.woman, color: AppColors.purple),
  ];

  Map<String, dynamic> values = {};
  final player = AudioPlayer();

  ChatBloc()
      : super(ChatInitialState(
            showEmojis: false,
            shimmer: true,
            messages: const [],
            length: 0,
            focusNode: false,
            user: UserModel(
              displayName: '',
              createdAt: null,
              email: '',
              role: '',
              uid: '',
              verified: false,
              phoneNumber: null,
              photoURL: null,
              groups: [],
            ))) {
    on<ChatGetUsersEvent>(getUsers);
    on<ChatPushDetailEvent>(pushDetail);
    on<ChatPushInfoEvent>(pushUserInfo);
    on<ChatEmojiEvent>(pressEmoji);
    on<ChatEmojiButtonEvent>(pressEmojiButton);
    on<ChatSendButtonEvent>(pressSendButton);
    on<ChatReceiveMessageEvent>(receiveMessage);
    on<ChatKeyboardEvent>(keyboardUpdate);
    on<ChatInitialEvent>((event, emit) {
      if (initial) {
        if (user != null) {
          messagesRef = FirebaseDatabase.instance.ref('chat/${user!.uid}/messages');
        } else {
          messagesRef = FirebaseDatabase.instance.ref('chat/${mainBloc.userModel!.uid}/messages');
        }
        initial = false;
        shimmer = false;
        add(ChatReceiveMessageEvent());
      }
    });
  }

  void emitComfort(Emitter<ChatState> emit) {
    emit(ChatInitialState(
      showEmojis: showEmojis,
      messages: messages ?? [],
      length: messages?.length ?? 0,
      focusNode: focus,
      shimmer: shimmer,
      user: user ??
          UserModel(
            uid: '',
            email: '',
            displayName: '',
            createdAt: null,
            role: '',
            verified: false,
            phoneNumber: null,
            photoURL: null,
            groups: [],
          ),
    ));
  }

  void keyboardUpdate(ChatKeyboardEvent event, Emitter<ChatState> emit) {
    keyboardHeight = mainBloc.keyboardHeight;

    if (keyboardHeight > 0) {
      if (user == null) {
        mainBloc.add(MainHideBottomNavigationBarEvent(hideAll: true));
      }
      focus = false;
    } else if (keyboardHeight == 0) {
      focus = true;
      focusNode.unfocus();
      if (user == null) {
        mainBloc.add(MainLanguageEvent());
      }
    }
    emitComfort(emit);
  }

  Future<void> getUsers(ChatGetUsersEvent event, Emitter<ChatState> emit) async {
    final emptyGroups = await FirestoreService.loadEmptyGroups();
    final doctorGroups = await FirestoreService.loadDoctorGroups(mainBloc.userModel!.uid!);
    for (var group in emptyGroups) {
      UserModel? user = await FirestoreService.loadUser(group.createdBy!);
      if (user != null && !newUsers.contains(user)) newUsers.add(user.copyWith(groups: [group]));
    }
    for (var group in doctorGroups) {
      UserModel? user = await FirestoreService.loadUser(group.createdBy!);
      if (user != null && !doctorUsers.contains(user)) doctorUsers.add(user.copyWith(groups: [group]));
    }
    emit(ChatAdminState(doctorUsers: doctorUsers, newUsers: newUsers));
  }

  void pushDetail(ChatPushDetailEvent event, Emitter<ChatState> emit) async {
    // user = event.userModel;
    // messages = null;
    // initial = true;
    // shimmer = true;
    emit(ChatLoadingState());
    await FirestoreService.updateGroup(event.userModel.groups.first.copyWith(2, [event.userModel.uid!, mainBloc.userModel!.uid!]));
    if (event.context.mounted) {
      Utils.mySnackBar(txt: '${event.userModel.displayName} bemorlaringizga qo`shildi', context: event.context);
    }
    // myAnimatedPush(context: event.context, pushPage: const ChatDetailPage(), offset: const Offset(0, -1));
    // (await FirestoreService.loadSeed(user!.uid!)).map((map) => values.addAll(map));
    doctorUsers.add(event.userModel);
    newUsers.remove(event.userModel);
    emit(ChatAdminState(doctorUsers: doctorUsers, newUsers: newUsers));
  }

  void pushUserInfo(ChatPushInfoEvent event, Emitter<ChatState> emit) {
    user = event.userModel;
    myAnimatedPush(context: event.context, pushPage: const ChatUserInfoPage(), offset: const Offset(0, 1));
    emitComfort(emit);
  }

  Future<void> receiveMessage(ChatReceiveMessageEvent event, Emitter<ChatState> emit) async {
     await for (var event in messagesRef.onChildAdded) {
      if (event.snapshot.value is Map) {
        final newMsg = MessageModel.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));
        messages ??= [];
        if (!messages!.contains(newMsg)) {
          messages!.add(newMsg);
          if (mainBloc.sound) {
            player.play(AssetSource('sounds/sound_chat.mp3'));
          }
          if (!isClosed) {
            emitComfort(emit);
          }
        }
      }
    }
  }

  Future<void> pressSendButton(ChatSendButtonEvent event, Emitter<ChatState> emit) async {
    if (controller.text.trim().isNotEmpty) {
      final msgModel = MessageModel(
        message: controller.text.trim(),
        meta: {},
        readBy: [],
        sentAt: Timestamp.now(),
        sentBy: user?.uid,
        id: DateTime.now().toString(),
      );
      messages ??= [];
      messages!.add(msgModel);
      controller.clear();

      await messagesRef.push().set(msgModel.toJson());
      if (mainBloc.sound) {
        player.play(AssetSource('sounds/sound_button.wav'));
      }
      scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

      if (!isClosed) {
        emitComfort(emit);
      }
    }
  }

  void pressEmoji(ChatEmojiEvent event, Emitter<ChatState> emit) {
    controller.text = controller.text + event.emoji;
    emitComfort(emit);
  }

  void pressEmojiButton(ChatEmojiButtonEvent event, Emitter<ChatState> emit) {
    showEmojis = !showEmojis;
    emitComfort(emit);
  }
}
