import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  static const id = '/test_page';

  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
    );
  }
}
