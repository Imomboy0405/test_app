import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Welcome/SignIn/View/sign_in_page.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/r_t_d_b_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final MainBloc mainBloc = locator<MainBloc>();
  bool darkMode = ThemeService.getTheme == ThemeMode.dark;
  String fullName = '';
  String dateSign = '';
  String? phoneNumber;
  String? email;
  Language selectedLang = LangService.getLanguage;
  List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
  ];

  ProfileBloc() : super(ProfileInitialState(darkMode: false, phone: '', email: '')) {
    on<InitialUserEvent>(initialUser);
    on<ProfileUpdateEvent>(pressProfileUpdate);
    on<LanguageEvent>(pressLanguage);
    on<ConfirmLanguageEvent>(pressSelectLanguage);
    on<CancelEvent>(pressCancel);
    on<DoneEvent>(pressDone);
    on<DarkModeEvent>(pressDarkMode);
    on<SignOutEvent>(pressSignOut);
    on<DeleteAccountEvent>(pressDeleteAccount);
    on<ConfirmEvent>(pressConfirm);
    on<InfoEvent>(pressInfo);
  }

  void initialUser(InitialUserEvent event, Emitter<ProfileState> emit) async {
    darkMode = ThemeService.getTheme == ThemeMode.dark;
    mainBloc.darkMode = darkMode;
    selectedLang = LangService.getLanguage;

    fullName = mainBloc.userModel!.fullName!;
    email = mainBloc.userModel!.email != null && mainBloc.userModel!.email!.isNotEmpty
        ? mainBloc.userModel!.email!
        : null;
    dateSign = mainBloc.userModel!.createdTime!;

    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  void pressProfileUpdate(ProfileUpdateEvent event, Emitter<ProfileState> emit) {
    Navigator.pushNamed(event.context, '/profile_detail_page');
  }

  void pressLanguage(LanguageEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileLangState(lang: selectedLang));
  }

  void pressSelectLanguage(ConfirmLanguageEvent event, Emitter<ProfileState> emit) {
    selectedLang = event.lang;
    emit(ProfileLangState(lang: selectedLang));
  }

  void pressCancel(CancelEvent event, Emitter<ProfileState> emit) {
    selectedLang = LangService.getLanguage;
    mainBloc.add(MainLanguageEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  Future<void> pressDone(DoneEvent event, Emitter<ProfileState> emit) async {
    await LangService.language(selectedLang);
    mainBloc.add(MainLanguageEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  Future<void> pressDarkMode(DarkModeEvent event, Emitter<ProfileState> emit) async {
    darkMode = event.darkMode;
    await ThemeService.theme(darkMode ? ThemeMode.dark : ThemeMode.light);
    mainBloc.add(MainThemeEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  void pressSignOut(SignOutEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileSignOutState());
  }

  void pressDeleteAccount(DeleteAccountEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileDeleteAccountState());
  }

  void pressConfirm(ConfirmEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    if (event.delete) {
      await RTDBService.deleteUser(mainBloc.userModel!);
    }
    await DBService.deleteData(StorageKey.user);
    locator.unregister<MainBloc>();
    locator.unregister<ProfileBloc>();

    if (event.context.mounted) {
      Navigator.pushNamedAndRemoveUntil(event.context, SignInPage.id, (route) => false);
    }
    locator.registerSingleton<ProfileBloc>(ProfileBloc());
    locator.registerSingleton<MainBloc>(MainBloc());
  }

  void pressInfo(InfoEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileInfoState());
  }
}
