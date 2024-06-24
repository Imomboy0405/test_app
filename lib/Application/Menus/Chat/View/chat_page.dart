import 'package:flutter/material.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class ChatPage extends StatelessWidget {
  static const id = '/chat_page';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(titleText: 'chat'.tr()),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 190,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
        
              Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'card_info_text_3'.tr(),
                        style: AppTextStyles.style8(context),
                      ),
                      Text(
                        '12:23',
                        style: AppTextStyles.style8(context),
                      ),
                    ],
                  )
              ),
              ChatTextField(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool showEmojis = false;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showEmojis)
          SizedBox(
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: 20, // Emoji soni
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    'Emoji ${index + 1}', // Emoji ni ko'rsatish
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
            ),
          ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  showEmojis = !showEmojis;
                });
              },
              icon: const Icon(Icons.emoji_emotions),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Xabar yozing...',
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // Xabarni yuborish logikasi
                String message = _textController.text;
                print('Yuborilgan xabar: $message');
                _textController.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}