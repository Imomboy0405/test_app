import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Chat/Bloc/chat_bloc.dart';
import 'package:test_app/Application/Menus/Home/Bloc/home_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Detail/Bloc/profile_detail_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Detail/View/profile_detail_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/SignIn/View/sign_in_page.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Models/show_case_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/firestore_service.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';
import 'package:test_app/Data/Services/util_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final MainBloc mainBloc;
  bool darkMode = ThemeService.getTheme == ThemeMode.dark;
  String fullName = '';
  DateTime? dateSign;
  String? phoneNumber;
  String? email;
  Language selectedLang = LangService.getLanguage;
  List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
    Language.qr,
    Language.kr,
  ];
  int currentTab = 0;
  List<UserDetailModel> userDetailList = [];
  List<Map<String, dynamic>> values = [];

  final keyMedicalInfo = GlobalKey(debugLabel: 'showMedicalInfo');

  final player = AudioPlayer();

  ProfileBloc({required this.mainBloc}) : super(ProfileInitialState(darkMode: false, phone: '', email: '')) {
    on<InitialUserEvent>(initialUser);
    on<ProfileUpdateEvent>(pressProfileUpdate);
    on<LanguageEvent>(pressLanguage);
    on<ConfirmLanguageEvent>(pressSelectLanguage);
    on<CancelEvent>(pressCancel);
    on<DoneEvent>(pressDone);
    on<DarkModeEvent>(pressDarkMode);
    on<SoundEvent>(pressSound);
    on<SignOutEvent>(pressSignOut);
    on<DeleteAccountEvent>(pressDeleteAccount);
    on<ConfirmEvent>(pressConfirm);
    on<InfoEvent>(pressInfo);
    on<NextEvent>(pressNext);
    on<ListenScrollEvent>(listenScroll);
    on<UpdateDetailEvent>(updateEmit);
    on<ProfileShowCaseEvent>(showCase);
    on<TutorialEvent>(pressTutorial);
  }

  Future<void> showCase(ProfileShowCaseEvent event, Emitter<ProfileState> emit) async {
    ShowCaseWidget.of(event.context).startShowCase([keyMedicalInfo]);
    emit(ProfileInitialState(darkMode: darkMode, email: email, phone: phoneNumber));
    mainBloc.showCaseModel.profile = true;
    await DBService.saveShowCase(mainBloc.showCaseModel);
  }

  void initialUser(InitialUserEvent event, Emitter<ProfileState> emit) async {
    darkMode = ThemeService.getTheme == ThemeMode.dark;
    mainBloc.darkMode = darkMode;
    selectedLang = LangService.getLanguage;

    fullName = mainBloc.userModel!.displayName!;
    email = mainBloc.userModel!.email != null && mainBloc.userModel!.email!.isNotEmpty ? mainBloc.userModel!.email! : null;

    dateSign = mainBloc.userModel!.createdAt!.toDate();

    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  void pressProfileUpdate(ProfileUpdateEvent event, Emitter<ProfileState> emit) {
    myAnimatedPush(context: event.context, pushPage: const ProfileDetailPage(), offset: const Offset(0, .7));
  }

  void pressLanguage(LanguageEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileLangState(lang: selectedLang));
  }

  void pressSelectLanguage(ConfirmLanguageEvent event, Emitter<ProfileState> emit) {
    selectedLang = event.lang;
    if (mainBloc.sound) {
      player.play(AssetSource('sounds/sound_button.wav'));
    }
    emit(ProfileLangState(lang: selectedLang));
  }

  void pressCancel(CancelEvent event, Emitter<ProfileState> emit) {
    selectedLang = LangService.getLanguage;
    mainBloc.add(MainLanguageEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  Future<void> pressDone(DoneEvent event, Emitter<ProfileState> emit) async {
    await LangService.language(selectedLang);
    locator<HomeBloc>().articles = articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
    mainBloc.add(MainLanguageEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  Future<void> pressDarkMode(DarkModeEvent event, Emitter<ProfileState> emit) async {
    darkMode = event.darkMode;
    await ThemeService.theme(darkMode ? ThemeMode.dark : ThemeMode.light);
    if (mainBloc.sound) {
      player.play(AssetSource('sounds/sound_button.wav'));
    }
    mainBloc.add(MainThemeEvent());
    emit(ProfileInitialState(darkMode: darkMode, phone: phoneNumber, email: email));
  }

  void pressSound(SoundEvent event, Emitter<ProfileState> emit) {
    if (event.sound) {
      player.play(AssetSource('sounds/sound_button.wav'));
    }
    mainBloc.add(MainSoundEvent(sound: event.sound));
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
    if (event.tutorial) {
      mainBloc.showCaseModel = ShowCaseModel();
      await DBService.saveShowCase(mainBloc.showCaseModel);
      mainBloc.add(MainLanguageEvent());
      return;
    }

    if (event.delete) {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      await FirestoreService.deleteUser(mainBloc.userModel!.uid!);
    }
    await DBService.deleteData(StorageKey.user);
    locator.unregister<MainBloc>();
    locator.unregister<ProfileBloc>();
    locator.unregister<HomeBloc>();
    locator.unregister<ChatBloc>();

    if (event.context.mounted) {
      Navigator.pushNamedAndRemoveUntil(event.context, SignInPage.id, (route) => false);
    }
    locator.registerSingleton<MainBloc>(MainBloc());
    locator.registerSingleton<ProfileBloc>(ProfileBloc(mainBloc: locator<MainBloc>()));
    locator.registerSingleton<HomeBloc>(HomeBloc(mainBloc: locator<MainBloc>()));
    locator.registerSingleton<ChatBloc>(ChatBloc());
  }

  void pressInfo(InfoEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileInfoState());
  }

  void pressTutorial(TutorialEvent event, Emitter<ProfileState> emit) {
    mainBloc.add(MainHideBottomNavigationBarEvent());
    emit(ProfileTutorialState());
  }

  void pressNext(NextEvent event, Emitter<ProfileState> emit) async {
    if (event.index != 5) {
      currentTab = event.index;
      DefaultTabController.of(event.context).animateTo(event.index);
      emit(ProfileDetailPageState(index: currentTab, userModel: mainBloc.userModel!));
    } else {
      // #required check code
      // for (int i = 4; i <= 8; i++) {
      //   UserDetailModel userDetail = userDetailList[i];
      //   if (userDetail.entries >= 4) {
      //     bool checked = false;
      //     for (Entries entry in userDetail.entries) {
      //       if (entry.value == true) {
      //         checked = true;
      //         break;
      //       }
      //     }
      //     if (!checked) {
      //       Utils.mySnackBar(txt: 'unselected'.tr() + userDetail.title!['ru']!, context: event.context, errorState: true, bottom: false);
      //       currentTab = 3;
      //       DefaultTabController.of(event.context).animateTo(3);
      //       await Future.delayed(const Duration(milliseconds: 300));
      //       if (event.context.mounted) {
      //         event.context.read<ProfileDetailBloc>().add(UpdateDetailExpansionPanelEvent(
      //               tabIndex: 3,
      //               value: userDetail.entries[],
      //               pressSaveButton: true,
      //             ));
      //       }
      //       emit(ProfileDetailPageState(index: currentTab, userModel: mainBloc.userModel!));
      //       return;
      //     }
      //   }
      // }

      try {
        event.context.read<ProfileDetailBloc>().add(DetailLoadingEvent());
        if (mainBloc.rememberMe) {
          mainBloc.userDetailList = userDetailList;
          values = event.values;
        }
        await FirestoreService.updateSeed(event.values, mainBloc.userModel!.uid!);
        if (event.context.mounted) {
          currentTab = 0;
          Navigator.pop(event.context);
          Utils.mySnackBar(txt: 'update_profile_success'.tr(), context: event.context, bottom: false);
        }
        emit(ProfileInitialState(darkMode: darkMode, email: email, phone: phoneNumber));
      } catch (e) {
        if (event.context.mounted) {
          Navigator.pop(event.context);
          Utils.mySnackBar(txt: e.toString(), context: event.context, errorState: true, bottom: false);
        }
      }
    }
  }

  void listenScroll(ListenScrollEvent event, Emitter<ProfileState> emit) {
    DefaultTabController.of(event.context).addListener(() async {
      if (DefaultTabController.of(event.context).index != currentTab) {
        currentTab = DefaultTabController.of(event.context).index;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration.zero);
          add(UpdateDetailEvent());
        });
      }
    });
  }

  void updateEmit(UpdateDetailEvent event, Emitter<ProfileState> emit) {
    emit(ProfileDetailPageState(index: currentTab, userModel: mainBloc.userModel!));
  }
}
