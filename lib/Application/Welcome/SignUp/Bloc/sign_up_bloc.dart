import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/Data/Models/message_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/auth_service.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/logic_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';
import 'package:test_app/Data/Services/util_service.dart';
import '../../SignIn/View/sign_in_page.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  Language selectedLang = LangService.getLanguage;
  bool googleOrFacebook = false;
  bool obscurePassword = true;
  bool obscureRePassword = true;
  bool emailSuffix = false;
  bool passwordSuffix = false;
  bool rePasswordSuffix = false;
  bool fullNameSuffix = false;
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  FocusNode focusRePassword = FocusNode();
  FocusNode focusFullName = FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();

  Timer? emailVerificationTimer;

  SignUpBloc()
      : super(SignUpEnterState(
          obscurePassword: true,
          obscureRePassword: true,
          focusEmail: false,
          focusPassword: false,
          focusRePassword: false,
          focusFullName: false,
          suffixEmail: false,
          suffixFullName: false,
          suffixPassword: false,
          suffixRePassword: false,
          passwordEye: false,
          rePasswordEye: false,
        )) {
    on<SignUpChangeEvent>(change);
    on<OnSubmittedEvent>(onSubmitted);
    on<PasswordEyeEvent>(pressPasswordEye);
    on<RePasswordEyeEvent>(pressRePasswordEye);
    on<SignUpButtonEvent>(pressSignUp);
    on<FaceBookEvent>(pressFacebook);
    on<GoogleEvent>(pressGoogle);
    on<SignInEvent>(pressSignIn);
    on<SelectLanguageEvent>(pressLanguageButton);
    on<SignUpCancelEvent>(pressCancel);
  }

  void enterStateEmit(Emitter emit) {
    emit(SignUpEnterState(
      focusEmail: focusEmail.hasFocus,
      focusPassword: focusPassword.hasFocus,
      focusRePassword: focusRePassword.hasFocus,
      focusFullName: focusFullName.hasFocus,
      suffixEmail: emailSuffix,
      suffixFullName: fullNameSuffix,
      suffixPassword: passwordSuffix,
      suffixRePassword: rePasswordSuffix,
      obscurePassword: obscurePassword,
      obscureRePassword: obscureRePassword,
      passwordEye: passwordController.text.isNotEmpty,
      rePasswordEye: rePasswordController.text.isNotEmpty,
    ));
  }

  Future<void> pressCancel(SignUpCancelEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    emailVerificationTimer!.cancel();
    await FirebaseAuth.instance.currentUser!.delete().whenComplete(() {
      emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
    });
    if (event.context.mounted) {
      Utils.mySnackBar(txt: 'email_not_verified'.tr(), context: event.context, errorState: true);
    }
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter<SignUpState> emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    if (event.context.mounted) {
      Navigator.pop(event.context);
    }
    emit(SignUpFlagState());
    enterStateEmit(emit);
  }

  Future<void> onSubmitted(OnSubmittedEvent event, Emitter<SignUpState> emit) async {
    if (fullNameController.text.isNotEmpty) {
      fullNameController.text = fullNameController.text.replaceAll(RegExp(r'\s+'), ' ');
    }
    if (event.password) {
      focusPassword.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusRePassword.requestFocus();
    } else {
      if (event.fullName) {
        focusFullName.unfocus();
        await Future.delayed(const Duration(milliseconds: 30));
        focusPassword.requestFocus();
      } else {
        if (event.rePassword) {
          focusRePassword.unfocus();
        } else {
          focusEmail.unfocus();
          await Future.delayed(const Duration(milliseconds: 30));
          focusFullName.requestFocus();
        }
      }
    }
    enterStateEmit(emit);
  }

  Future<void> pressSignUp(SignUpButtonEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());

    if (googleOrFacebook) {
      UserModel userModel = UserModel(
        fullName: fullNameController.text.trim(),
        password: '',
        email: emailController.text.trim(),
        uId: FirebaseAuth.instance.currentUser!.uid,
        createdTime: DateTime.now().toString().substring(0, 10),
        loginType: 'googleOrFacebook',
        userDetailList: [],
      );

      try {
        await RTDBService.storeUser(userModel);
        DatabaseReference messagesRef = FirebaseDatabase.instance.ref('chat/${userModel.uId}/messages');
        final msgModel = MessageModel(
          msg: 'welcome_user'.tr() + userModel.fullName!,
          typeUser: true,
          dateTime: DateTime.now().toString().substring(11, 16),
          id: DateTime.now().toString(),
        );
        await messagesRef.push().set(msgModel.toJson());

        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'account_created'.tr(), context: event.context);
          Navigator.pushReplacementNamed(event.context, SignInPage.id);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
        emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
      }
    } else {
      await FirebaseAuth.instance.setLanguageCode(selectedLang.name);

      try {
        await AuthService.createUser(emailController.text.trim(), passwordController.text.trim());
        await AuthService.verifyEmail(emailController.text.trim());
        emit(SignUpVerifyState());

        bool verifyDone = false;

        int secondsElapsed= 0;
        emailVerificationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          secondsElapsed++;
          verifyDone = await AuthService.verifyEmailLink();
          if (verifyDone) {
            timer.cancel();
            UserModel userModel = UserModel(
              fullName: fullNameController.text.trim(),
              password: passwordController.text.trim(),
              email: emailController.text.trim(),
              uId: FirebaseAuth.instance.currentUser!.uid,
              createdTime: DateTime.now().toString().substring(0, 10),
              loginType: 'email',
              userDetailList: [],
            );
            try {
              await RTDBService.storeUser(userModel);
              DatabaseReference messagesRef = FirebaseDatabase.instance.ref('chat/${userModel.uId}/messages');
              final msgModel = MessageModel(
                msg: 'welcome_user'.tr() + userModel.fullName!,
                typeUser: true,
                dateTime: DateTime.now().toString().substring(11, 16),
                id: DateTime.now().toString(),
              );
              await messagesRef.push().set(msgModel.toJson());
              if (event.context.mounted) {
                Utils.mySnackBar(txt: 'account_created'.tr(), context: event.context);
                Navigator.pushReplacementNamed(event.context, SignInPage.id);
              }
            } catch (e) {
              if (event.context.mounted) {
                Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
              }
            }
          } else if (secondsElapsed >= 60) {
            if (event.context.mounted) {
              add(SignUpCancelEvent(context: event.context));
            }
          }
        });
      } catch (e) {
        if (LogicService.parseError(e.toString()) == 'email-already-in-use') {
          if (event.context.mounted) {
            Utils.mySnackBar(txt: 'email_already_in_use'.tr(), context: event.context, errorState: true);
          }
        } else {
          if (event.context.mounted) {
            Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
          }
        }
        emit(SignUpErrorState(obscurePassword: obscurePassword, obscureRePassword: obscureRePassword));
      }
    }
  }

  Future<void> pressGoogle(GoogleEvent event, Emitter<SignUpState> emit) async {
    if (googleOrFacebook) {
      Utils.mySnackBar(txt: 'completed_google'.tr(), context: event.context);
    } else {
      emit(SignUpLoadingState());

      try {
        UserCredential userCredential = await AuthService.signInWithGoogle();
        if (event.context.mounted) {
          await checkAuthCredential(userCredential: userCredential, context: event.context, width: event.width);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
        }
      }

      enterStateEmit(emit);
    }
  }

  Future<void> pressFacebook(FaceBookEvent event, Emitter<SignUpState> emit) async {
    if (googleOrFacebook) {
      Utils.mySnackBar(txt: 'completed_facebook'.tr(), context: event.context);
    } else {
      emit(SignUpLoadingState());

      try {
        UserCredential userCredential = await AuthService.signInWithFacebook();
        if (event.context.mounted) {
          await checkAuthCredential(userCredential: userCredential, context: event.context, width: event.width);
        }
      } catch (e) {
        if (event.context.mounted) {
          Utils.mySnackBar(txt: LogicService.parseError(e.toString()).tr(), context: event.context, errorState: true);
        }
      }
      enterStateEmit(emit);
    }
  }

  void change(SignUpChangeEvent event, Emitter<SignUpState> emit) {
    fullNameSuffix = LogicService.checkFullName(fullNameController.text);
    emailSuffix = LogicService.checkEmail(emailController.text);
    passwordSuffix = LogicService.checkPassword(passwordController.text);
    rePasswordSuffix = rePasswordController.text.isNotEmpty && passwordController.text == rePasswordController.text;

    if (emailController.text.isNotEmpty) {
      emailController.text = emailController.text.replaceAll(' ', '');
    }
    enterStateEmit(emit);
  }

  void pressPasswordEye(PasswordEyeEvent event, Emitter<SignUpState> emit) {
    obscurePassword = !obscurePassword;
    enterStateEmit(emit);
  }

  void pressRePasswordEye(RePasswordEyeEvent event, Emitter<SignUpState> emit) {
    obscureRePassword = !obscureRePassword;
    enterStateEmit(emit);
  }

  void pressSignIn(SignInEvent event, Emitter<SignUpState> emit) async {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }

  Future<void> checkAuthCredential({required UserCredential userCredential, required BuildContext context, required double width}) async {
    String? uId = userCredential.user?.uid;
    String? email = userCredential.user?.email;
    String? fullName = userCredential.user?.displayName;

    if (uId != null) {
      googleOrFacebook = true;
      UserModel? userModel = await RTDBService.loadUser(FirebaseAuth.instance.currentUser!.uid);
      if (userModel == null) {
        if (email != null) {
          emailController.text = email;
        } else {
          emailController.text = 'null';
        }
      emailSuffix = true;
      await Future.delayed(const Duration(milliseconds: 30));
      if (fullName != null) {
        fullNameController.text = fullName;
      } else {
        fullNameController.text = 'null';
      }
      fullNameSuffix = true;
      if (context.mounted) {
        add(SignUpButtonEvent(context: context));
      }
    } else {
        if (context.mounted) {
          Utils.mySnackBar(txt: 'email_already_in_use'.tr(), context: context, errorState: true);
        }
      }
    } else {
      if (context.mounted) {
        Utils.mySnackBar(txt: 'error_cloud_data'.tr(), context: context, errorState: true);
      }
    }
  }
}
