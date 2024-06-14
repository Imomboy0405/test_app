import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const id = '/home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
    );
  }
}