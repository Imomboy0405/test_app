part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {}

class FlagEvent extends SignInEvent {
  final BuildContext context;

  FlagEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SelectLanguageEvent extends SignInEvent {
  final Language lang;
  final BuildContext context;

  SelectLanguageEvent({required this.lang, required this.context});

  @override
  List<Object?> get props => [lang, context];
}

class SignInChangeEvent extends SignInEvent {
  @override
  List<Object?> get props => [];
}

class OnSubmittedEvent extends SignInEvent {
  final bool password;

  OnSubmittedEvent({this.password = false});

  @override
  List<Object?> get props => [password];
}

class SignInButtonEvent extends SignInEvent {
  final BuildContext context;

  SignInButtonEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class EmailButtonEvent extends SignInEvent {
  final double width;

  EmailButtonEvent({required this.width});
  @override
  List<Object?> get props => [width];
}

class ForgotPasswordEvent extends SignInEvent {
  @override
  List<Object?> get props => [];
}

class FaceBookEvent extends SignInEvent {
  final BuildContext context;

  FaceBookEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class GoogleEvent extends SignInEvent {
  final double width;
  final BuildContext context;

  GoogleEvent({required this.width, required this.context});

  @override
  List<Object?> get props => [width, context];
}

class SignUpEvent extends SignInEvent {
  final BuildContext context;

  SignUpEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class RememberMeEvent extends SignInEvent {
  @override
  List<Object?> get props => [];
}

class EyeEvent extends SignInEvent {
  @override
  List<Object?> get props => [];
}