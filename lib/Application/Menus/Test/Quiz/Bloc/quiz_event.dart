part of 'quiz_bloc.dart';
enum MiniButton  {home, chat, view, again}

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
  final BuildContext context;

  const NextButtonEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class MiniButtonEvent extends QuizEvent {
  final MiniButton miniButton;
  final BuildContext context;

  const MiniButtonEvent({required this.miniButton, required this.context});

  @override
  List<Object?> get props => [miniButton, context];
}
