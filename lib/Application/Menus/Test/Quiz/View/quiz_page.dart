import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/Quiz/Bloc/quiz_bloc.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'dart:math' as math;

import 'package:test_app/Data/Services/locator_service.dart';

class QuizPage extends StatelessWidget {
  static const id = '/quiz_page';

  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = locator<MainBloc>();
    return BlocProvider(
      create: (context) => QuizBloc(mainBloc: mainBloc),
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          QuizBloc bloc = context.read<QuizBloc>();
          return Scaffold(
            backgroundColor: AppColors.black,
            body: Stack(
              children: [
                // #background
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 420,
                    decoration: myGradient(),
                  ),
                ),

                // #hud_progress_indicator
                Visibility(
                  visible: state is QuizFinishState,
                  child: Container(
                    padding: const EdgeInsets.only(top: 100),
                    alignment: Alignment.topCenter,
                    child: HudProgressIndicator(progress: bloc.result / 100),
                  ),
                ),

                // #anime_confetti
                Visibility(
                  visible: state is QuizFinishState && (bloc.confetti ?? false),
                  child: Lottie.asset(
                    'assets/animations/anime_confetti.json',
                    height: MediaQuery.of(context).size.width + 60,
                    width: MediaQuery.of(context).size.width,
                    repeat: false,
                    animate: state is QuizFinishState && (bloc.confetti ?? false),
                  ),
                ),

                if (state is QuizInitialState)
                  Stack(
                    children: [
                      Container(),

                      // #line_img
                      const Padding(
                        padding: EdgeInsets.only(left: 270, top: 30),
                        child: Image(
                          image: AssetImage('assets/images/img_line.png'),
                          height: 100,
                          width: 40,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 165, left: 50),
                        child: Image(
                          image: AssetImage('assets/images/img_line.png'),
                          height: 80,
                          width: 40,
                        ),
                      ),

                      // #circle_grass_containers
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        left: bloc.animatePosLeft2,
                        top: bloc.animatePosTop2,
                        child: const MyCircleGlassContainer(isStartPage: false),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        left: bloc.animatePosLeft,
                        top: bloc.animatePosTop,
                        child: AvatarGlow(
                          animate: bloc.percent == 100,
                          glowRadiusFactor: 0.2,
                          child: MyCircleGlassContainer(isStartPage: false, transparent: bloc.percent != 100),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        left: bloc.animatePosLeftMini,
                        top: bloc.animatePosTopMini,
                        child: const MyCircleGlassContainer(isStartPage: false, mini: true),
                      ),

                      // #test_percent
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        left: bloc.animatePosLeft + 52,
                        top: bloc.animatePosTop + 65,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                              child: CircularProgressIndicator(
                                value: bloc.percent / 100,
                                color: AppColors.green,
                                backgroundColor: AppColors.black,
                                strokeAlign: 8,
                                strokeWidth: 10,
                              ),
                            ),
                            SizedBox(
                              width: 79,
                              child: Text(
                                '${bloc.percent} %',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.style3_0(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 230, 15, 15),
                  child: Column(
                    children: [
                      if (state is QuizInitialState)
                        Column(
                          children: [
                            // #quiz_number_buttons_quiz_text
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: AppColors.transparentBlack,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(width: 2, color: AppColors.black),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.transparentBlack.withOpacity(.3),
                                    spreadRadius: 7,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // #quiz_number_buttons
                                      Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        height: 70,
                                        child: ListView.builder(
                                            controller: bloc.quizNumberController,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: bloc.answers.length,
                                            itemBuilder: (context, i) {
                                              return Column(
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      maximumSize: const Size(45, 45),
                                                      minimumSize: const Size(45, 45),
                                                      backgroundColor: bloc.answers[i] != 0
                                                          ? AppColors.green
                                                          : bloc.currentQuiz == i + 1
                                                              ? AppColors.pink
                                                              : AppColors.black,
                                                      shape: const CircleBorder(),
                                                      side: i + 1 != bloc.currentQuiz
                                                          ? BorderSide(
                                                              width: 2,
                                                              color: bloc.answers[i] == 0 ? AppColors.purpleAccent : AppColors.green)
                                                          : BorderSide.none,
                                                      overlayColor: AppColors.pink,
                                                    ),
                                                    onPressed: () => bloc.currentQuiz != i + 1
                                                        ? bloc.add(SelectQuizNumberEvent(quizNumber: i + 1))
                                                        : (),
                                                    child: Text(
                                                      (i + 1).toString(),
                                                      style: i + 1 == bloc.currentQuiz || bloc.answers[i] != 0
                                                          ? AppTextStyles.style4_1(context)
                                                          : AppTextStyles.style7_0(context),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 3,
                                                    width: 55,
                                                    margin: const EdgeInsets.only(top: 5),
                                                    color: bloc.currentQuiz == i + 1 ? AppColors.pink : AppColors.black,
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),

                                      // #quiz_text
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                                        child: Text(
                                          '${bloc.currentQuiz}/${bloc.answers.length} Question TitleT Title Title itlevTvi t l e T itle Title?',
                                          style: AppTextStyles.style16(context),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // #variants
                            for (int i = 1; i <= 4; i++)
                              MyQuizButton(
                                text: 'Option $i',
                                value: i,
                                groupValue: bloc.selectedValue,
                                onChanged: (int? value) => bloc.add(SelectVariantEvent(value: value!)),
                                ball: bloc.result != -1 ? '$i' : null,
                              ),
                          ],
                        ),

                      Visibility(
                        visible: state is QuizFinishState,
                        child: Column(
                          children: [
                            const SizedBox(height: 215),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                quizPageMiniButton(
                                  context: context,
                                  assetIcon: 'assets/icons/ic_menu_home.png',
                                  text: 'return_home'.tr(),
                                  onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.home, context: context)),
                                ),
                                quizPageMiniButton(
                                  context: context,
                                  assetIcon: 'assets/icons/ic_eye.png',
                                  text: 'view_answers'.tr(),
                                  onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.view, context: context)),
                                ),
                                quizPageMiniButton(
                                  context: context,
                                  assetIcon: 'assets/icons/ic_play_again.png',
                                  text: 'play_again'.tr(),
                                  onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.again, context: context)),
                                ),
                                quizPageMiniButton(
                                  context: context,
                                  assetIcon: 'assets/icons/ic_menu_chat.png',
                                  text: 'share_chat'.tr(),
                                  onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.chat, context: context)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: state is QuizFinishState,
                        child: Lottie.asset(
                          'assets/animations/anime_result_${(bloc.result - 1) ~/ 20 + 1}.json',
                          width: MediaQuery.of(context).size.width - 160,
                          repeat: false,
                          animate: bloc.confetti,
                        ),
                      ),

                      // #next_button
                      Visibility(
                        visible: state is QuizInitialState,
                        child: const Spacer(),
                      ),
                      MyButton(
                        enable: true,
                        text: bloc.answers.contains(0)
                            ? 'next'.tr()
                            : bloc.result != -1 && state is! QuizFinishState
                                ? 'result_test'.tr()
                                : state is QuizFinishState
                                    ? 'exit_test'.tr()
                                    : 'end_test'.tr(),
                        function: () => bloc.add(NextButtonEvent(context: context)),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  MaterialButton quizPageMiniButton({
    required BuildContext context,
    required Function() onPressed,
    required String assetIcon,
    required String text,
  }) {
    return MaterialButton(
      onPressed: () => onPressed(),
      padding: EdgeInsets.zero,
      splashColor: AppColors.transparentPurple,
      highlightColor: AppColors.transparentBlack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // #icon
          Image(
            image: AssetImage(assetIcon),
            height: 50,
            width: 50,
          ),
          // #text
          SizedBox(
            width: 75,
            child: Text(
              text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyles.style9(context),
            ),
          )
        ],
      ),
    );
  }
}

class MyQuizButton extends StatelessWidget {
  final String text;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;
  final String? ball;

  const MyQuizButton({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.ball,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: groupValue == value ? AppColors.pink : AppColors.transparentBlack,
          borderRadius: BorderRadius.circular(16),
          border: groupValue == value ? null : Border.all(color: AppColors.black),
          boxShadow: [
            BoxShadow(color: AppColors.pink.withOpacity(0.3), blurRadius: 5, spreadRadius: 2, offset: const Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: MaterialButton(
            splashColor: AppColors.pink,
            highlightColor: AppColors.pink,
            onPressed: () => ball != null ? null : onChanged(value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${ball != null ? "$ball ${'ball'.tr()}. " : ''}$text',
                    maxLines: 2,
                    style: groupValue == value ? AppTextStyles.style18(context) : AppTextStyles.style18_0(context),
                  ),
                ),
                Radio<int>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: (v) => ball != null ? null : onChanged(v),
                  fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                    if (ball != null) {
                      return AppColors.transparent;
                    } else if (states.contains(WidgetState.selected)) {
                      return AppColors.black;
                    } else {
                      return AppColors.purple;
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HudProgressIndicator extends StatefulWidget {
  const HudProgressIndicator({super.key, required this.progress});

  final double progress;

  @override
  State<HudProgressIndicator> createState() => _HudProgressIndicatorState();
}

class _HudProgressIndicatorState extends State<HudProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 100,
      height: MediaQuery.sizeOf(context).width / 2 - 50,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _HudProgressPainter(_animation.value, context),
          );
        },
      ),
    );
  }
}

class _HudProgressPainter extends CustomPainter {
  _HudProgressPainter(this.progress, this.context);

  final double progress;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final arcAngle = 4.74159265359 * progress;

    // #background_progress
    final backgroundPaint = Paint()
      ..color = AppColors.transparentBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.34159265359,
      4.74159265359,
      false,
      backgroundPaint,
    );

    // #progress
    final progressPaint = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 23;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.34159265359,
      arcAngle,
      false,
      progressPaint,
    );

    final borderPaint = Paint()
      // #draw_circlefinal
      ..color = AppColors.transparentBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, 46, borderPaint);

    final circlePaint = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 45, circlePaint);

    // $draw_texts
    _drawText(canvas, center, radius, '0', 2.24159265359, 0, 0);
    _drawText(canvas, center, radius, '20', 2.24159265359 + 4.74159265359 / 5, 0, -17);
    _drawText(canvas, center, radius, '40', 2.24159265359 + 4.74159265359 * 2 / 5, 3, 03);
    _drawText(canvas, center, radius, '60', 2.24159265359 + 4.74159265359 * 3 / 5, 3, 30);
    _drawText(canvas, center, radius, '80', 2.24159265359 + 4.74159265359 * 4 / 5, 0, -17);
    _drawText(canvas, center, radius, '100', 2.24159265359 + 4.74159265359, 15, -25);
    _drawText(canvas, center, 0, '${(progress * 100).toInt()} %', 2.24159265359 + 4.74159265359, 40, 10, result: true);

    // #stick
    final pointerAngle = 2.34159265359 + arcAngle;
    final pointerLength = radius * 0.82;
    const pointerStartOffset = 0.35;
    final pointerStart = Offset(
      center.dx + (radius * pointerStartOffset) * math.cos(pointerAngle),
      center.dy + (radius * pointerStartOffset) * math.sin(pointerAngle),
    );
    final pointerEnd = Offset(
      center.dx + pointerLength * math.cos(pointerAngle),
      center.dy + pointerLength * math.sin(pointerAngle),
    );

    final Alignment begin, end;
    if (progress < 0.5) {
      begin = Alignment.centerRight;
      end = Alignment.centerLeft;
    } else {
      begin = Alignment.centerLeft;
      end = Alignment.centerRight;
    }
    final gradient = LinearGradient(
      colors: const [AppColors.purpleAccent, AppColors.pink],
      begin: begin,
      end: end,
    );

    final thickPaint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(pointerStart, pointerEnd))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        pointerStart,
        Offset(
          center.dx + (pointerLength - 10) * math.cos(pointerAngle),
          center.dy + (pointerLength - 10) * math.sin(pointerAngle),
        ),
        thickPaint);

    final thinPaint = Paint()
      ..color = AppColors.pink
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(
          center.dx + (pointerLength - 10) * math.cos(pointerAngle),
          center.dy + (pointerLength - 10) * math.sin(pointerAngle),
        ),
        pointerEnd,
        thinPaint);

    const pointerTipRadius = 6.0;
    canvas.drawCircle(pointerEnd, pointerTipRadius, thinPaint..style = PaintingStyle.fill);
  }

  void _drawText(Canvas canvas, Offset center, double radius, String text, double angle, double verticalOffset, double horizontalOffset,
      {bool result = false}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: result ? AppTextStyles.style12(context) : AppTextStyles.style18(context),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      center.dx + (radius - 10 + horizontalOffset) * math.cos(angle) - textPainter.width / 2,
      center.dy + (radius - 40 + verticalOffset) * math.sin(angle) - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
