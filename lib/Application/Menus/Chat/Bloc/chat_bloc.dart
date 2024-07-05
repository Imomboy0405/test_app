import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_detail_page.dart';
import 'package:test_app/Application/Menus/Chat/View/chat_user_info_page.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Models/message_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  MainBloc mainBloc = locator<MainBloc>();
  DatabaseReference messagesRef = FirebaseDatabase.instance.ref();
  TextEditingController controller = TextEditingController();
  List<MessageModel>? messages;
  bool showEmojis = false;
  bool showKeyboard = false;
  bool initial = true;
  bool shimmer = true;
  List<UserModel> users = [];
  UserModel? user;
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

  ChatBloc()
      : super(ChatInitialState(
            showEmojis: false,
            shimmer: true,
            messages: const [],
            length: 0,
            focusNode: false,
            user: UserModel(
              fullName: '',
              createdTime: '',
              email: '',
              loginType: '',
              password: '',
              uId: '',
              userDetailList: [],
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
          messagesRef = FirebaseDatabase.instance.ref('chat/${user!.uId}/messages');
        } else {
          messagesRef = FirebaseDatabase.instance.ref('chat/${mainBloc.userModel!.uId}/messages');
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
            uId: '',
            email: '',
            fullName: '',
            password: '',
            createdTime: '',
            loginType: '',
            userDetailList: [],
          ),
    ));
  }

  void keyboardUpdate(ChatKeyboardEvent event, Emitter<ChatState> emit) {
    keyboardHeight = mainBloc.keyboardHeight;

    if (keyboardHeight > 0) {
      if (user == null) {
        mainBloc.add(MainHideBottomNavigationBarEvent());
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
    users = await RTDBService.loadUsers();
    var userToRemove = users.firstWhere((user) => user.uId == 'DBXkfBuedvagFrLIY1BgrNioH3u2');
    users.remove(userToRemove);
    emit(ChatAdminState(users: users));
  }

  void pushDetail(ChatPushDetailEvent event, Emitter<ChatState> emit) {
    user = event.userModel;
    messages = null;
    initial = true;
    shimmer = true;
    Navigator.push(
      event.context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ChatDetailPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, -1);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
    emitComfort(emit);
  }

  void pushUserInfo(ChatPushInfoEvent event, Emitter<ChatState> emit) {
    user = event.userModel;
    Navigator.push(
      event.context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ChatUserInfoPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.easeIn;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
    emitComfort(emit);
  }

  Future<void> receiveMessage(ChatReceiveMessageEvent event, Emitter<ChatState> emit) async {
    await for (var event in messagesRef.onChildAdded) {
      if (event.snapshot.value is Map) {
        final newMsg = MessageModel.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));
        messages ??= [];
        if (!messages!.contains(newMsg)) {
          messages!.add(newMsg);
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
        msg: controller.text.trim(),
        typeUser: user != null ? true : false,
        dateTime: DateTime.now().toString().substring(11, 16),
        id: DateTime.now().toString(),
      );
      messages ??= [];
      messages!.add(msgModel);
      controller.clear();

      await messagesRef.push().set(msgModel.toJson());
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
