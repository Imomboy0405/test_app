part of 'test_detail_bloc.dart';

sealed class TestDetailEvent extends Equatable {
  const TestDetailEvent();
}

class StartTestEvent extends TestDetailEvent {
  final BuildContext context;
  final int index;
  const StartTestEvent({required this.index, required this.context});

  @override
  List<Object?> get props => [index, context];
}