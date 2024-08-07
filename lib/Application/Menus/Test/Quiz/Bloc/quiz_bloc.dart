import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Test/Test/Bloc/test_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/Bloc/test_detail_bloc.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Data/Models/quiz_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/util_service.dart';
import 'package:vibration/vibration.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  MainBloc mainBloc;
  int currentQuiz = 1;
  int oldQuiz = 1;
  int percent = 0;
  int selectedValue = 0;
  double opacityAnime = 1;
  List<int> answers = [];
  List<QuizModel> quizModels = [];
  ScrollController quizNumberController = ScrollController();
  ScrollController scrollController = ScrollController();
  int result = -1;
  List<List> resultList = [
    [0, 10, 'attraction', "attractionInfo_100", "attractionInfo_60"],
    [0, 20, 'excitation', "excitationInfo_100", "excitationInfo_60"],
    [0, 20, 'lubrication', "lubricationInfo_100", "lubricationInfo_60"],
    [0, 15, 'orgasm', "orgasmInfo_100", "orgasmInfo_60"],
    [0, 15, 'satisfaction', "satisfactionInfo_100", "satisfactionInfo_60"],
    [0, 15, 'pain', "painInfo_100", "painInfo_60"],
  ];
  String resultChatText = '';
  String resultText = '';
  String resultAnime = '';
  bool? confetti;
  double width = 0;

  double animatePosLeft = .15;
  double animatePosTop = .09;
  double animatePosLeft2 = .3;
  double animatePosTop2 = .17;
  double animatePosLeftMini = .13;
  double animatePosTopMini = .44;

  QuizBloc({required this.mainBloc})
      : super(const QuizInitialState(
          currentQuiz: 1,
          percent: 0,
          selectedValue: 0,
          result: -1,
          quizModels: [],
          opacityAnime: 1,
        )) {
    on<SelectQuizNumberEvent>(selectQuizNumber);
    on<SelectVariantEvent>(selectVariant);
    on<NextButtonEvent>(pressNext);
    on<MiniButtonEvent>(pressMiniButton);
    on<InitialQuestionsEvent>(initialData);
  }


  void emitInitial(Emitter<QuizState> emit) {
    emit(QuizInitialState(
      currentQuiz: currentQuiz,
      percent: percent,
      selectedValue: selectedValue,
      result: result,
      quizModels: quizModels,
      opacityAnime: opacityAnime,
    ));
  }

  void initialData(InitialQuestionsEvent event, Emitter<QuizState> emit) {
    width = event.width;
    switch (locator<TestBloc>().asset + 1) {
      case 1:
        {
          quizModels = createQuizModelList(quizModelJsonStr1);
          answers = List.filled(quizModels.length, 0);
          break;
        }
      case 2:
        {
          quizModels = createQuizModelList(quizModelJsonStr2);
          answers = List.filled(quizModels.length, 0);
          break;
        }
      default:
        {
          quizModels = createQuizModelList(quizModelJsonStr3);
          answers = List.filled(quizModels.length, 0);
          break;
        }
    }
    emitInitial(emit);
  }

  void selectQuizNumber(SelectQuizNumberEvent event, Emitter<QuizState> emit) async {
    opacityAnime = 0;
    oldQuiz = currentQuiz;
    currentQuiz = event.quizNumber;
    selectedValue = answers[event.quizNumber - 1];
    percent = answers.where((answer) => answer != 0).length * 100 ~/ answers.length;
    emitInitial(emit);
    await Future.delayed(const Duration(milliseconds: 300));
    opacityAnime = 1;
    emitInitial(emit);
  }

  void selectVariant(SelectVariantEvent event, Emitter<QuizState> emit) async {
    if (selectedValue != event.value) {
      if (selectedValue == 0) {
        if (mainBloc.sound) {
          final player = AudioPlayer();
          await player.play(AssetSource('sounds/sound_button.wav'));
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 50, amplitude: 32);
          }
        }
        selectedValue = event.value;
        answers[currentQuiz - 1] = selectedValue;
        percent = answers.where((answer) => answer != 0).length * 100 ~/ answers.length;
        updateAnimate();
        emitInitial(emit);
        if (percent != 100) {
          opacityAnime = 0;
          oldQuiz = currentQuiz;
          await Future.delayed(const Duration(milliseconds: 300));
          if (event.context.mounted) {
            add(NextButtonEvent(context: event.context, selectVariant: true));
          }
        }
      } else {
        Utils.mySnackBar(txt: 'marked_answer'.tr(), context: event.context, errorState: true, bottom: false);
      }
    }
  }

  void pressMiniButton(MiniButtonEvent event, Emitter<QuizState> emit) async {
    switch (event.miniButton) {
      case MiniButton.home:
        {
          Navigator.pop(event.context);
          Navigator.pop(event.context);
          await Future.delayed(const Duration(milliseconds: 250));
          mainBloc.add(MainMenuButtonEvent(index: 0));
        }
      case MiniButton.chat:
        {
          Navigator.pop(event.context);
          Navigator.pop(event.context);
          await Future.delayed(const Duration(milliseconds: 250));
          mainBloc.add(MainMenuButtonEvent(index: 2));
          final ChatBloc chatBloc = locator<ChatBloc>();
          chatBloc.controller.text = resultChatText;
          chatBloc.add(ChatSendButtonEvent());
        }
      case MiniButton.view:
        {
          scrollController.jumpTo(0);
          currentQuiz = 1;
          selectedValue = answers[0];
          emitInitial(emit);
        }
      default:
        {
          scrollController.jumpTo(0);
          resultList = [
            [0, 10, 'attraction', "attractionInfo_100", "attractionInfo_60"],
            [0, 20, 'excitation', "excitationInfo_100", "excitationInfo_60"],
            [0, 20, 'lubrication', "lubricationInfo_100", "lubricationInfo_60"],
            [0, 15, 'orgasm', "orgasmInfo_100", "orgasmInfo_60"],
            [0, 15, 'satisfaction', "satisfactionInfo_100", "satisfactionInfo_60"],
            [0, 15, 'pain', "painInfo_100", "painInfo_60"],
          ];
          answers = List.filled(quizModels.length, 0);
          currentQuiz = 1;
          percent = 0;
          result = -1;
          resultChatText = '';
          confetti = null;
          selectedValue = 0;
          emitInitial(emit);
        }
    }
  }

  void pressNext(NextButtonEvent event, Emitter<QuizState> emit) async {
    if (answers.contains(0)) {
      oldQuiz = currentQuiz;
      if (currentQuiz < answers.lastIndexOf(0) + 1) {
        currentQuiz = answers.indexOf(0, currentQuiz) + 1;
      } else {
        currentQuiz = answers.indexOf(0) + 1;
      }
      selectedValue = 0;
      if (currentQuiz * width * .14 > quizNumberController.offset + width * .956) {
        quizNumberController.animateTo(currentQuiz * width * .14 - width * .912, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      } else if ((currentQuiz - 1) * width * .14 < quizNumberController.offset) {
        quizNumberController.animateTo((currentQuiz - 1) * width * .14, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      }
      opacityAnime = 0;
      emitInitial(emit);
      if (!event.selectVariant) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
      opacityAnime = 1;
      emitInitial(emit);
    } else {
      if (state is QuizFinishState) {
        Navigator.pop(event.context);
        Navigator.pop(event.context);
      } else {
        scrollController.jumpTo(0);
        if (result == -1) {
          result = 0;
          if (locator<TestBloc>().asset == 0) {
            for (int i = 0; i < quizModels.length; i++) {
              resultList[quizModels[i].domain!][0] += quizModels[i].answers[answers[i] - 1].value;
              resultChatText += '${'question'.tr()} №${i + 1}:\n${quizModels[i].question.tr()}\n'
                  '${'answer'.tr()}: ${quizModels[i].answers[answers[i] - 1].title.tr()}\n';
            }
            for (int i = 0; i < resultList.length; i++) {
              if (resultList[i][0] / resultList[i][1] < .6) {
                resultList[i][3] = resultList[i][4];
              }
              resultChatText += '\n${resultList[i][2].toString().tr()}: ${resultList[i][0] ~/ resultList[i][1] * 100} %';
            }
          } else {
            for (int i = 0; i < quizModels.length; i++) {
              result += quizModels[i].answers[answers[i] - 1].value;
              resultChatText += '${'question'.tr()} №${i + 1}:\n${quizModels[i].question.tr()}\n'
                  '${'answer'.tr()}: ${quizModels[i].answers[answers[i] - 1].title.tr()}\n';
            }
            result = (result / (answers.length * 3) * 100).toInt();
            resultChatText += '\n${'result'.tr()}: $result / 100';
          }
          initialResults();
          mainBloc.resultTests = List.from(mainBloc.resultTests);
          mainBloc.resultTests[locator<TestDetailBloc>().asset] = result;
          mainBloc.add(MainLanguageEvent());
          DBService.saveTest(mainBloc.resultTests);
        }
        emit(const QuizFinishState(confetti: false));

        if (confetti == null) {
          if (mainBloc.sound) {
            final player = AudioPlayer();
            await player.play(AssetSource('sounds/sound_confetti.wav'));
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 500, amplitude: 64);
            }
          }
          await Future.delayed(const Duration(milliseconds: 350), () {
            confetti = true;
          }).whenComplete(() => emit(QuizFinishState(confetti: confetti!)));
        } else {
          confetti = false;
          emit(QuizFinishState(confetti: confetti!));
        }
      }
    }
  }

  void updateAnimate() {
    animatePosLeft = animatePosLeft == .15 ? .35 : .15;
    animatePosTop = animatePosTop == .09 ? .17 : .09;
    animatePosLeft2 = animatePosLeft2 == .3 ? .2 : .3;
    animatePosTop2 = animatePosTop2 == .17 ? .08 : .17;
    animatePosLeftMini = animatePosLeftMini == .13 ? .64 : .13;
    animatePosTopMini = animatePosTopMini == .44 ? .1 : .44;
  }

  void initialResults() {
    switch (locator<TestBloc>().asset) {
      case 1: {
        if (result >= 50) {
          resultText = 'result_test_1_ball_50';
          resultAnime = 'assets/animations/anime_result_1.json';
          return;
        }
        if (result >= 29) {
          resultText = 'result_test_1_ball_29';
          resultAnime = 'assets/animations/anime_result_2.json';
          return;
        }
        if (result >= 19) {
          resultText = 'result_test_1_ball_19';
          resultAnime = 'assets/animations/anime_result_3.json';
          return;
        }
        if (result >= 15) {
          resultText = 'result_test_1_ball_15';
          resultAnime = 'assets/animations/anime_result_4.json';
          return;
        }
        resultText = 'result_test_1_ball_9';
        resultAnime = 'assets/animations/anime_result_5.json';
        return;
      }
      case 2: {
        if (result >= 59) {
          resultText = 'result_test_2_ball_59';
          resultAnime = 'assets/animations/anime_result_2.json';
          return;
        }
        if (result >= 58) {
          resultText = 'result_test_2_ball_58';
          resultAnime = 'assets/animations/anime_result_3.json';
          return;
        }
        if (result >= 34) {
          resultText = 'result_test_2_ball_34';
          resultAnime = 'assets/animations/anime_result_4.json';
          return;
        }
        resultText = 'result_test_2_ball_11';
        resultAnime = 'assets/animations/anime_result_5.json';
        return;
      }
      default: {
        resultText = '';
      }
    }
  }
}
