part of 'test_detail_bloc.dart';

sealed class TestDetailEvent extends Equatable {
  const TestDetailEvent();
}

class StartTestEvent extends TestDetailEvent {
  final BuildContext context;
  const StartTestEvent({ required this.context});

  @override
  List<Object?> get props => [ context];
}

class TestDetailShowCaseEvent extends TestDetailEvent {
  final BuildContext context;

  const TestDetailShowCaseEvent({required this.context});

  @override
  List<Object?> get props => [context];
}