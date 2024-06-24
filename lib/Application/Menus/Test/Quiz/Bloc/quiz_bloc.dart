import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  MainBloc mainBloc;
  int currentQuiz = 1;
  int percent = 0;
  int selectedValue = 0;
  List<int> answers = List.filled(10, 0);
  ScrollController quizNumberController = ScrollController();
  double animatePosLeft = 90;
  double animatePosTop = 50;
  double animatePosLeft2 = 30;
  double animatePosTop2 = 30;
  double animatePosLeftMini = 70;
  double animatePosTopMini = 200;
  int result = -1;
  bool? confetti;

  QuizBloc({required this.mainBloc}) : super(const QuizInitialState(currentQuiz: 1, percent: 0, selectedValue: 0, result: -1)) {
    on<SelectQuizNumberEvent>(selectQuizNumber);
    on<SelectVariantEvent>(selectVariant);
    on<NextButtonEvent>(pressNext);
    on<MiniButtonEvent>(pressMiniButton);
  }

  void emitInitial(Emitter<QuizState> emit) {
    emit(QuizInitialState(currentQuiz: currentQuiz, percent: percent, selectedValue: selectedValue, result: result));
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
      case MiniButton.home: {
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        await Future.delayed(const Duration(milliseconds: 250));
        mainBloc.add(MainMenuButtonEvent(index: 0));
      }
      case MiniButton.chat: {
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        await Future.delayed(const Duration(milliseconds: 250));
        mainBloc.add(MainMenuButtonEvent(index: 2));
      }
      case MiniButton.view: {
        currentQuiz = 1;
        selectedValue = answers[currentQuiz - 1];
        emitInitial(emit);
      }
      default: {
        answers = List.filled(10, 0);
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
          result = 95;
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
