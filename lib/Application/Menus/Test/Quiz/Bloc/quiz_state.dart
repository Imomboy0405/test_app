part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();
}

final class QuizInitialState extends QuizState {
  final int currentQuiz;
  final int percent;
  final int selectedValue;

  const QuizInitialState({required this.currentQuiz, required this.percent, required this.selectedValue});

  @override
  List<Object> get props => [currentQuiz, percent, selectedValue];
}

final class QuizFinishState extends QuizState {
  @override
  List<Object> get props => [];
}
