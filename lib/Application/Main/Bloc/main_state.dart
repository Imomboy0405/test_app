part of 'main_bloc.dart';

@immutable
abstract class MainState extends Equatable {}

class MainInitialState extends MainState {
  final int screen;
  final Language lang;
  final bool darkMode;
  final bool sound;
  final List<int> resultTests;

  MainInitialState({
    required this.screen,
    required this.lang,
    required this.darkMode,
    required this.sound,
    required this.resultTests,
  });

  @override
  List<Object?> get props => [screen, lang, darkMode, resultTests, sound];
}

class MainHideBottomNavigationBarState extends MainState {
  final bool hideAll;

  MainHideBottomNavigationBarState({this.hideAll = false});

  @override
  List<Object?> get props => [hideAll];
}
