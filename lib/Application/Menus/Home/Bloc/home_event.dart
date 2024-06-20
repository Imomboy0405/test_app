part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeScrollCardEvent extends HomeEvent {
  final int page;

  const HomeScrollCardEvent({required this.page});

  @override
  List<Object?> get props => [page];
}