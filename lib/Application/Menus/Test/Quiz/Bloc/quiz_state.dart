part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();
}

final class QuizInitialState extends QuizState {
  final int currentQuiz;
  final int percent;
  final int selectedValue;
  final int result;

  const QuizInitialState({required this.currentQuiz, required this.percent, required this.selectedValue, required this.result});

  @override
  List<Object> get props => [currentQuiz, percent, selectedValue, result];
}

final class QuizFinishState extends QuizState {
  final bool confetti;

  const QuizFinishState({required this.confetti});

  @override
  List<Object> get props => [confetti];
}
