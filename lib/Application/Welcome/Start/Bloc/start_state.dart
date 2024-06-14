part of 'start_bloc.dart';

@immutable
abstract class StartState extends Equatable {}

class StartInitialState extends StartState {
  final double left;
  final double top;
  final double loginHeight;
  final bool first;
  final bool login;

  StartInitialState({required this.loginHeight, required this.left, required this.top, required this.first, this.login = false});

  @override
  List<Object?> get props => [left, top, first, login, loginHeight];
}

class StartFlagState extends StartState {
  @override
  List<Object?> get props => [];
}
