part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {}

class SignUpErrorState extends SignUpState {
  final bool obscurePassword;
  final bool obscureRePassword;

  SignUpErrorState({required this.obscurePassword, required this.obscureRePassword});

  @override
  List<Object?> get props => [obscurePassword, obscureRePassword];
}

class SignUpEnterState extends SignUpState {
  final bool email;
  final bool password;
  final bool rePassword;
  final bool fullName;
  final bool obscurePassword;
  final bool obscureRePassword;

  SignUpEnterState(
      {
      required this.email,
      required this.password,
      required this.rePassword,
      required this.obscurePassword,
      required this.obscureRePassword,
      required this.fullName});

  @override
  List<Object?> get props =>
      [email, password, rePassword, obscurePassword, obscureRePassword, fullName];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpFlagState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpVerifyPhoneState extends SignUpState {
  @override
  List<Object?> get props => [];
}

