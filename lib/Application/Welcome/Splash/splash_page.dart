import 'package:flutter/material.dart';
import 'package:test_app/Configuration/app_text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Test', style: AppTextStyles.style0),
      ),
    );
  }
}