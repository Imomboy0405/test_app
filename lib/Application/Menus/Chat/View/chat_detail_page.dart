import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ChatDetailPage extends StatelessWidget {
  static const id = '/chat_detail_page';

  const ChatDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatBloc bloc = locator<ChatBloc>();

    return BlocBuilder<ChatBloc, ChatState>(
      bloc: bloc,
      builder: (context, state) {
        if (bloc.initial) {
          bloc.add(ChatInitialEvent());
        }
        return Scaffold(
          backgroundColor: AppColors.black,
          resizeToAvoidBottomInset: true,
          appBar: const MyAppBar(titleText: 'Admin 5'),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: bloc.messages.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: bloc.messages[bloc.messages.length - index - 1].typeUser
                          ? bloc.user != null
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start
                          : bloc.user != null
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: bloc.messages[bloc.messages.length - index - 1].typeUser
                                ? bloc.user != null
                                    ? AppColors.purple
                                    : AppColors.purpleAccent
                                : bloc.user != null
                                    ? AppColors.purpleAccent
                                    : AppColors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // #massage_text
                              Text(
                                bloc.messages[bloc.messages.length - index - 1].msg,
                                style: AppTextStyles.style8(context),
                              ),
                              // #date_time
                              Text(
                                bloc.messages[bloc.messages.length - index - 1].dateTime,
                                style: AppTextStyles.style8(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // #text_field
              ChatTextField(
                controller: bloc.controller,
                emojis: bloc.emojis,
                showEmojis: bloc.showEmojis,
                pressEmoji: ({required String emoji}) => bloc.add(ChatEmojiEvent(emoji: emoji)),
                pressEmojiButton: () => bloc.add(ChatEmojiButtonEvent()),
                pressSendButton: () => bloc.add(ChatSendButtonEvent()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChatTextField extends StatelessWidget {
  final bool showEmojis;
  final TextEditingController controller;
  final List<String> emojis;
  final void Function() pressSendButton;
  final void Function() pressEmojiButton;
  final void Function({required String emoji}) pressEmoji;

  const ChatTextField(
      {required this.showEmojis,
      required this.controller,
      required this.emojis,
      required this.pressSendButton,
      required this.pressEmojiButton,
      required this.pressEmoji,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showEmojis)
          Container(
            height: 200,
            decoration: BoxDecoration(color: AppColors.black, border: Border.all(color: AppColors.purple)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 50,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return IconButton(
                  onPressed: () => pressEmoji(emoji: emojis[index]),
                  icon: Text(
                    emojis[index],
                    style: const TextStyle(fontSize: 28),
                  ),
                );
              },
            ),
          ),
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: AppColors.purple),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => pressEmojiButton(),
                icon: const Icon(Icons.emoji_emotions),
                color: AppColors.purple,
              ),
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 6,
                  controller: controller,
                  cursorColor: AppColors.purple,
                  style: AppTextStyles.style9(context),
                  decoration: InputDecoration(
                      hintText: 'write_msg'.tr(),
                      hintStyle: AppTextStyles.style25(context),
                      fillColor: AppColors.black,
                      filled: true,
                      border: InputBorder.none),
                ),
              ),
              IconButton(
                onPressed: () => pressSendButton(),
                icon: const Icon(Icons.send),
                color: AppColors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
