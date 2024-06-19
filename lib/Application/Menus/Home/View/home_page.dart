import 'package:flutter/material.dart';
import 'package:test_app/Configuration/app_colors.dart';

class HomePage extends StatelessWidget {
  static const id = '/home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink,
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
    );
  }
}
