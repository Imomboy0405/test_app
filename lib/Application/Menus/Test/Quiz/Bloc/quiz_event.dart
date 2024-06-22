part of 'quiz_bloc.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();
}

class SelectQuizNumberEvent extends QuizEvent {
  final int quizNumber;

  const SelectQuizNumberEvent({required this.quizNumber});

  @override
  List<Object?> get props => [quizNumber];
}

class SelectVariantEvent extends QuizEvent {
  final int value;

  const SelectVariantEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class NextButtonEvent extends QuizEvent {
  @override
  List<Object?> get props => [];
}
