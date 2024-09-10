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
    ProfileDetailBloc bloc = ProfileDetailBloc(profileBloc: locator<ProfileBloc>())..add(const InitialDataEvent());
    return BlocBuilder<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => bloc,
            child: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
              bloc: bloc,
              builder: (context, state) {
                return PopScope(
                  canPop: state is! ProfileDetailLoadingState,
                  onPopInvokedWithResult: (v, d) => bloc.add(DetailPopEvent()),
                  child: Stack(
                    children: [
                      if (state is ProfileDetailInitialState)
                        Scaffold(
                          backgroundColor: AppColors.black,
                          appBar: MyAppBar(titleText: profileBloc.fullName, purpleBackground: true),
                          body: DefaultTabController(
                            length: 5,
                            initialIndex: profileBloc.currentTab,
                            child: Builder(
                              builder: (context) {
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
                                          tabs: profileBloc.userDetailList
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry) => Tab(
                                                  height: width * .09,
                                                  child: myTab(
                                                      title: bloc.profileBloc.userDetailList[entry.key].title!['ru'],
                                                      index: entry.key,
                                                      currentIndex: profileBloc.currentTab),
                                                ),
                                              )
                                              .toList()),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: DefaultTabController.of(context),
                                        children: [
                                          for (int i = 0; i <= 4; i++)
                                            Builder(
                                              builder: (context) => SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ProfileDetailTabScreen(
                                                        userDetailModel: profileBloc.userDetailList[i], tabIndex: i, bloc: bloc),
                                                    Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: ShowCaseWidget(
                                                        builder: (contextShowCase) {
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
                                                          return MyButton(
                                                            enable: true,
                                                            function: () => profileBloc.add(NextEvent(index: i + 1, context: context, values: bloc.values)),
                                                            text: i < 4 ? 'next'.tr() : 'save'.tr(),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      if (state is ProfileDetailLoadingState)
                        Scaffold(
                          backgroundColor: AppColors.black,
                          body: myIsLoading(context),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        });
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
  final UserDetailModel userDetailModel;
  final int tabIndex;
  late final ProfileDetailBloc bloc;

  ProfileDetailTabScreen({super.key, required this.userDetailModel, required this.tabIndex, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: SingleChildScrollView(
        controller: bloc.controller,
        child: (userDetailModel.title?['ru'] == 'Общее физическое обследование')
            ? Column(
                children: userDetailModel.entries
                    .map<Widget>((v) => (v.flex != null && v.flex == true)
                        ? (v.id == '0fd45f50-c0e1-46be-a69e-9c8901d1c366')
                            ? bmi(
                                context: context,
                                bloc: bloc,
                                userDetailModelIndex: v.index,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Row(
                                children: v.entries!
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
                                entry: v.entries![0],
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
                                entry: v.entries![0],
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
                children: userDetailModel.entries.map<Widget>((entry) {
                  if (entry.type == 'group') {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.whiteConst),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Theme(
                          data: Theme.of(context).copyWith(splashColor: AppColors.pink, highlightColor: AppColors.pink),
                          child: ExpansionPanelList(
                            materialGapSize: 10,
                            expansionCallback: (int index, bool isExpanded) =>
                                bloc.add(UpdateDetailExpansionPanelEvent(tabIndex: tabIndex, value: entry.index)),
                            animationDuration: const Duration(milliseconds: 700),
                            elevation: 0,
                            expandIconColor: AppColors.whiteConst,
                            children: [
                              ExpansionPanel(
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(entry.title != null ? entry.title!['ru']! : 'null', style: AppTextStyles.style4(context)),
                                  );
                                },
                                isExpanded: bloc.currentIndexes[tabIndex] == entry.index,
                                canTapOnHeader: true,
                                backgroundColor: AppColors.purpleAccent,
                                body: Column(
                                  children: entry.entries!
                                      .map(
                                        (entryChild) => myProfileCheckBox(
                                          entry: entryChild,
                                          context: context,
                                          bloc: bloc,
                                          tabIndex: tabIndex,
                                          userDetailModelIndex: entryChild.index,
                                          expansionPanel: true,
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return myProfileCheckBox(
                      entry: entry,
                      context: context,
                      bloc: bloc,
                      tabIndex: tabIndex,
                      userDetailModelIndex: entry.index,
                    );
                  }
                }).toList(),
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
                    ? bloc.values[profileBloc.currentTab]['d13fd2c7-dc48-4f55-95bf-1debd577bc98'] ?? 120
                    : bloc.values[profileBloc.currentTab][entry.id] ?? 80
                : bloc.values[profileBloc.currentTab][entry.id] ?? 90,
            minValue: entry.min ?? 0,
            maxValue: entry.max ?? 50,
            itemWidth: hereditaryFactors ? width * .1 : width * .25,
            itemHeight: hereditaryFactors ? width * .08 : width * .1,
            onChanged: (value) => bloc.add(UpdateDetailPageEvent(
                id: entry.id == 'd0de0764-53dd-44a2-bfca-676793078b2a' && bloodPressureIndex == 1
                    ? 'd13fd2c7-dc48-4f55-95bf-1debd577bc98'
                    : entry.id,
                value: value)),
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
                Text(entry.title?['ru'] ?? 'null', style: AppTextStyles.style19(context)),
                const SizedBox(width: 5),
                anthropometryChildren(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bloodPressureIndex != 2
                    ? Text(entry.title?['ru'] ?? 'null', style: AppTextStyles.style18_0(context))
                    : const SizedBox.shrink(),
                anthropometryChildren(),
              ],
            ),
    );
  }

  SliderTheme bmi({
    required BuildContext context,
    required ProfileDetailBloc bloc,
    required int userDetailModelIndex,
    required double width,
  }) =>
      SliderTheme(
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
                '${profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries?[0].title?['ru']}: ${(bloc.values[profileBloc.currentTab][profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries?[0].id] ?? 177) ~/ 1} '
                '${profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries?[1].title?['ru']}: ${(bloc.values[profileBloc.currentTab][profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries![1].id] ?? 77) ~/ 1}',
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
                                  value: (bloc.values[profileBloc.currentTab][profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries?[0].id] ??
                                          177)
                                      .toDouble(),
                                  min: 0,
                                  max: 200,
                                  onChanged: (value) => value > 120
                                      ? bloc.add(UpdateDetailPageEvent(
                                          id: profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries![0].id,
                                          value: value,
                                        ))
                                      : (),
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
                          height: (bloc.values[profileBloc.currentTab][profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries?[0].id] ?? 177) /
                              200 *
                              width *
                              .5,
                          width: (bloc.values[profileBloc.currentTab][profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries![1].id] ?? 77) /
                              100 *
                              width *
                              .35,
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
                              value: (bloc.values[profileBloc.currentTab][profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries![1].id] ?? 77)
                                  .toDouble(),
                              min: 0,
                              max: 100,
                              onChanged: (value) => value > 40
                                  ? bloc.add(UpdateDetailPageEvent(
                                      id: profileBloc.userDetailList[tabIndex].entries[userDetailModelIndex].entries![1].id,
                                      value: value,
                                    ))
                                  : (),
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
  }) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: expansionPanel ? 4 : 8, vertical: 4),
        decoration: BoxDecoration(
            color: expansionPanel ? Colors.black.withOpacity(.1) : AppColors.purpleAccent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.whiteConst, width: .7)),
        child: Theme(
          data: ThemeData(
            splashColor: AppColors.pink,
            highlightColor: AppColors.pink,
            checkboxTheme: const CheckboxThemeData(side: BorderSide(color: AppColors.whiteConst, width: 2)),
          ),
          child: CheckboxListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            selectedTileColor: AppColors.red,
            value: bloc.values[profileBloc.currentTab][entry.id] ?? false,
            activeColor: AppColors.whiteConst,
            contentPadding: EdgeInsets.zero,
            checkColor: AppColors.purple,
            onChanged: (value) => bloc.add(UpdateDetailPageEvent(id: entry.id, value: value)),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: entryKg == null
                  ? Text(entry.title!['ru']!, style: AppTextStyles.style19(context))
                  : Row(
                      children: [
                        Text(entry.title.toString(), style: AppTextStyles.style19(context)),
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
            ),
          ),
        ),
      );
}
