import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ProfilePage extends StatelessWidget {
  static const id = '/profile_page';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileBloc bloc = locator<ProfileBloc>();
    final MainBloc mainBloc = locator<MainBloc>();
    final double width = MediaQuery.of(context).size.width;

    return BlocBuilder<MainBloc, MainState>(
        bloc: mainBloc,
        builder: (context, state) {
          return BlocBuilder<ProfileBloc, ProfileState>(
              bloc: bloc,
              builder: (context, state) {
                if ((bloc.fullName == '' || (mainBloc.darkMode != bloc.darkMode) || (mainBloc.language != bloc.selectedLang)) &&
                    state is ProfileInitialState) {
                  bloc.add(InitialUserEvent());
                }
                return Stack(
                  children: [
                    ShowCaseWidget(builder: (context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (!mainBloc.showCaseModel.profile && mainBloc.currentScreen == 4) {
                          if (context.mounted) {
                            bloc.add(ProfileShowCaseEvent(context: context));
                          }
                        }
                      });
                      return Scaffold(
                        backgroundColor: AppColors.transparent,
                        appBar: MyAppBar(titleText: 'profile'.tr()),
                        body: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 75),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                // #profil
                                SizedBox(height: width * .015),
                                MyProfileButton(
                                  endElement: SizedBox(
                                    height: MediaQuery.of(context).size.width * .46,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // #full_name
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.profile_circled, color: AppColors.whiteConst, size: width * .12),
                                            SizedBox(width: width * .02),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(bloc.fullName, style: AppTextStyles.style3(context).copyWith(color: AppColors.whiteConst)),
                                                Text('test_app_user'.tr(), style: AppTextStyles.style19(context)),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // #date_of_sign_up
                                        Row(
                                          children: [
                                            Text("${'date_sign'.tr()}:", style: AppTextStyles.style19(context)),
                                            const SizedBox(width: 10),
                                            Flexible(
                                                child: Text(bloc.dateSign != null ?  "${'month_${bloc.dateSign!.month}'.tr()} ${bloc.dateSign!.day}, ${bloc.dateSign!.year} ${'year_profile'.tr()}" : '',
                                                maxLines: 1,
                                                style: AppTextStyles.style19(context),
                                            )),
                                          ],
                                        ),

                                        // #phone_number
                                        Row(
                                          children: [
                                            Text("${'phone_num'.tr()}:", style: AppTextStyles.style19(context)),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Text(bloc.phoneNumber == null ? 'phone_not_set'.tr() : bloc.phoneNumber!,
                                                  style: AppTextStyles.style19(context)),
                                            ),
                                          ],
                                        ),

                                        // #email
                                        Row(
                                          children: [
                                            Text("${'email'.tr()}:", style: AppTextStyles.style19(context)),
                                            const SizedBox(width: 10),
                                            Text(bloc.email == null ? 'email_not_set'.tr() : bloc.email!,
                                                style: AppTextStyles.style19(context)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  function: () => (),
                                ),
                                SizedBox(height: width * .015),

                                // #medical_info
                                myShowcase(
                                  context: context,
                                  key: bloc.keyMedicalInfo,
                                  title: 'show_medical_info_title'.tr(),
                                  description: 'show_medical_info_description'.tr(),
                                  onTap: () => ShowCaseWidget.of(context).dismiss(),
                                  child: MyProfileButton(
                                    text: true ? 'medical_info'.tr() : 'medical_info_not_found'.tr(),
                                    function: () => bloc.add(ProfileUpdateEvent(context: context)),
                                    endElement: Icon(Icons.health_and_safety, size: width * .05, color: AppColors.whiteConst),
                                  ),
                                ),
                                SizedBox(height: width * .015),

                                // #theme
                                MyProfileButton(
                                  text: 'theme'.tr(),
                                  function: () => bloc.add(DarkModeEvent(darkMode: !bloc.darkMode)),
                                  endElement: SizedBox(
                                    height: width * .06,
                                    child: ToggleButtons(
                                      constraints: BoxConstraints(
                                        minWidth: width * .1,
                                        minHeight: width * .06,
                                      ),
                                      selectedColor: AppColors.whiteConst,
                                      color: AppColors.whiteConst,
                                      fillColor: AppColors.purple,
                                      splashColor: AppColors.purple,
                                      borderColor: AppColors.whiteConst,
                                      borderWidth: 0.3,
                                      borderRadius: BorderRadius.circular(6),
                                      isSelected: [!mainBloc.darkMode, mainBloc.darkMode],
                                      onPressed: (i) => bloc.add(DarkModeEvent(darkMode: i == 1)),
                                      children: <Widget>[
                                        Icon(CupertinoIcons.sun_max_fill, size: width * .04),
                                        Icon(CupertinoIcons.moon_stars_fill, size: width * .04),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: width * .015),

                                // #sound
                                MyProfileButton(
                                  text: 'sounds_and_vibration'.tr(),
                                  function: () => bloc.add(SoundEvent(sound: !mainBloc.sound)),
                                  endElement: SizedBox(
                                    height: width * .06,
                                    child: ToggleButtons(
                                      constraints: BoxConstraints(
                                        minWidth: width * .1,
                                        minHeight: width * .06,
                                      ),
                                      selectedColor: AppColors.whiteConst,
                                      color: AppColors.whiteConst,
                                      fillColor: AppColors.purple,
                                      splashColor: AppColors.purple,
                                      borderColor: AppColors.whiteConst,
                                      borderWidth: 0.3,
                                      borderRadius: BorderRadius.circular(6),
                                      isSelected: [!mainBloc.sound, mainBloc.sound],
                                      onPressed: (i) => bloc.add(SoundEvent(sound: i == 1)),
                                      children: <Widget>[
                                        Icon(Icons.music_off, size: width * .04),
                                        Icon(Icons.music_note, size: width * .04),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: width * .015),

                                // #language
                                MyProfileButton(
                                  text: 'current_lang'.tr(),
                                  function: () => bloc.add(LanguageEvent()),
                                  endElement: Image(
                                    image: AssetImage('assets/icons/ic_flag_${bloc.selectedLang.name}.png'),
                                    width: width * .05,
                                    height: width * .05,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(height: width * .015),

                                // #sign_out
                                MyProfileButton(
                                  text: 'sign_out'.tr(),
                                  function: () => bloc.add(SignOutEvent()),
                                  endElement: Icon(CupertinoIcons.square_arrow_right, size: width * .05, color: AppColors.whiteConst),
                                ),
                                SizedBox(height: width * .015),

                                // #delete_account
                                MyProfileButton(
                                  text: 'delete_account'.tr(),
                                  function: () => bloc.add(DeleteAccountEvent()),
                                  endElement: Icon(CupertinoIcons.delete, size: width * .05, color: AppColors.whiteConst),
                                ),
                                SizedBox(height: width * .015),

                                // #tutorial
                                MyProfileButton(
                                  text: 'tutorial'.tr(),
                                  function: () => bloc.add(TutorialEvent()),
                                  endElement: Icon(CupertinoIcons.book, size: width * .05, color: AppColors.whiteConst),
                                ),
                                SizedBox(height: width * .015),

                                // #info
                                MyProfileButton(
                                  text: 'info'.tr(),
                                  function: () => bloc.add(InfoEvent()),
                                  endElement: Icon(CupertinoIcons.info, size: width * .05, color: AppColors.whiteConst),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // #choose_language_screen
                    if (state is ProfileLangState)
                      MyProfileScreen(
                        doneButton: true,
                        textTitle: 'choose_lang'.tr(language: bloc.selectedLang),
                        textCancel: 'cancel'.tr(language: bloc.selectedLang),
                        textDone: 'done'.tr(language: bloc.selectedLang),
                        functionCancel: () => bloc.add(CancelEvent()),
                        functionDone: () => bloc.add(DoneEvent(context: context)),
                        // #languages
                        child: SizedBox(
                          height: 300,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            padding: EdgeInsets.zero,
                            itemBuilder: (c, index) {
                              return RadioListTile(
                                  fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColors.whiteConst;
                                    } else {
                                      return AppColors.purple;
                                    }
                                  }),
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  contentPadding: EdgeInsets.zero,
                                  secondary: Image(
                                    image: AssetImage('assets/icons/ic_flag_${bloc.lang[index].name}.png'),
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.fill,
                                  ),
                                  title: Text(
                                    'button_$index'.tr(),
                                    style: AppTextStyles.style13(context).copyWith(color: AppColors.whiteConst),
                                  ),
                                  selected: bloc.lang[index] == bloc.selectedLang,
                                  value: bloc.lang[index],
                                  groupValue: bloc.selectedLang,
                                  onChanged: (value) => bloc.add(ConfirmLanguageEvent(lang: value as Language)));
                            },
                          ),
                        ),
                      ),

                    // #sign_out_screen
                    if (state is ProfileSignOutState)
                      MyProfileScreen(
                        doneButton: true,
                        textTitle: 'sign_out'.tr(),
                        textCancel: 'cancel'.tr(),
                        textDone: 'confirm'.tr(),
                        functionCancel: () => bloc.add(CancelEvent()),
                        functionDone: () => bloc.add(ConfirmEvent(context: context)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text('confirm_sign_out'.tr(), style: AppTextStyles.style13(context).copyWith(color: AppColors.whiteConst)),
                        ),
                      ),

                    // #delete_account_screen
                    if (state is ProfileDeleteAccountState)
                      MyProfileScreen(
                        doneButton: true,
                        textTitle: 'delete_account'.tr(),
                        textCancel: 'cancel'.tr(),
                        textDone: 'confirm'.tr(),
                        functionCancel: () => bloc.add(CancelEvent()),
                        functionDone: () => bloc.add(ConfirmEvent(context: context, delete: true)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text('confirm_delete_account'.tr(),
                              style: AppTextStyles.style13(context).copyWith(color: AppColors.whiteConst)),
                        ),
                      ),

                    // #tutorial_screen
                    if (state is ProfileTutorialState)
                      MyProfileScreen(
                        doneButton: true,
                        textTitle: 'tutorial'.tr(),
                        textCancel: 'back'.tr(),
                        textDone: 'confirm'.tr(),
                        functionCancel: () => bloc.add(CancelEvent()),
                        functionDone: () => bloc.add(ConfirmEvent(context: context, tutorial: true)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text('tutorial_text'.tr(), style: AppTextStyles.style13(context).copyWith(color: AppColors.whiteConst)),
                        ),
                      ),

                    // #info_screen
                    if (state is ProfileInfoState)
                      MyProfileScreen(
                        textTitle: 'info'.tr(),
                        textCancel: 'back'.tr(),
                        functionCancel: () => bloc.add(CancelEvent()),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text('info_text'.tr(), style: AppTextStyles.style13(context).copyWith(color: AppColors.whiteConst)),
                        ),
                      ),

                    // #loading_screen
                    if (state is ProfileLoadingState)
                      myIsLoading(context),
                  ],
                );
              });
        });
  }
}
