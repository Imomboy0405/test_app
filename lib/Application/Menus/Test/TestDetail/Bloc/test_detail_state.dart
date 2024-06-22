part of 'test_detail_bloc.dart';

sealed class TestDetailState extends Equatable {
  const TestDetailState();
}

final class TestDetailInitialState extends TestDetailState {
  @override
  List<Object> get props => [];
}
