import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/Quiz/Bloc/quiz_bloc.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'dart:math' as math;

import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';

class QuizPage extends StatelessWidget {
  static const id = '/quiz_page';

  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = locator<MainBloc>();
    return BlocProvider(
      create: (context) => QuizBloc(mainBloc: mainBloc),
      child: BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
        final QuizBloc bloc = context.read<QuizBloc>();
        final double width = MediaQuery.of(context).size.width;

        if (bloc.quizModels.isEmpty) {
          bloc.add(InitialQuestionsEvent(width: width));
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: SingleChildScrollView(
              child: SizedBox(
                height: state is QuizInitialState ? width * 1.8 : width * 2,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(width * .05),
                        bottomRight: Radius.circular(width * .05),
                      ),
                      child: Container(
                        height: width,
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
                        height: width + 60,
                        width: width,
                        repeat: false,
                        animate: state is QuizFinishState && (bloc.confetti ?? false),
                      ),
                    ),

                    if (state is QuizInitialState)
                      SizedBox(
                        width: width,
                        height: width - 50,
                        child: Stack(
                          children: [
                            // #line_img
                            Padding(
                              padding: EdgeInsets.only(left: width * .7, top: width * .1),
                              child: Image(
                                image: const AssetImage('assets/images/img_line.png'),
                                height: width * .18,
                                width: width * .09,
                                color: AppColors.black,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: width * .35, left: width * .12),
                              child: Image(
                                image: const AssetImage('assets/images/img_line.png'),
                                height: width * .18,
                                width: width * .09,
                                color: AppColors.black,
                              ),
                            ),

                            // #circle_grass_containers
                            AnimatedPositioned(
                              left: bloc.animatePosLeft2 * width,
                              top: bloc.animatePosTop2 * width,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutBack,
                              child: const MyCircleGlassContainer(isStartPage: false),
                            ),
                            AnimatedPositioned(
                              left: bloc.animatePosLeftMini * width,
                              top: bloc.animatePosTopMini * width,
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.fastEaseInToSlowEaseOut,
                              child: const MyCircleGlassContainer(isStartPage: false, mini: true),
                            ),
                            AnimatedPositioned(
                              left: bloc.animatePosLeft * width,
                              top: bloc.animatePosTop * width,
                              curve: Curves.easeInOutBack,
                              duration: const Duration(milliseconds: 600),
                              child: AvatarGlow(
                                glowColor: AppColors.black,
                                animate: bloc.percent == 100,
                                glowRadiusFactor: 0.2,
                                child: MyCircleGlassContainer(isStartPage: false, transparent: bloc.percent != 100),
                              ),
                            ),

                            // #test_percent
                            AnimatedPositioned(
                              left: bloc.animatePosLeft * width + width * .09 + width * width * .00005,
                              top: bloc.animatePosTop * width + width * .15,
                              curve: Curves.easeInOutBack,
                              duration: const Duration(milliseconds: 600),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(width * .044, 0, 0, 0),
                                    child: CircularProgressIndicator(
                                      value: bloc.percent / 100,
                                      color: AppColors.green,
                                      backgroundColor: AppColors.black,
                                      strokeAlign: math.sqrt(width * .17),
                                      strokeWidth: width * .025,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.2,
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
                      ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(width * .04, width * .6, width * .04, width * .04),
                      child: Column(
                        children: [
                          if (state is QuizInitialState)
                            Column(
                              children: [
                                // #quiz_number_buttons_quiz_text
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  height: width * .38,
                                  decoration: BoxDecoration(
                                    color: AppColors.transparentBlack,
                                    borderRadius: BorderRadius.circular(width * .04),
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
                                    borderRadius: BorderRadius.circular(width * .04),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // #quiz_number_buttons
                                          Container(
                                            padding: const EdgeInsets.only(top: 10),
                                            height: width * .19,
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
                                                          maximumSize: Size(width * .13, width * .13),
                                                          minimumSize: Size(width * .13, width * .13),
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
                                                        onPressed: () =>
                                                            bloc.currentQuiz != i + 1 ? bloc.add(SelectQuizNumberEvent(quizNumber: i + 1)) : (),
                                                        child: Text(
                                                          (i + 1).toString(),
                                                          style: i + 1 == bloc.currentQuiz || bloc.answers[i] != 0
                                                              ? AppTextStyles.style4_1(context)
                                                              : AppTextStyles.style7_0(context),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: width * .01,
                                                        width: width * .14,
                                                        margin: const EdgeInsets.only(top: 5),
                                                        color: bloc.currentQuiz == i + 1 ? AppColors.pink : AppColors.black,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                                          const Spacer(),

                                          // #quiz_text
                                          AnimatedOpacity(
                                            opacity: bloc.opacityAnime,
                                            duration: const Duration(milliseconds: 300),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Text(
                                                bloc.opacityAnime == 0
                                                    ? '${bloc.oldQuiz}/${bloc.answers.length} ${bloc.quizModels[bloc.oldQuiz - 1].question.tr()}'
                                                    : '${bloc.currentQuiz}/${bloc.answers.length} ${bloc.quizModels[bloc.currentQuiz - 1].question.tr()}',
                                                style: AppTextStyles.style16(context),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: width * .02),

                                // #variants
                                for (int i = 1; i <= 4; i++)
                                  Builder(
                                    builder: (context) {
                                      return MyQuizButton(
                                        key: Key('${bloc.currentQuiz}'),
                                        animeRight: bloc.currentQuiz > bloc.oldQuiz,
                                        text: bloc.quizModels[bloc.currentQuiz - 1].answers[i - 1].title.tr(),
                                        value: i,
                                        groupValue: bloc.selectedValue,
                                        onChanged: (int? value) => bloc.add(SelectVariantEvent(
                                          value: value!,
                                          ball: bloc.quizModels[bloc.currentQuiz - 1].answers[i - 1].value,
                                          context: context,
                                        )),
                                        ball: bloc.result != -1 ? bloc.quizModels[bloc.currentQuiz - 1].answers[i - 1].value.toString() : null,
                                        selected: bloc.answers[bloc.currentQuiz - 1] != 0 && bloc.answers[bloc.currentQuiz - 1] != i,
                                      );
                                    }
                                  ),
                              ],
                            ),

                          Visibility(
                            visible: state is QuizFinishState,
                            child: SizedBox(
                              height: width * 1.23,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // #mini_buttons
                                  Column(
                                    children: [
                                      SizedBox(height: width * .43),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          quizPageMiniButton(
                                            context: context,
                                            assetIcon: 'assets/icons/ic_menu_home.svg',
                                            text: 'return_home'.tr(),
                                            onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.home, context: context)),
                                            width: width,
                                          ),
                                          quizPageMiniButton(
                                            context: context,
                                            assetIcon: 'assets/icons/ic_eye.svg',
                                            text: 'view_answers'.tr(),
                                            onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.view, context: context)),
                                            width: width,
                                          ),
                                          quizPageMiniButton(
                                            context: context,
                                            assetIcon: 'assets/icons/ic_play_again.svg',
                                            text: 'play_again'.tr(),
                                            onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.again, context: context)),
                                            width: width,
                                          ),
                                          quizPageMiniButton(
                                            context: context,
                                            assetIcon: 'assets/icons/ic_menu_chat.svg',
                                            text: 'share_chat'.tr(),
                                            onPressed: () => bloc.add(MiniButtonEvent(miniButton: MiniButton.chat, context: context)),
                                            width: width,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // #anime_result
                                  Positioned(
                                    top: width * .53,
                                    child: Lottie.asset(
                                      'assets/animations/anime_result_${(bloc.result - 1) ~/ 20 + 1}.json',
                                      width: width * .8,
                                      repeat: false,
                                      animate: bloc.confetti,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // #next_button
                          Visibility(
                            visible: state is QuizInitialState,
                            child: SizedBox(height: width * .04),
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
              ),
            ),
          );
        }
      }),
    );
  }

  MaterialButton quizPageMiniButton({
    required BuildContext context,
    required Function() onPressed,
    required String assetIcon,
    required String text,
    required double width,
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
          Container(
            height: width * .1,
            width: width * .1,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.purple,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(assetIcon),
          ),
          // #text
          SizedBox(
            width: width / 5,
            child: Text(
              text,
              maxLines: 3,
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
  final bool selected;
  final bool animeRight;

  const MyQuizButton({
    super.key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.ball,
    required this.selected,
    required this.animeRight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      delay: const Duration(milliseconds: 50),
      position: value,
      child: SlideAnimation(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        horizontalOffset: MediaQuery.of(context).size.width / (animeRight ? 2 : -2),
        verticalOffset: 0.0,
        child: FlipAnimation(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          flipAxis: FlipAxis.y,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * .02),
            child: Container(
              height: MediaQuery.of(context).size.width * .1,
              decoration: BoxDecoration(
                color: groupValue == value ? AppColors.pink : AppColors.transparentBlack,
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .04),
                border: groupValue == value ? null : Border.all(color: AppColors.black),
                boxShadow: [
                  BoxShadow(color: AppColors.pink.withOpacity(0.3), blurRadius: 5, spreadRadius: 2, offset: const Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * .04),
                child: MaterialButton(
                  splashColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.pink,
                  highlightColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.pink,
                  onPressed: () => ball != null ? null : onChanged(value),
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .03),
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
                      Transform.scale(
                        scale: MediaQuery.of(context).size.width / 500,
                        child: Radio<int>(
                          value: value,
                          groupValue: groupValue,
                          onChanged: (v) => ball != null ? null : onChanged(v),
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            if (selected) {
                              return AppColors.transparent;
                            } else if (states.contains(WidgetState.selected)) {
                              return AppColors.black;
                            } else {
                              return AppColors.purple;
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      ..color = Colors.white.withOpacity(.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .07;
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
      ..strokeWidth = size.width * .06;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.34159265359,
      arcAngle,
      false,
      progressPaint,
    );

    final borderPaint = Paint()
      // #draw_circle
      ..color = Colors.white.withOpacity(.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .005;
    canvas.drawCircle(center, size.width * .17, borderPaint);

    final circlePaint = Paint()
      ..color = AppColors.pink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * .166, circlePaint);

    // $draw_texts
    _drawText(canvas, center, radius, '0', 2.24159265359, -size.width * .05, size.width * .01);
    _drawText(canvas, center, radius, '20', 2.24159265359 + 4.74159265359 / 5, 0, -size.width * .06);
    _drawText(canvas, center, radius, '40', 2.24159265359 + 4.74159265359 * 2 / 5, -size.width * .04, size.width * .01);
    _drawText(canvas, center, radius, '60', 2.24159265359 + 4.74159265359 * 3 / 5, -size.width * .04, size.width * .1);
    _drawText(canvas, center, radius, '80', 2.24159265359 + 4.74159265359 * 4 / 5, 0, -size.width * .06);
    _drawText(canvas, center, radius, '100', 2.24159265359 + 4.74159265359, size.width * .01, -size.width * .1);
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
      colors: [AppColors.purpleAccent, AppColors.pink],
      begin: begin,
      end: end,
    );

    final thickPaint = Paint()
      ..shader = gradient.createShader(Rect.fromPoints(pointerStart, pointerEnd))
      ..strokeWidth = size.width * .045
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

    canvas.drawCircle(pointerEnd, size.width * .018, thinPaint..style = PaintingStyle.fill);
  }

  void _drawText(Canvas canvas, Offset center, double radius, String text, double angle, double verticalOffset, double horizontalOffset,
      {bool result = false}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: result
            ? AppTextStyles.style12(context).copyWith(color: Colors.white)
            : AppTextStyles.style18(context).copyWith(color: Colors.white),
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
