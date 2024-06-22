part of 'test_bloc.dart';

sealed class TestState extends Equatable {
  const TestState();
}

final class TestInitialState extends TestState {
  @override
  List<Object> get props => [];
}
