import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
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
          appBar: bloc.users.isEmpty
              ? null
              : MyAppBar(
                  titleText: bloc.user!.fullName!,
                  titleTap: () => bloc.add(ChatPushInfoEvent(userModel: bloc.user!, context: context)),
                ),
          body: Column(
            children: [
              bloc.messages != null
                  ? Expanded(
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: bloc.messages!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: bloc.messages![bloc.messages!.length - index - 1].typeUser
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
                                  color: bloc.messages![bloc.messages!.length - index - 1].typeUser
                                      ? bloc.user != null
                                          ? AppColors.purple
                                          : AppColors.darkPink
                                      : bloc.user != null
                                          ? AppColors.darkPink
                                          : AppColors.purple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // #massage_text
                                    Text(
                                      bloc.messages![bloc.messages!.length - index - 1].msg,
                                      style: AppTextStyles.style8(context).copyWith(color: AppColors.whiteConst),
                                    ),
                                    // #date_time
                                    Text(
                                      bloc.messages![bloc.messages!.length - index - 1].dateTime,
                                      style: AppTextStyles.style8(context).copyWith(color: AppColors.whiteConst),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        reverse: true,
                        children: [
                          buildShimmer(false),
                          buildShimmer(true),
                          buildShimmer(false),
                          buildShimmer(true),
                          buildShimmer(true),
                          buildShimmer(false),
                          buildShimmer(true),
                        ],
                      ),
                    ),

              // #text_field
              ChatTextField(
                controller: bloc.controller,
                focusNode: bloc.focusNode,
                emojis: bloc.emojis,
                showEmojis: bloc.showEmojis,
                pressEmoji: ({required String emoji}) => bloc.add(ChatEmojiEvent(emoji: emoji)),
                pressEmojiButton: () => bloc.add(ChatEmojiButtonEvent()),
                pressSendButton: () => bloc.add(ChatSendButtonEvent()),
                onTap: () => (),
              ),
              if (bloc.focus && bloc.user == null) const SizedBox(height: 83),
            ],
          ),
        );
      },
    );
  }
}

Shimmer buildShimmer(bool userMsg, [bool chat = false]) {
  return Shimmer.fromColors(
    baseColor: AppColors.purple,
    highlightColor: AppColors.purpleAccent,
    child: Container(
      height: userMsg ? 50 : 80,
      margin: chat ? null : EdgeInsets.fromLTRB(userMsg ? 100 : 10, 5, userMsg ? 10 : 100, 5),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

class ChatTextField extends StatelessWidget {
  final bool showEmojis;
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> emojis;
  final void Function() pressSendButton;
  final void Function() pressEmojiButton;
  final void Function() onTap;
  final void Function({required String emoji}) pressEmoji;

  const ChatTextField(
      {required this.showEmojis,
      required this.controller,
      required this.emojis,
      required this.pressSendButton,
      required this.pressEmojiButton,
      required this.pressEmoji,
      required this.onTap,
      required this.focusNode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          height: showEmojis ? 220 : 0,
          decoration: BoxDecoration(color: AppColors.black, border: Border.all(color: AppColors.purple, width: 1)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(bottom: 55),
          child: GridView.builder(
            padding: EdgeInsets.zero,
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
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 6,
                  controller: controller,
                  cursorColor: AppColors.purple,
                  style: AppTextStyles.style9(context),
                  onTap: () => onTap(),
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
