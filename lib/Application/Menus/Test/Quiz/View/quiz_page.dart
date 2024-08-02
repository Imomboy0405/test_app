import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/Quiz/Bloc/quiz_bloc.dart';
import 'package:test_app/Application/Menus/Test/Quiz/View/quiz_widgets.dart';
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
              controller: bloc.scrollController,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(width * .05),
                          bottomRight: Radius.circular(width * .05),
                        ),
                        child: Container(
                          decoration: state is QuizInitialState ? myGradient() : BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.purpleAccent,
                                AppColors.purpleLight,
                              ],
                              begin: const Alignment(2, 0),
                              end: const Alignment(-2, 0),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // #percents
                              Visibility(
                                visible: state is QuizInitialState,
                                child: Column(
                                  children: [
                                    // #percent_animations
                                    SizedBox(
                                      width: width,
                                      height: width * .65,
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

                                    // #quiz_number_buttons_quiz_text
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(width * .04, 0, width * .04, width * .04),
                                        padding: EdgeInsets.only(bottom: width * .02),
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
                                                  padding: EdgeInsets.only(top: width * .02),
                                                  margin: EdgeInsets.only(bottom: width * .02),
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
                                                                        color: bloc.answers[i] == 0
                                                                            ? AppColors.purpleAccent
                                                                            : AppColors.green)
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
                                                              height: width * .01,
                                                              width: width * .14,
                                                              margin: const EdgeInsets.only(top: 5),
                                                              color: bloc.currentQuiz == i + 1 ? AppColors.pink : AppColors.black,
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),

                                                // #quiz_text
                                                AnimatedOpacity(
                                                  opacity: bloc.opacityAnime,
                                                  duration: const Duration(milliseconds: 300),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: width * .02),
                                                    child: Text(
                                                      bloc.opacityAnime == 0
                                                          ? '${bloc.oldQuiz}/${bloc.answers.length} ${bloc.quizModels[bloc.oldQuiz - 1].question.tr()}'
                                                          : '${bloc.currentQuiz}/${bloc.answers.length} ${bloc.quizModels[bloc.currentQuiz - 1].question.tr()}',
                                                      style: AppTextStyles.style16(context),
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 10,
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // #result_indicators_buttons
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // #hud_progress_indicator
                                      Visibility(
                                        visible: state is QuizFinishState && bloc.resultText != '',
                                        child: Padding(
                                          padding: EdgeInsets.only(top: width * .15),
                                          child: HudProgressIndicator(progress: bloc.result / 100),
                                        ),
                                      ),

                                      // #hud_progress_indicators
                                      Visibility(
                                        visible: state is QuizFinishState && bloc.resultText == '',
                                        child: Column(
                                          children: List.generate(
                                              6,
                                                  (int i) => Padding(
                                                padding: EdgeInsets.only(top: width * (i == 0 ? .15 : .04)),
                                                child: Column(
                                                  children: [
                                                    HudProgressIndicator(
                                                      progress: bloc.resultList[i][0] / bloc.resultList[i][1],
                                                    ),

                                                    // #type_text
                                                    Padding(
                                                      padding: EdgeInsets.only(top:  width * .25),
                                                      child: Text(
                                                        bloc.resultList[i][2].toString().tr(),
                                                        style: AppTextStyles.style10(context).copyWith(color: AppColors.whiteConst),
                                                      ),
                                                    ),

                                                    // #type_info
                                                    Padding(
                                                      padding: EdgeInsets.all(width * .04),
                                                      child: Text(
                                                        bloc.resultList[i][3].toString().tr(),
                                                        style: AppTextStyles.style4(context),
                                                        textAlign: TextAlign.justify,
                                                      ),
                                                    ),
                                                    if (i != 5)
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width * .04),
                                                      child: Divider(color: AppColors.whiteConst, thickness: width * .003),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),

                                      // #mini_buttons
                                      Visibility(
                                        visible: state is QuizFinishState,
                                        child: Container(
                                          margin: bloc.resultText != '' ? EdgeInsets.only(top: width * .35) : null,
                                          padding: EdgeInsets.symmetric(horizontal: width * .02),
                                          height: width * .25,
                                          child: Row(
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
                                        ),
                                      ),
                                    ],
                                  ),

                                  // #anime_confetti
                                  Visibility(
                                    visible: state is QuizFinishState && (bloc.confetti ?? false),
                                    child: Lottie.asset(
                                      'assets/animations/anime_confetti.json',
                                      height: width,
                                      width: width,
                                      repeat: false,
                                      animate: state is QuizFinishState && (bloc.confetti ?? false),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // #variants
                    for (int i = 1; i <= bloc.quizModels[bloc.currentQuiz - 1].answers.length; i++)
                      Visibility(
                        visible: state is QuizInitialState,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * .04),
                          child: Builder(builder: (context) {
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
                          }),
                        ),
                      ),

                    // #result_text
                    Visibility(
                      visible: state is QuizFinishState && bloc.resultText != '',
                      child: Padding(
                        padding: EdgeInsets.only(top: width * .02, right: width * .03, left: width * .03),
                        child: Text(
                          bloc.resultText.tr(),
                          style: AppTextStyles.style3(context).copyWith(color: AppColors.pink),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // #result_anime
                    Visibility(
                      visible: state is QuizFinishState && bloc.resultAnime != '',
                      child: Lottie.asset(
                        bloc.resultAnime,
                        width: width * .8,
                        repeat: false,
                        animate: bloc.confetti,
                      ),
                    ),

                    // #next_button
                    Visibility(
                      visible: state is QuizInitialState || (state is QuizFinishState && bloc.resultText == ''),
                      child: SizedBox(height: width * .04),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * .04),
                      child: MyButton(
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
                    ),
                    Visibility(
                      visible: state is QuizInitialState || (state is QuizFinishState && bloc.resultText == ''),
                      child: SizedBox(height: width * .04),
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

  Widget quizPageMiniButton({
    required BuildContext context,
    required Function() onPressed,
    required String assetIcon,
    required String text,
    required double width,
  }) {
    return CupertinoButton(
      onPressed: () => onPressed(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // #icon
          Container(
            height: width * .12,
            width: width * .12,
            padding: EdgeInsets.all(width * .02),
            margin: EdgeInsets.only(bottom: width * .01),
            decoration: BoxDecoration(
              color: AppColors.pink,
              borderRadius: BorderRadius.circular(width * .02),
              border: Border.all(color: AppColors.whiteConst),
            ),
            child: SvgPicture.asset(assetIcon),
          ),
          // #text
          SizedBox(
            width: width * .2,
            child: Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: AppTextStyles.style20_1(context),
            ),
          )
        ],
      ),
    );
  }
}
