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

class HomeInitialDataEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class HomeShowCaseEvent extends HomeEvent {
  final BuildContext context;

  const HomeShowCaseEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class HomePressArticleEvent extends HomeEvent {
  final BuildContext context;

  const HomePressArticleEvent({required this.context});

  @override
  List<Object?> get props => [context];
}