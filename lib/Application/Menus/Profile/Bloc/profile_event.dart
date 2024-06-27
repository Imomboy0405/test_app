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

  ConfirmEvent({required this.context, this.delete = false});

  @override
  List<Object?> get props => [context, delete];
}

class InfoEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

