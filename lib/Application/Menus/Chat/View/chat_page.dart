import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const id = '/chat_page';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
    );
  }
}
