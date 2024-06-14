part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {}

class SignInErrorState extends SignInState {
  final bool obscure;
  final bool rememberMe;

  SignInErrorState({required this.obscure, required this.rememberMe});

  @override
  List<Object?> get props => [obscure, rememberMe];
}

class SignInEnterState extends SignInState {
  final bool email;
  final bool password;
  final bool obscure;
  final bool rememberMe;
  final bool emailSuffix;
  final bool passwordSuffix;

  SignInEnterState(
      {
      required this.passwordSuffix,
      required this.emailSuffix,
      required this.email,
      required this.password,
      required this.obscure,
      required this.rememberMe,
      });

  @override
  List<Object?> get props => [
        passwordSuffix,
        emailSuffix,
        email,
        password,
        obscure,
        rememberMe
      ];
}

class SignInLoadingState extends SignInState {
  final bool email;
  final bool password;
  final bool obscure;
  final bool rememberMe;

  SignInLoadingState(
      {required this.email,
      required this.password,
      required this.obscure,
      required this.rememberMe});

  @override
  List<Object?> get props => [email, password, obscure, rememberMe];
}

class SignInFlagState extends SignInState {
  @override
  List<Object?> get props => [];
}