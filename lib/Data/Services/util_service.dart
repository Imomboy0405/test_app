import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:vibration/vibration.dart';

class Utils {
  static Future<Object> mySnackBar({
    required String txt,
    required BuildContext context,
    bool errorState = false,
  }) async {
    if (locator<MainBloc>().sound) {
      final player = AudioPlayer();
      if (errorState) {
        player.play(AssetSource('sounds/sound_error.wav'));
      } else {
        player.play(AssetSource('sounds/sound_success.wav'));
      }
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 300, amplitude: 64);
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        content: Container(
          width: MediaQuery.of(context).size.width - 100,
          constraints: const BoxConstraints(
            minHeight: 44,
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 80),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: errorState ? AppColors.red : AppColors.pink, borderRadius: BorderRadius.circular(6)),
          child: Text(txt, style: AppTextStyles.style13(context).copyWith(color: Colors.white), textAlign: TextAlign.center),
        ),
      ),
    );
    }
    return const SizedBox.shrink();
  }
}
