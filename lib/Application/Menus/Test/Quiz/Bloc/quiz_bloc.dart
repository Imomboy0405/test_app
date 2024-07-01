import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/Bloc/test_detail_bloc.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Data/Models/quiz_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  MainBloc mainBloc;
  int currentQuiz = 1;
  int percent = 0;
  int selectedValue = 0;
  List<int> answers = [];
  List<QuizModel> quizModels = [];
  ScrollController quizNumberController = ScrollController();
  double animatePosLeft = 90;
  double animatePosTop = 50;
  double animatePosLeft2 = 30;
  double animatePosTop2 = 30;
  double animatePosLeftMini = 70;
  double animatePosTopMini = 200;
  int result = -1;
  String resultText = '';
  bool? confetti;

  QuizBloc({required this.mainBloc})
      : super(const QuizInitialState(
          currentQuiz: 1,
          percent: 0,
          selectedValue: 0,
          result: -1,
          quizModels: [],
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
    ));
  }

  void initialData(InitialQuestionsEvent event, Emitter<QuizState> emit) {
    switch (locator<TestDetailBloc>().asset) {
      case 1:
        {
          quizModels = createQuizModelList(quizModelJsonStr1);
          answers = List.filled(quizModels.length, 0);
          break;
        }
      case 2:
        {
          quizModels = createQuizModelList(quizModelJsonStr1);
          answers = List.filled(quizModels.length, 0);
          break;
        }
      default:
        {
          quizModels = createQuizModelList(quizModelJsonStr1);
          answers = List.filled(quizModels.length, 0);
          break;
        }
    }
    emitInitial(emit);
  }

  void selectQuizNumber(SelectQuizNumberEvent event, Emitter<QuizState> emit) {
    currentQuiz = event.quizNumber;
    selectedValue = answers[event.quizNumber - 1];
    percent = answers.where((answer) => answer != 0).length * 100 ~/ answers.length;
    emitInitial(emit);
  }

  void selectVariant(SelectVariantEvent event, Emitter<QuizState> emit) {
    if (selectedValue != event.value) {
      if (selectedValue == 0) {
        selectedValue = event.value;
        answers[currentQuiz - 1] = selectedValue;
        percent = answers.where((answer) => answer != 0).length * 100 ~/ answers.length;
        updateAnimate();
      } else {
        selectedValue = event.value;
        answers[currentQuiz - 1] = selectedValue;
      }
      emitInitial(emit);
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
          if (event.context.mounted) {
            Navigator.pushNamed(event.context, '/chat_detail_page');
            final ChatBloc chatBloc = locator<ChatBloc>();

            chatBloc.controller.text = resultText;
            chatBloc.add(ChatSendButtonEvent());
          }
        }
      case MiniButton.view:
        {
          currentQuiz = 1;
          selectedValue = answers[0];
          emitInitial(emit);
        }
      default:
        {
          answers = List.filled(quizModels.length, 0);
          currentQuiz = 1;
          percent = 0;
          result = -1;
          confetti = null;
          selectedValue = 0;
          emitInitial(emit);
        }
    }
  }

  void pressNext(NextButtonEvent event, Emitter<QuizState> emit) async {
    if (answers.contains(0)) {
      if (currentQuiz < answers.lastIndexOf(0) + 1) {
        currentQuiz = answers.indexOf(0, currentQuiz) + 1;
      } else {
        currentQuiz = answers.indexOf(0) + 1;
      }
      selectedValue = 0;
      if (currentQuiz * 55 > quizNumberController.offset + 359) {
        quizNumberController.animateTo(currentQuiz * 55 - 359, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      } else if (currentQuiz * 55 - 55 < quizNumberController.offset) {
        quizNumberController.animateTo(currentQuiz * 55 - 55, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      }
      emitInitial(emit);
    } else {
      if (state is QuizFinishState) {
        Navigator.pop(event.context);
        Navigator.pop(event.context);
      } else {
        if (result == -1) {
          result = 0;
          for (int i = 0; i < quizModels.length; i++) {
            result += quizModels[i].answers[answers[i] - 1].value;
            resultText += '${'question'.tr()} №${i + 1}:\n${quizModels[i].question}\n'
                '${'answer'.tr()}: ${quizModels[i].answers[answers[i] - 1].value} ${'ball'.tr()}. '
                '${quizModels[i].answers[answers[i] - 1].title}\n';
          }
          result = (result / (answers.length * 3) * 100).toInt();
          resultText += '\n${'result'.tr()}: $result / 100';
          mainBloc.resultTests[locator<TestDetailBloc>().asset - 1] = result;
          DBService.saveTest(mainBloc.resultTests);
        }
        emit(const QuizFinishState(confetti: false));
        if (confetti == null) {
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
    animatePosLeft = animatePosLeft == 90 ? 40 : 90;
    animatePosTop = animatePosTop == 50 ? 35 : 50;
    animatePosLeft2 = animatePosLeft2 == 30 ? 100 : 30;
    animatePosTop2 = animatePosTop2 == 30 ? 80 : 30;
    animatePosLeftMini = animatePosLeftMini == 70 ? 250 : 70;
    animatePosTopMini = animatePosTopMini == 200 ? 60 : 200;
  }
}
