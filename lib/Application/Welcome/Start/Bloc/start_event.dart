part of 'start_bloc.dart';

@immutable
abstract class StartEvent extends Equatable {}

class FlagEvent extends StartEvent {
  final BuildContext context;

  FlagEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class NextEvent extends StartEvent {
  final BuildContext context;

  NextEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SkipEvent extends StartEvent {
  final BuildContext context;

  SkipEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class TermsEvent extends StartEvent {
  final bool policy;

  TermsEvent({this.policy = false});

  @override
  List<Object?> get props => [policy];

}

class LoginAnimateEvent extends StartEvent {
  final bool first;
  LoginAnimateEvent({this.first = false});

  @override
  List<Object?> get props => [first];
}

class SelectLanguageEvent extends StartEvent {
  final BuildContext context;
  final Language language;

  SelectLanguageEvent({required this.context, required this.language});

  @override
  List<Object?> get props => [context, language];

}

class UpdateAnimateEvent extends StartEvent {
  @override
  List<Object?> get props => [];
}
