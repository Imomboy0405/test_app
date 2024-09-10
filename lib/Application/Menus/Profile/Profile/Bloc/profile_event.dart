part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class InitialUserEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class LanguageEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ConfirmLanguageEvent extends ProfileEvent {
  final Language lang;

  ConfirmLanguageEvent({required this.lang});

  @override
  List<Object?> get props => [lang];
}

class CancelEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class DoneEvent extends ProfileEvent {
  final BuildContext context;

  DoneEvent ({required this.context});

  @override
  List<Object?> get props => [context];
}

class ProfileUpdateEvent extends ProfileEvent {
  final BuildContext context;

  ProfileUpdateEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class DarkModeEvent extends ProfileEvent {
  final bool darkMode;

  DarkModeEvent({required this.darkMode});

  @override
  List<Object?> get props => [darkMode];
}

class SoundEvent extends ProfileEvent {
  final bool sound;

  SoundEvent({required this.sound});

  @override
  List<Object?> get props => [sound];
}

class SignOutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class DeleteAccountEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ConfirmEvent extends ProfileEvent {
  final BuildContext context;
  final bool delete;
  final bool tutorial;

  ConfirmEvent({required this.context, this.delete = false, this.tutorial = false});

  @override
  List<Object?> get props => [context, delete, tutorial];
}

class TutorialEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class InfoEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class NextEvent extends ProfileEvent {
  final int index;
  final BuildContext context;
  final List<Map<String, dynamic>> values;

  NextEvent({required this.index, required this.context, this.values = const []});

  @override
  List<Object?> get props => [index, context, values];

}

class ListenScrollEvent extends ProfileEvent {
  final BuildContext context;

  ListenScrollEvent({required this.context});

  @override
  List<Object?> get props => [context];

}

class UpdateDetailEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];

}

class ProfileShowCaseEvent extends ProfileEvent {
  final BuildContext context;

  ProfileShowCaseEvent({required this.context});

  @override
  List<Object?> get props => [context];
}