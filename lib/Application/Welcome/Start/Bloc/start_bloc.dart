import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/Application/Welcome/SignIn/View/sign_in_page.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:url_launcher/url_launcher.dart';

part 'start_event.dart';
part 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  Language selectedLang = LangService.getLanguage;
  List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
  ];
  bool first = false;
  double left = 41;
  double top = 10;
  double left1 = 45;
  double top1 = 110;
  double left2 = 280;
  double top2 = 150;
  bool login = false;
  bool next = false;
  double loginHeight = 75;
  int oldScreen = 1;
  int screen = 1;
  bool pressNext = false;

  StartBloc() : super(StartInitialState(first: false, left: 40, top: 10, loginHeight: 75)) {
    on<FlagEvent>(pressFlagButton);
    on<NextEvent>(pressNextButton);
    on<SkipEvent>(pressSkipButton);
    on<TermsEvent>(pressTermsButton);
    on<LoginAnimateEvent>(pressNextAnimateEnd);
    on<SelectLanguageEvent>(pressLanguageButton);
    on<UpdateAnimateEvent>(updateAnimate);
  }

  void listenPageScroll({required TabController controller}) async {
    screen = controller.index + 1;
    if (oldScreen != screen && !pressNext) {
      print('scroll $oldScreen $screen');
      oldScreen = screen;
      add(UpdateAnimateEvent());
    }
  }

  void updateAnimate(UpdateAnimateEvent event, Emitter<StartState> emit) async {
    left = first ? 40 : 75;
    top = first ? 10 : 50;
    left1 = first ? 100 : 10;
    top1 = first ? 80 : 10;
    left2 = first ? 250 : 70;
    top2 = first ? 15 : 300;
    first = !first;
    if (screen == 3) {
      next = true;
    } else {
      next = false;
      login = false;
    }
    emit(StartInitialState(left: left, top: top, first: first, loginHeight: loginHeight));
    print('update');
    pressNext = false;
  }

  void pressFlagButton(FlagEvent event, Emitter<StartState> emit) {
    emit(StartFlagState());
  }

  void pressNextAnimateEnd(LoginAnimateEvent event, Emitter<StartState> emit) {
    if (next) {
      login = true;
    }
    if (event.first) {
      loginHeight = 80;
    } else {
      loginHeight = 75;
    }
    emit(StartInitialState(loginHeight: loginHeight, left: left, top: top, first: first));
  }

  void pressNextButton(NextEvent event, Emitter<StartState> emit) {
    final TabController controller = DefaultTabController.of(event.context);
    screen = controller.index + 1;
    if (screen != 3) {
      pressNext = true;
      oldScreen = screen + 1;
      print('Next $oldScreen');
      controller.animateTo(screen);
      add(UpdateAnimateEvent());
     } else {
      Navigator.pushReplacementNamed(event.context, SignInPage.id);
    }
  }

  void pressSkipButton(SkipEvent event, Emitter<StartState> emit) {
    Navigator.pushReplacementNamed(event.context, SignInPage.id);
  }

  Future<void> pressTermsButton(TermsEvent event, Emitter<StartState> emit) async {
    if (event.policy) {
      await launchUrl(
          Uri(path: 'www.termsfeed.com/live/cfc44701-8782-4bc1-86c6-95a33a2c361c',
              scheme: 'https'), mode: LaunchMode.inAppWebView);
    } else {
      await launchUrl(
          Uri(path: 'www.privacypolicies.com/live/ab899bd1-c90f-439a-a149-b849ada1e61d',
              scheme: 'https', ), mode: LaunchMode.inAppWebView);
    }
  }

  Future<void> pressLanguageButton(SelectLanguageEvent event, Emitter<StartState> emit) async {
    await LangService.language(event.language);
    selectedLang = event.language;
    if (event.context.mounted) {
      Navigator.pop(event.context);
    }
    emit(StartFlagState());
    emit(StartInitialState(top: top, left: left, first: first, loginHeight: loginHeight));
  }
}
