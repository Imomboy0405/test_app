part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();
}

final class QuizInitialState extends QuizState {
  final int currentQuiz;
  final int percent;
  final int selectedValue;
  final int result;
  final List<QuizModel> quizModels;
  final double opacityAnime;

  const QuizInitialState({
    required this.currentQuiz,
    required this.percent,
    required this.selectedValue,
    required this.result,
    required this.quizModels,
    required this.opacityAnime,
  });

  @override
  List<Object> get props => [currentQuiz, percent, selectedValue, result, quizModels, opacityAnime];
}

final class QuizFinishState extends QuizState {
  final bool confetti;

  const QuizFinishState({required this.confetti});

  @override
  List<Object> get props => [confetti];
}
