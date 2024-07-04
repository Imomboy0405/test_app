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

class ShowCaseEvent extends TestDetailEvent {
  final BuildContext context;

  const ShowCaseEvent({required this.context});

  @override
  List<Object?> get props => [context];
}