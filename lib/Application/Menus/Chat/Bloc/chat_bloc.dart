import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_detail_page.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_user_info_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Models/group_model.dart';
import 'package:test_app/Data/Models/message_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/firestore_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';
import 'package:test_app/Data/Services/util_service.dart';
import 'package:uuid/uuid.dart';

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
  List<UserDetailModel> userDetailList = [];
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
            values: const {},
            length: 0,
            focusNode: false,
            recentMessages: const [],
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
    on<ChatPressGroupEvent>(pressGroup);
    on<ChatPushInfoEvent>(pushUserInfo);
    on<ChatEmojiEvent>(pressEmoji);
    on<ChatEmojiButtonEvent>(pressEmojiButton);
    on<ChatSendButtonEvent>(pressSendButton);
    on<ChatReceiveMessageEvent>(receiveMessage);
    on<ChatKeyboardEvent>(keyboardUpdate);
    on<ChatInitialEvent>((event, emit) {
      emitComfort(emit);
    });
  }

  void emitComfort(Emitter<ChatState> emit) {
    emit(ChatInitialState(
      showEmojis: showEmojis,
      values: values,
      length: values.length,
      recentMessages: doctorUsers.map((user) => user.groups.first.recentMessage).toList(),
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
    if (initial) {
      initial = false;
      if (mainBloc.userModel?.role == 'patient') {
        mainBloc.userModel?.groups = await FirestoreService.loadDoctorGroups(mainBloc.userModel!.uid!);
        if (mainBloc.userModel!.groups.isEmpty) {
          final group = GroupModel(
            createdAt: Timestamp.now(),
            createdBy: mainBloc.userModel?.uid,
            id: const Uuid().v4(),
            members: [mainBloc.userModel!.uid!],
            membersCount: 1,
            recentMessage: null,
            type: 1,
            updatedAt: Timestamp.now(),
          );
          await FirestoreService.createGroup(group);
          mainBloc.userModel!.groups = [group];
        }
        emitComfort(emit);
        return;
      }
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
  }

  void pressGroup(ChatPressGroupEvent event, Emitter<ChatState> emit) async {
    // initial = true;
    // shimmer = true;
    if (event.chat) {
      user = event.userModel;
      messages = null;
      myAnimatedPush(context: event.context, pushPage: const ChatDetailPage(), offset: const Offset(0, -1));
      // emitComfort(emit);
    } else {
      emit(ChatLoadingState());
      await FirestoreService.updateGroup(event.userModel.groups.first.copyWith(
        membersCount: 2,
        members: [event.userModel.uid!, mainBloc.userModel!.uid!],
      ));
      if (event.context.mounted) {
        Utils.mySnackBar(txt: '${event.userModel.displayName} bemorlaringizga qo`shildi', context: event.context);
      }
      doctorUsers.add(event.userModel);
      newUsers.remove(event.userModel);
      emit(ChatAdminState(doctorUsers: doctorUsers, newUsers: newUsers));
    }
  }

  Stream<List<MessageModel>> listenNewMsg() =>
      FirestoreService.listenForNewMessages(user?.groups.first.id! ?? mainBloc.userModel!.groups.first.id!);

  void pushUserInfo(ChatPushInfoEvent event, Emitter<ChatState> emit) {
    user = event.userModel;
    values.clear();
    myAnimatedPush(context: event.context, pushPage: const ChatUserInfoPage(), offset: const Offset(0, 1));
    emitComfort(emit);
  }

  Future<Map<String, dynamic>> loadMedicalInfo() async {
    List<Map<String, dynamic>> list = await FirestoreService.loadSeed(user!.uid!);
    for (var item in list) {
      values.addAll(item);
    }
    if (values.isNotEmpty && userDetailList.isEmpty) {
      userDetailList = (await RTDBService.loadSeed()).map((map) => UserDetailModel.fromJson(map)).toList();
    }
    final nValues = values;
    values = Map<String, dynamic>.from(nValues);
    return values;
  }

  Future<void> receiveMessage(ChatReceiveMessageEvent event, Emitter<ChatState> emit) async {
    if (messages == null) {
      messages = [];
      messages = await FirestoreService.loadMessage(user!.groups.first.id!);
      emitComfort(emit);
    }
    //  await for (var event in messagesRef.onChildAdded) {
    //   if (event.snapshot.value is Map) {
    //     final newMsg = MessageModel.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));
    //     messages ??= [];
    //     if (!messages!.contains(newMsg)) {
    //       messages!.add(newMsg);
    //       if (mainBloc.sound) {
    //         player.play(AssetSource('sounds/sound_chat.mp3'));
    //       }
    //       if (!isClosed) {
    //         emitComfort(emit);
    //       }
    //     }
    //   }
    // }
  }

  Future<void> pressSendButton(ChatSendButtonEvent event, Emitter<ChatState> emit) async {
    if (mainBloc.userModel?.role == 'doctor') {
      if (controller.text.trim().isNotEmpty) {
        String text = controller.text.trim();
        controller.clear();
        final msg = await FirestoreService.sendMessage(user!.groups.first.id!, text, mainBloc.userModel!.uid!);
        for (var model in doctorUsers) {
          if (model.groups.first.id == user?.groups.first.id) {
            model.groups.first = model.groups.first.copyWith(recentMessage: msg);
            break;
          }
        }
        if (mainBloc.sound) {
          player.play(AssetSource('sounds/sound_button.wav'));
        }
        // scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        if (!isClosed) {
          emitComfort(emit);
        }
      }
    } else {
      if (controller.text.trim().isNotEmpty) {
        String text = controller.text.trim();
        controller.clear();
        await FirestoreService.sendMessage(mainBloc.userModel!.groups.first.id!, text, mainBloc.userModel!.uid!);
        if (mainBloc.sound) {
          player.play(AssetSource('sounds/sound_button.wav'));
        }
        // scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        if (!isClosed) {
          emitComfort(emit);
        }
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
