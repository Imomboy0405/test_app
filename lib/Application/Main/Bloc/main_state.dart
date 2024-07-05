part of 'main_bloc.dart';

@immutable
abstract class MainState extends Equatable {}

class MainInitialState extends MainState {
  final int screen;
  final Language lang;
  final bool darkMode;
  final List<int> resultTests;

  MainInitialState({
    required this.screen,
    required this.lang,
    required this.darkMode,
    required this.resultTests,
  });

  @override
  List<Object?> get props => [screen, lang, darkMode, resultTests];
}

class MainHideBottomNavigationBarState extends MainState {
  @override
  List<Object?> get props => [];
}
