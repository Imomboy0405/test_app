part of 'main_bloc.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainScrollMenuEvent extends MainEvent {
  final int index;

  MainScrollMenuEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class MainMenuButtonEvent extends MainEvent {
  final int index;

  MainMenuButtonEvent({required this.index});

  @override
  List<Object?> get props => [index];
}

class MainHideBottomNavigationBarEvent extends MainEvent {
  final bool hideAll;

  MainHideBottomNavigationBarEvent({this.hideAll = false});

  @override
  List<Object?> get props => [hideAll];
}

class MainLanguageEvent extends MainEvent {

  @override
  List<Object?> get props => [];
}

class MainThemeEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class MainSoundEvent extends MainEvent {
  final bool sound;

  MainSoundEvent({required this.sound});

  @override
  List<Object?> get props => [sound];
}

class MainExitEvent extends MainEvent {

  @override
  List<Object?> get props => [];
}

class MainCancelEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class MainDoneEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}
