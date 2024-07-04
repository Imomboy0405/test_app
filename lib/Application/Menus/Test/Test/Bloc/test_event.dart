part of 'test_bloc.dart';

sealed class TestEvent extends Equatable {
  const TestEvent();
}

class EnterTestEvent extends TestEvent {
  final BuildContext context;
  final int index;

  const EnterTestEvent({required this.context, required this.index});

  @override
  List<Object?> get props => [index, context];
}


class ShowCaseEvent extends TestEvent {
  final BuildContext context;

  const ShowCaseEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
