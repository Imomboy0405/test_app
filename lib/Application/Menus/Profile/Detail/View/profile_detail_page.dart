import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Detail/Bloc/profile_detail_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class ProfileDetailPage extends StatelessWidget {
  static const id = '/profile_detail_page';

  const ProfileDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = locator<ProfileBloc>();
    final mainBloc = locator<MainBloc>();
    final double width = MediaQuery.of(context).size.width;
    if (mainBloc.userModel!.userDetailList.isEmpty) {
      mainBloc.userModel!.userDetailList = profileBloc.profileDetailJsons
          .map((list) => list.map((v) => v['type'] == 'boolean' ? Entries.fromJson(v) : UserDetailModel.fromJson(v)).toList())
          .toList();
    }
    profileBloc.userModel = mainBloc.userModel!.deepCopy();
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => ProfileDetailBloc(profileBloc: locator<ProfileBloc>()),
          child: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
            builder: (context, state) {
              ProfileDetailBloc bloc = context.read<ProfileDetailBloc>();
              if (bloc.initial) {
                bloc.initialData();
              }
              return PopScope(
                canPop: state is! ProfileDetailLoadingState,
                onPopInvoked: (v) => bloc.add(DetailPopEvent()),
                child: Stack(
                  children: [
                    Scaffold(
                      backgroundColor: AppColors.black,
                      appBar: MyAppBar(titleText: profileBloc.fullName, purpleBackground: true),
                      body: DefaultTabController(
                        length: 5,
                        initialIndex: profileBloc.currentTab,
                        child: Builder(builder: (context) {
                          profileBloc.add(ListenScrollEvent(context: context));
                          return Column(
                            children: [
                              Container(
                                color: AppColors.purpleAccent,
                                child: TabBar(
                                  controller: DefaultTabController.of(context),
                                  tabAlignment: TabAlignment.start,
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  isScrollable: true,
                                  dividerColor: AppColors.transparent,
                                  indicatorColor: AppColors.whiteConst,
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                                  tabs: [
                                    Tab(
                                      height: width * .09,
                                      child: myTab(title: 'medical_history'.tr(), index: 0, currentIndex: profileBloc.currentTab),
                                    ),
                                    Tab(
                                      height: width * .09,
                                      child: myTab(title: 'medications_taken'.tr(), index: 1, currentIndex: profileBloc.currentTab),
                                    ),
                                    Tab(
                                      height: width * .09,
                                      child: myTab(title: 'surgical_interventions'.tr(), index: 2, currentIndex: profileBloc.currentTab),
                                    ),
                                    Tab(
                                      height: width * .09,
                                      child: myTab(title: 'hereditary_factors'.tr(), index: 3, currentIndex: profileBloc.currentTab),
                                    ),
                                    Tab(
                                      height: width * .09,
                                      child: myTab(title: 'anthropometry'.tr(), index: 4, currentIndex: profileBloc.currentTab),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: DefaultTabController.of(context),
                                  children: [
                                    for (int i = 0; i < 5; i++)
                                      Builder(
                                        builder: (context) => SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ProfileDetailTabScreen(
                                                  userDetailModels: profileBloc.userModel!.userDetailList[i], tabIndex: i, bloc: bloc),
                                              Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: ShowCaseWidget(builder: (contextShowCase) {
                                                  if (bloc.firstNextButton) {
                                                    bloc.add(ShowCaseEvent(context: contextShowCase));
                                                  }
                                                  if (mainBloc.showCaseModel.profileDetail) {
                                                    return MyButton(
                                                      enable: true,
                                                      function: () => profileBloc.add(NextEvent(index: i + 1, context: context)),
                                                      text: i < 4 ? 'next'.tr() : 'save'.tr(),
                                                    );
                                                  }
                                                  if (i != 0 && i != 4) {
                                                    return MyButton(
                                                      enable: true,
                                                      function: () => profileBloc.add(NextEvent(index: i + 1, context: context)),
                                                      text: i < 4 ? 'next'.tr() : 'save'.tr(),
                                                    );
                                                  }

                                                  if (i == 0) {
                                                    return myShowcase(
                                                      key: bloc.keyNextButton,
                                                      context: contextShowCase,
                                                      title: 'show_next_button_title'.tr(),
                                                      description: 'show_next_button_description'.tr(),
                                                      onTap: () => bloc.add(ShowCaseEvent(context: context, tapNextButton: true)),
                                                      child: MyButton(
                                                        enable: true,
                                                        function: () => profileBloc.add(NextEvent(index: 1, context: context)),
                                                        text: 'next'.tr(),
                                                      ),
                                                    );
                                                  }
                                                  if (bloc.showSaveButton) {
                                                    bloc.add(ShowCaseEvent(context: contextShowCase));
                                                  }
                                                  return myShowcase(
                                                      key: bloc.keySaveButton,
                                                      context: contextShowCase,
                                                      title: 'show_save_button_title'.tr(),
                                                      description: 'show_save_button_description'.tr(),
                                                      onTap: () => bloc.add(ShowCaseEvent(context: context, tapSave: true)),
                                                      child: MyButton(
                                                        enable: true,
                                                        function: () => profileBloc.add(NextEvent(index: 5, context: context)),
                                                        text: 'save'.tr(),
                                                      ));
                                                }),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),

                    // #loading_screen
                    if (state is ProfileDetailLoadingState) myIsLoading(context),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Builder myTab({required title, required index, required currentIndex}) {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: currentIndex == index ? AppColors.whiteConst : AppColors.purple),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(title, style: currentIndex == index ? AppTextStyles.style19(context) : AppTextStyles.style23_0(context)),
      );
    });
  }
}

class ProfileDetailTabScreen extends StatelessWidget {
  final profileBloc = locator<ProfileBloc>();
  final List userDetailModels;
  final int tabIndex;
  late final ProfileDetailBloc bloc;

  ProfileDetailTabScreen({super.key, required this.userDetailModels, required this.tabIndex, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: SingleChildScrollView(
        controller: bloc.controller,
        child: (userDetailModels[0].type == 'group')
            ? userDetailModels[0].flex == null
                ? ExpansionPanelList(
                    materialGapSize: 10,
                    expansionCallback: (int index, bool isExpanded) =>
                        bloc.add(UpdateDetailExpansionPanelEvent(tabIndex: tabIndex, value: index)),
                    animationDuration: const Duration(milliseconds: 700),
                    children: userDetailModels.map<ExpansionPanel>((userDetailModel) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(userDetailModel.title.toString().tr(), style: AppTextStyles.style19(context)),
                          );
                        },
                        isExpanded: bloc.currentIndexes[tabIndex] == userDetailModel.index,
                        canTapOnHeader: true,
                        backgroundColor: AppColors.purpleAccent,
                        body: Column(
                          children: userDetailModel.entries.map<Widget>((entry) {
                            if (tabIndex == 3 && userDetailModel.index >= 7) {
                              if (entry.index == 0) {
                                return myProfileCheckBox(
                                  entry: entry,
                                  context: context,
                                  bloc: bloc,
                                  tabIndex: tabIndex,
                                  userDetailModelIndex: userDetailModel.index,
                                  expansionPanel: true,
                                );
                              } else {
                                if (entry.index == 1) {
                                  return myProfileCheckBox(
                                    entry: entry,
                                    entryKg: userDetailModel.entries[2],
                                    context: context,
                                    bloc: bloc,
                                    tabIndex: tabIndex,
                                    userDetailModelIndex: userDetailModel.index,
                                    expansionPanel: true,
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                            } else {
                              if (bloc.firstCheckBox) {
                                bloc.firstCheckBox = false;
                                return ShowCaseWidget(builder: (context) {
                                  bloc.add(ShowCaseEvent(context: context));
                                  return myShowcase(
                                    context: context,
                                    key: bloc.keyCheckBox,
                                    title: 'show_check_box_title'.tr(),
                                    description: 'show_check_box_description'.tr(),
                                    onTap: () => bloc.add(ShowCaseEvent(context: context, tapCheckBox: true)),
                                    child: myProfileCheckBox(
                                      entry: entry,
                                      context: context,
                                      bloc: bloc,
                                      tabIndex: tabIndex,
                                      userDetailModelIndex: userDetailModel.index,
                                      expansionPanel: true,
                                    ),
                                  );
                                });
                              } else {
                                return myProfileCheckBox(
                                  entry: entry,
                                  context: context,
                                  bloc: bloc,
                                  tabIndex: tabIndex,
                                  userDetailModelIndex: userDetailModel.index,
                                  expansionPanel: true,
                                );
                              }
                            }
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  )
                : Column(
                    children: userDetailModels
                        .map<Widget>((v) => (v.flex != null && v.flex == true)
                            ? (v.id == '0fd45f50-c0e1-46be-a69e-9c8901d1c366')
                                ? bmi(
                                    context: context,
                                    bloc: bloc,
                                    userDetailModelIndex: v.index,
                                    height: v.entries[0].value.toDouble(),
                                    weight: v.entries[1].value.toDouble(),
                                    width: MediaQuery.of(context).size.width,
                                  )
                                : Row(
                                    children: v.entries
                                        .map<Widget>((entry) => Expanded(
                                                child: anthropometry(
                                              entry: entry,
                                              context: context,
                                              axis: Axis.vertical,
                                              bloc: bloc,
                                              tabIndex: tabIndex,
                                              userDetailModelIndex: v.index,
                                              entryIndex: entry.index,
                                                  width: MediaQuery.of(context).size.width,
                                            )))
                                        .toList(),
                                  )
                            : Column(
                                children: [
                                  anthropometry(
                                      entry: v.entries[0],
                                      context: context,
                                      axis: Axis.horizontal,
                                      bloc: bloc,
                                      tabIndex: tabIndex,
                                      userDetailModelIndex: v.index,
                                      entryIndex: 0,
                                      bloodPressureIndex: 1,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  anthropometry(
                                      entry: v.entries[0],
                                      context: context,
                                      axis: Axis.horizontal,
                                      bloc: bloc,
                                      tabIndex: tabIndex,
                                      userDetailModelIndex: v.index,
                                      entryIndex: 0,
                                      bloodPressureIndex: 2,
                                      width: MediaQuery.of(context).size.width,
                                  ),
                                ],
                              ))
                        .toList(),
                  )
            : Column(
                children: userDetailModels
                    .map<Widget>((entry) => myProfileCheckBox(
                          entry: entry,
                          context: context,
                          bloc: bloc,
                          tabIndex: tabIndex,
                          userDetailModelIndex: entry.index,
                        ))
                    .toList(),
              ),
      ),
    );
  }

  Padding anthropometry({
    required Entries entry,
    required BuildContext context,
    required Axis axis,
    required ProfileDetailBloc bloc,
    required int tabIndex,
    required int userDetailModelIndex,
    required int entryIndex,
    required double width,
    bool hereditaryFactors = false,
    int bloodPressureIndex = 0,
  }) {
    Container anthropometryChildren() => Container(
          decoration: BoxDecoration(
            color: hereditaryFactors ? AppColors.whiteConst : AppColors.purpleAccent.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: NumberPicker(
            value: entry.id == 'd0de0764-53dd-44a2-bfca-676793078b2a'
                ? bloodPressureIndex == 1
                    ? int.parse(entry.value.toString().substring(0, entry.value.toString().indexOf('-')))
                    : int.parse(entry.value.toString().substring(entry.value.toString().indexOf('-') + 1, entry.value.toString().length))
                : entry.value ?? 0,
            minValue: entry.min ?? 0,
            maxValue: entry.max ?? 50,
            itemWidth: hereditaryFactors ? width * .1 : width * .25,
            itemHeight: hereditaryFactors ? width * .08 : width * .1,
            onChanged: (value) {
              bloc.add(UpdateDetailPageEvent(
                tabIndex: tabIndex,
                userDetailModelIndex: userDetailModelIndex,
                entryIndex: entryIndex,
                value: value,
                expansionPanel: true,
                bloodPressureIndex: bloodPressureIndex,
              ));
            },
            textStyle: AppTextStyles.style7(context),
            selectedTextStyle: AppTextStyles.style10(context),
            axis: axis,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.purple, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

    return Padding(
      padding: hereditaryFactors ? EdgeInsets.zero : const EdgeInsets.all(10),
      child: hereditaryFactors
          ? Row(
              children: [
                Text(entry.title.toString().tr(), style: AppTextStyles.style19(context)),
                const SizedBox(width: 5),
                anthropometryChildren(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bloodPressureIndex != 2
                    ? Text(entry.title.toString().tr(), style: AppTextStyles.style18_0(context))
                    : const SizedBox.shrink(),
                anthropometryChildren(),
              ],
            ),
    );
  }

  SliderTheme bmi({
    required BuildContext context,
    required ProfileDetailBloc bloc,
    required double height,
    required double weight,
    required int userDetailModelIndex,
    required double width,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.purple,
        inactiveTrackColor: AppColors.purpleAccent.withOpacity(.4),
        thumbColor: AppColors.purple,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: width * .02, pressedElevation: 0),
        trackHeight: width * .01,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width * .3,
            child: Text(
              '${'height_cm'.tr()}: ${profileBloc.userModel!.userDetailList[tabIndex][userDetailModelIndex].entries[0].value ~/ 1} '
              '${'weight_kg'.tr()}: ${profileBloc.userModel!.userDetailList[tabIndex][userDetailModelIndex].entries[1].value ~/ 1}',
              style: AppTextStyles.style18_0(context),
            ),
          ),
          ShowCaseWidget(builder: (context) {
            if (bloc.showBMI) {
              bloc.add(ShowCaseEvent(context: context));
            }
            return myShowcase(
              key: bloc.keyBMI,
              context: context,
              title: 'show_BMI_title'.tr(),
              description: 'show_BMI_description'.tr(),
              onTap: () => bloc.add(ShowCaseEvent(context: context, tapBMI: true)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: width * .5,
                        child: Row(
                          children: [
                            RotatedBox(
                              quarterTurns: -1,
                              child: Slider(
                                value: profileBloc.userModel!.userDetailList[tabIndex][userDetailModelIndex].entries[0].value.toDouble(),
                                min: 0,
                                max: 200,
                                onChanged: (value) {
                                  bloc.add(UpdateDetailPageEvent(
                                    tabIndex: tabIndex,
                                    userDetailModelIndex: userDetailModelIndex,
                                    entryIndex: 0,
                                    value: value,
                                    bmi: true,
                                    bmiHeight: true,
                                  ));
                                },
                              ),
                            ),
                            Column(
                              children: [
                                scaleText(context, '200', true),
                                SizedBox(height: width * .02),
                                scaleText(context, '175', true),
                                SizedBox(height: width * .02),
                                scaleText(context, '150', true),
                                SizedBox(height: width * .02),
                                scaleText(context, '125', true),
                                SizedBox(height: width * .02),
                                scaleText(context, '100', true),
                                SizedBox(height: width * .075),
                                scaleText(context, '50', true),
                                SizedBox(height: width * .07),
                                scaleText(context, '0', true),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        'assets/images/img_bmi.png',
                        height: profileBloc.userModel!.userDetailList[tabIndex][userDetailModelIndex].entries[0].value / 200 * width * .5,
                        width: profileBloc.userModel!.userDetailList[tabIndex][userDetailModelIndex].entries[1].value / 100 * width * .35,
                        fit: BoxFit.fill,
                        color: AppColors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: width * .07),
                    child: Column(
                      children: [
                        SizedBox(
                          width: width * .4,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: width * .025),
                                scaleText(context, '100', false),
                                SizedBox(height: width * .025),
                                scaleText(context, '80', false),
                                SizedBox(height: width * .025),
                                scaleText(context, '60', false),
                                SizedBox(height: width * .024),
                                scaleText(context, '40', false),
                                SizedBox(height: width * .08),
                                scaleText(context, '0', false),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * .35,
                          child: Slider(
                            value: profileBloc.userModel!.userDetailList[tabIndex][userDetailModelIndex].entries[1].value.toDouble(),
                            min: 0,
                            max: 100,
                            onChanged: (value) {
                              bloc.add(UpdateDetailPageEvent(
                                tabIndex: tabIndex,
                                userDetailModelIndex: userDetailModelIndex,
                                entryIndex: 1,
                                value: value,
                                bmi: true,
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Row scaleText(BuildContext context, String text, bool vertical) {
    return Row(
      children: [
        if (vertical)
          Container(
            height: 1,
            width: 8,
            color: AppColors.purple,
          ),
        Text(text, style: AppTextStyles.style21(context)),
        if (!vertical)
          Container(
            height: 1,
            width: 8,
            color: AppColors.purple,
          ),
      ],
    );
  }

  Container myProfileCheckBox({
    required Entries entry,
    Entries? entryKg,
    required BuildContext context,
    required ProfileDetailBloc bloc,
    required int userDetailModelIndex,
    required int tabIndex,
    bool expansionPanel = false,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: expansionPanel ? AppColors.purpleAccent.withOpacity(.3) : AppColors.purpleAccent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.whiteConst, width: .7)),
      child: Theme(
        data: ThemeData(
          checkboxTheme: const CheckboxThemeData(side: BorderSide(color: AppColors.whiteConst, width: 2)),
        ),
        child: CheckboxListTile(
          title: entryKg == null
              ? Text(entry.title.toString().tr(), style: AppTextStyles.style19(context))
              : Row(
                  children: [
                    Text(entry.title.toString().tr(), style: AppTextStyles.style19(context)),
                    const SizedBox(width: 10),
                    anthropometry(
                      entry: entryKg,
                      context: context,
                      axis: Axis.horizontal,
                      bloc: bloc,
                      tabIndex: tabIndex,
                      userDetailModelIndex: userDetailModelIndex,
                      entryIndex: entryKg.index,
                      hereditaryFactors: true,
                      width: MediaQuery.of(context).size.width,
                    )
                  ],
                ),
          value: entry.value ?? false,
          activeColor: AppColors.whiteConst,
          contentPadding: EdgeInsets.zero,
          checkColor: AppColors.purple,
          onChanged: (value) => bloc.add(UpdateDetailPageEvent(
            tabIndex: tabIndex,
            userDetailModelIndex: userDetailModelIndex,
            entryIndex: entry.index,
            value: value ?? false,
            expansionPanel: expansionPanel,
          )),
        ),
      ),
    );
  }
}
