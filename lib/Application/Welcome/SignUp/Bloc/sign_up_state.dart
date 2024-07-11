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
  final bool focusEmail;
  final bool focusPassword;
  final bool focusRePassword;
  final bool focusFullName;
  final bool obscurePassword;
  final bool obscureRePassword;
  final bool suffixEmail;
  final bool suffixFullName;
  final bool suffixPassword;
  final bool suffixRePassword;
  final bool passwordEye;
  final bool rePasswordEye;

  SignUpEnterState({
    required this.focusEmail,
    required this.focusPassword,
    required this.focusRePassword,
    required this.obscurePassword,
    required this.obscureRePassword,
    required this.focusFullName,
    required this.suffixEmail,
    required this.suffixFullName,
    required this.suffixPassword,
    required this.suffixRePassword,
    required this.passwordEye,
    required this.rePasswordEye,
  });

  @override
  List<Object?> get props => [
        focusEmail,
        focusPassword,
        focusRePassword,
        obscurePassword,
        obscureRePassword,
        focusFullName,
        suffixEmail,
        suffixFullName,
        suffixPassword,
        suffixRePassword,
        passwordEye,
        rePasswordEye,
      ];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpFlagState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpVerifyState extends SignUpState {
  @override
  List<Object?> get props => [];
}
