import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Main/View/main_page.dart';
import 'package:test_app/Application/Welcome/SignUp/View/sign_up_page.dart';
import 'package:test_app/Data/Models/message_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/auth_service.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/logic_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';
import 'package:test_app/Data/Services/util_service.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  Language selectedLang = LangService.getLanguage;
  bool rememberMe = true;
  bool obscure = true;
  bool emailSuffix = false;
  bool passwordSuffix = false;
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  ScrollController scrollController = ScrollController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SignInBloc()
      : super(SignInEnterState(
          obscure: false,
          rememberMe: true,
          focusEmail: false,
          focusPassword: false,
          passwordSuffix: false,
          emailSuffix: false,
          passwordEye: false,
        )) {
    on<FlagEvent>(pressFlagButton);
    on<SelectLanguageEvent>(pressLanguageButton);
    on<SignInChangeEvent>(change);
    on<OnSubmittedEvent>(onSubmitted);
    on<EmailButtonEvent>(pressEmail);
    on<EyeEvent>(pressEye);
    on<SignInButtonEvent>(pressSignIn);
    on<RememberMeEvent>(pressRememberMe);
    on<ForgotPasswordEvent>(pressForgotPassword);
    on<FaceBookEvent>(pressFacebook);
    on<GoogleEvent>(pressGoogle);
    on<SignUpEvent>(pressSignUp);
  }

  void enterStateEmit(Emitter emit) {
    emit(SignInEnterState(
      passwordSuffix: passwordSuffix,
      emailSuffix: emailSuffix,
      focusEmail: focusEmail.hasFocus,
      focusPassword: focusPassword.hasFocus,
      obscure: obscure,
      rememberMe: rememberMe,
      passwordEye: passwordController.text.isNotEmpty,
    ));
  }

  void loadingStateEmit(Emitter emit) {
    emit(SignInLoadingState(
      password: passwordSuffix,
      obscure: obscure,
      email: emailSuffix,
      rememberMe: rememberMe,
    ));
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter emit) async {
    await LangService.language(event.lang);
    selectedLang = event.lang;
    emit(SignInFlagState());
    if (event.context.mounted) {
      Navigator.pop(event.context);
    }
    enterStateEmit(emit);
  }

  Future<void> onSubmitted(OnSubmittedEvent event, Emitter<SignInState> emit) async {
    if (!event.password) {
      focusEmail.unfocus();
      await Future.delayed(const Duration(milliseconds: 30));
      focusPassword.requestFocus();
    }
    enterStateEmit(emit);
  }

  Future<void> pressEmail(EmailButtonEvent event, Emitter<SignInState> emit) async {
    await Future.delayed(const Duration(milliseconds: 30));
    await scrollController.animateTo(event.width - 60, duration: const Duration(milliseconds: 200), curve: Curves.easeInOutCubic);
    focusEmail.requestFocus();
    enterStateEmit(emit);
  }

  Future<void> pressSignIn(SignInButtonEvent event, Emitter<SignInState> emit) async {
    loadingStateEmit(emit);

    Object? error;
    try {
      error = await AuthService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (error is UserModel) {
        locator<MainBloc>().userModel = error;
        if (rememberMe) {
          await DBService.saveUser(error);
          locator<MainBloc>().rememberMe = true;
        } else {
          locator<MainBloc>().rememberMe = false;
        }
        if (event.context.mounted) {
          Utils.mySnackBar(txt: 'welcome_user'.tr() + error.fullName!, context: event.context);
          Navigator.pushReplacementNamed(event.context, MainPage.id);
        }
      } else {
        debugPrint(error.toString());
        if (event.context.mounted) {
          Utils.mySnackBar(txt: LogicService.parseError(error.toString()).tr(), context: event.context, errorState: true);
        }
        emit(SignInErrorState(obscure: obscure, rememberMe: rememberMe));
      }
    } catch (e) {
      if (event.context.mounted) {
        Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
      }
      emit(SignInErrorState(obscure: obscure, rememberMe: rememberMe));
    }
  }

  Future<void> pressForgotPassword(ForgotPasswordEvent event, Emitter<SignInState> emit) async {
    // todo code
  }

  Future<void> pressGoogle(GoogleEvent event, Emitter<SignInState> emit) async {
    loadingStateEmit(emit);

    try {
      UserCredential userCredential = await AuthService.signInWithGoogle();
      if (event.context.mounted) {
        await checkAuthCredential(userCredential: userCredential, context: event.context);
      }
    } catch (e) {
      if (event.context.mounted) {
        Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true);
      }
    }
    emit(SignInErrorState(obscure: obscure, rememberMe: rememberMe));
  }

  Future<void> pressFacebook(FaceBookEvent event, Emitter<SignInState> emit) async {
    loadingStateEmit(emit);

    try {
      UserCredential userCredential = await AuthService.signInWithFacebook();
      if (event.context.mounted) {
        await checkAuthCredential(userCredential: userCredential, context: event.context);
      }
    } catch (e) {
      if (event.context.mounted) {
        Utils.mySnackBar(txt: LogicService.parseError(e.toString()).tr(), context: event.context, errorState: true);
      }
    }
    emit(SignInErrorState(obscure: obscure, rememberMe: rememberMe));
  }

  void pressFlagButton(FlagEvent event, Emitter emit) {
    emit(SignInFlagState());
  }

  void change(SignInChangeEvent event, Emitter<SignInState> emit) {
    passwordController.text = passwordController.text.trim();
    emailController.text = emailController.text.trim();
    passwordSuffix = LogicService.checkPassword(passwordController.text);
    emailSuffix = LogicService.checkEmail(emailController.text);
    enterStateEmit(emit);
  }

  void pressEye(EyeEvent event, Emitter<SignInState> emit) {
    obscure = !obscure;
    enterStateEmit(emit);
  }

  void pressRememberMe(RememberMeEvent event, Emitter<SignInState> emit) {
    rememberMe = !rememberMe;
    enterStateEmit(emit);
  }

  void pressSignUp(SignUpEvent event, Emitter<SignInState> emit) {
    Navigator.pushReplacementNamed(event.context, SignUpPage.id);
  }

  Future<void> checkAuthCredential({required UserCredential userCredential, required BuildContext context}) async {
    String? uId = userCredential.user?.uid;
    if (uId != null) {
      UserModel? userModel = await RTDBService.loadUser(FirebaseAuth.instance.currentUser!.uid);
      if (userModel != null) {
        locator<MainBloc>().userModel = userModel;
        if (rememberMe) {
          await DBService.saveUser(userModel);
          locator<MainBloc>().rememberMe = true;
        } else {
          locator<MainBloc>().rememberMe = false;
        }
        if (context.mounted) {
          Utils.mySnackBar(txt: 'welcome_user'.tr() + userModel.fullName!, context: context);
          Navigator.pushReplacementNamed(context, MainPage.id);
        }
      } else {
        try {
          userModel = UserModel(
            uId: uId,
            email: userCredential.user?.email,
            fullName: userCredential.user?.displayName,
            password: '',
            createdTime: DateTime.now().toString().substring(0, 10),
            loginType: 'googleOrFacebook',
            userDetailList: [],
          );
          await RTDBService.storeUser(userModel);
          DatabaseReference messagesRef = FirebaseDatabase.instance.ref('chat/${userModel.uId}/messages');
          final msgModel = MessageModel(
            msg: 'welcome_user'.tr() + userModel.fullName!,
            typeUser: true,
            dateTime: DateTime.now().toString().substring(11, 16),
            id: DateTime.now().toString(),
          );
          await messagesRef.push().set(msgModel.toJson());
          if (context.mounted) {
            Utils.mySnackBar(txt: 'account_created'.tr(), context: context);
          }

          locator<MainBloc>().userModel = userModel;
          if (rememberMe) {
            await DBService.saveUser(userModel);
            locator<MainBloc>().rememberMe = true;
          } else {
            locator<MainBloc>().rememberMe = false;
          }
          if (context.mounted) {
            Utils.mySnackBar(txt: 'welcome_user'.tr() + userModel.fullName!, context: context);
            Navigator.pushReplacementNamed(context, MainPage.id);
          }
        } catch (e) {
          if (context.mounted) {
            Utils.mySnackBar(txt: e.toString(), context: context, errorState: true);
          }
        }
      }
    } else {
      if (context.mounted) {
        Utils.mySnackBar(txt: 'error_cloud_data'.tr(), context: context, errorState: true);
      }
    }
  }
}
