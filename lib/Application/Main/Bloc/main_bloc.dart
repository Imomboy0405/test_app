import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_app/Data/Models/show_case_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/theme_service.dart' as theme;
import 'package:test_app/Data/Services/lang_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  bool darkMode = theme.ThemeService.getTheme == theme.ThemeMode.dark;
  bool sound = true;
  Language language = LangService.getLanguage;
  ShowCaseModel showCaseModel = ShowCaseModel();
  bool rememberMe = true;

  int currentScreen = 1;
  int oldScreen = 1;
  double keyboardHeight = 0;
  List<int> resultTests = List.filled(3, -1);
  bool menuButtonPressed = false;
  final List<AssetImage> listOfMenuIcons = [
    const AssetImage('assets/icons/ic_menu_home_outlined.png'),
    const AssetImage('assets/icons/ic_menu_test_outlined.png'),
    const AssetImage('assets/icons/ic_menu_chat_outlined.png'),
    const AssetImage('assets/icons/ic_menu_profile_outlined.png'),
    const AssetImage('assets/icons/ic_menu_home.png'),
    const AssetImage('assets/icons/ic_menu_test.png'),
    const AssetImage('assets/icons/ic_menu_chat.png'),
    const AssetImage('assets/icons/ic_menu_profile.png'),
  ];
  final List<AssetImage> listOfMenuIconsDarkMode = [
    const AssetImage('assets/icons/ic_menu_home_outlined_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_test_outlined_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_chat_outlined_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_profile_outlined_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_home_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_test_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_chat_dark_mode.png'),
    const AssetImage('assets/icons/ic_menu_profile_dark_mode.png'),
  ];
  bool exitState = false;

  PageController controller = PageController(keepPage: true, initialPage: 1);

  UserModel? userModel;

  MainBloc()
      : super(MainInitialState(
          screen: 1,
          lang: LangService.getLanguage,
          darkMode: theme.ThemeService.getTheme == theme.ThemeMode.dark,
          sound: true,
          resultTests: List.filled(3, -1),
        )) {
    on<MainScrollMenuEvent>(scrollMenu);
    on<MainMenuButtonEvent>(pressMenuButton);
    on<MainHideBottomNavigationBarEvent>(hideBottomNavigationBar);
    on<MainLanguageEvent>(languageUpdate);
    on<MainThemeEvent>(themeUpdate);
    on<MainSoundEvent>(soundUpdate);
    on<MainExitEvent>(pressExit);
    on<MainCancelEvent>(pressCancel);
    on<MainDoneEvent>(pressDone);
  }

  void emitComfort(Emitter<MainState> emit) {
    emit(MainInitialState(
      screen: currentScreen,
      lang: language,
      darkMode: darkMode,
      sound: sound,
      resultTests: resultTests,
    ));
  }

  void listen() {
    if (controller.page! <= 0.001) {
      controller.jumpToPage(4);
    } else if (controller.page! >= 4.999) {
      controller.jumpToPage(1);
    }

    if ((!menuButtonPressed) && controller.page! - controller.page!.truncate() < 0.2 ||
        controller.page! - controller.page!.truncate() > 0.8) {
      currentScreen = controller.page!.round();
    }

    if (currentScreen != oldScreen && !menuButtonPressed) {
      oldScreen = currentScreen;
      add(MainScrollMenuEvent(index: currentScreen));
    }
  }

  Future<void> pressMenuButton(MainMenuButtonEvent event, Emitter<MainState> emit) async {
    menuButtonPressed = true;

    if (oldScreen < event.index + 1) {
      currentScreen = event.index + 1;
      if ((event.index + 1 - oldScreen) > 1) {
        controller.jumpToPage(currentScreen);
      } else {
        await controller.animateToPage(currentScreen, duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
      emitComfort(emit);
    } else if (event.index + 1 < oldScreen) {
      currentScreen = event.index + 1;
      if ((oldScreen - (event.index + 1)) > 1) {
        controller.jumpToPage(currentScreen);
      } else {
        await controller.animateToPage(currentScreen, duration: const Duration(milliseconds: 200), curve: Curves.linear);
        currentScreen--;
      }
      emitComfort(emit);
    }

    oldScreen = currentScreen;
    menuButtonPressed = false;
  }

  Future<void> scrollMenu(MainScrollMenuEvent event, Emitter<MainState> emit) async {
    await controller.animateToPage(currentScreen, duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
    emitComfort(emit);
  }

  void hideBottomNavigationBar(MainHideBottomNavigationBarEvent event, Emitter<MainState> emit) {
    emit(MainHideBottomNavigationBarState());
  }

  void languageUpdate(MainLanguageEvent event, Emitter<MainState> emit) {
    language = LangService.getLanguage;
    emitComfort(emit);
  }

  void themeUpdate(MainThemeEvent event, Emitter<MainState> emit) {
    darkMode = theme.ThemeService.getTheme == theme.ThemeMode.dark;
    emitComfort(emit);
  }

  void soundUpdate(MainSoundEvent event, Emitter<MainState> emit) async {
    sound = event.sound;
    await DBService.saveSound(sound.toString());
    emitComfort(emit);
  }

  void pressExit(MainExitEvent event, Emitter<MainState> emit) {
    exitState = true;
    emit(MainHideBottomNavigationBarState());
  }

  void pressCancel(MainCancelEvent event, Emitter<MainState> emit) {
    exitState = false;
    emitComfort(emit);
  }

  void pressDone(MainDoneEvent event, Emitter<MainState> emit) {
    SystemNavigator.pop();
  }
}
