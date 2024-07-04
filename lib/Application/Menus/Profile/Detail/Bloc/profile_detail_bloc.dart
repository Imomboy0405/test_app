import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

part 'profile_detail_event.dart';
part 'profile_detail_state.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  List<int> currentIndexes = List.filled(5, 0);
  final ProfileBloc profileBloc;
  bool initial = true;

  ScrollController controller = ScrollController();
  final keyCheckBox = GlobalKey(debugLabel: 'showCheckBox');
  bool showCheckBox = false;
  bool firstCheckBox = false;
  final keyNextButton = GlobalKey(debugLabel: 'showNextButton');
  bool firstNextButton = false;
  bool showBMI = false;
  final keyBMI = GlobalKey(debugLabel: 'showBMi');
  bool showSaveButton = false;
  final keySaveButton = GlobalKey(debugLabel: 'showSave');

  ProfileDetailBloc({required this.profileBloc})
      : super(ProfileDetailInitialState(
          currentIndexes: const [0, 0, 0, 0, 0],
          userModel: locator<ProfileBloc>().userModel!,
        )) {
    on<UpdateDetailPageEvent>(updateDetail);
    on<UpdateDetailExpansionPanelEvent>(updateExpansionPanel);
    on<DetailLoadingEvent>(loadingPage);
    on<DetailPopEvent>(popInvoiced);
    on<ShowCaseEvent>(showCase);
  }

  void initialData() {
    initial = false;
    if (!profileBloc.mainBloc.showCaseModel.profileDetail) {
      showCheckBox = true;
      firstCheckBox = true;
    }
  }

  Future<void> showCase(ShowCaseEvent event, Emitter<ProfileDetailState> emit) async {
    if (showCheckBox) {
      showCheckBox = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keyCheckBox]));
    } else if (event.tapCheckBox) {
      firstNextButton = true;
      currentIndexes = List.from(currentIndexes);
      currentIndexes[0] = -1;
      emitDetail(emit);
    } else if (firstNextButton) {
      firstNextButton = false;
      await Future.delayed(const Duration(milliseconds: 600));
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keyNextButton]));
      emitDetail(emit);
    } else if (event.tapNextButton) {
      profileBloc.add(NextEvent(index: 4, context: event.context));
      showBMI = true;
    } else if (showBMI) {
      showBMI = false;
      await Future.delayed(const Duration(milliseconds: 300));
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keyBMI]));
      emitDetail(emit);
    } else if (event.tapBMI) {
      showSaveButton = true;
      emitDetail(emit);
    } else if (showSaveButton) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(event.context).startShowCase([keySaveButton]));
      showSaveButton = false;
    } else if (event.tapSave) {
      profileBloc.add(NextEvent(index: 0, context: event.context));
      currentIndexes[0] = 0;
      profileBloc.mainBloc.showCaseModel.profileDetail = true;
      await DBService.saveShowCase(profileBloc.mainBloc.showCaseModel);
    }
  }

  void emitDetail(Emitter<ProfileDetailState> emit) {
    emit(ProfileDetailInitialState(
      currentIndexes: currentIndexes,
      userModel: profileBloc.userModel!.deepCopy(),
    ));
  }

  void loadingPage(DetailLoadingEvent event, Emitter<ProfileDetailState> emit) {
    emit(ProfileDetailLoadingState());
  }

  void popInvoiced(DetailPopEvent event, Emitter<ProfileDetailState> emit) {
    profileBloc.currentTab = 0;
  }

  void updateExpansionPanel(UpdateDetailExpansionPanelEvent event, Emitter<ProfileDetailState> emit) {
    currentIndexes = List.from(currentIndexes);
    currentIndexes[event.tabIndex] = event.pressSaveButton
        ? currentIndexes[event.tabIndex] = event.value
        : currentIndexes[event.tabIndex] == event.value
            ? -1
            : event.value;
    emitDetail(emit);
  }

  void updateDetail(UpdateDetailPageEvent event, Emitter<ProfileDetailState> emit) {
    if (event.bmi) {
      if (event.bmiHeight) {
        profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value =
            event.value >= 100
                ? event.value ~/ 1
                : profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value;
      } else {
        profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value =
            event.value >= 40
                ? event.value ~/ 1
                : profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value;
      }
    } else {
      if (event.expansionPanel) {
        if (event.tabIndex == 3) {
          if (event.userDetailModelIndex >= 7) {
            if ((event.value is int && event.value == 0) ||
                (event.value is bool && ((event.entryIndex == 0 && event.value) || (event.entryIndex == 1 && !event.value)))) {
              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[0] =
                  profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[0].copyWith(value: true);
              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[1] =
                  profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[1].copyWith(value: false);
              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2] =
                  profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2].copyWith(value: 0);
            } else {
              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[0] =
                  profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[0].copyWith(value: false);
              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[1] =
                  profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[1].copyWith(value: true);

              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2] =
                  profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2].copyWith(
                      value: profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2].value == null ||
                              profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2].value < 1
                          ? 1
                          : profileBloc.userModel!.userDetailList[3][event.userDetailModelIndex].entries[2].value);
            }
          } else if (event.userDetailModelIndex == 6) {
            if (event.entryIndex == 0) {
              profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[1] = profileBloc
                  .userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[1]
                  .copyWith(value: !event.value);
              profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[2] = profileBloc
                  .userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[2]
                  .copyWith(value: !event.value);
            } else if (event.value) {
              profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[0] =
                  profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[0].copyWith(value: false);
            } else if (profileBloc
                    .userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex == 1 ? 2 : 1].value ==
                false) {
              profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[0] =
                  profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[0].copyWith(value: true);
            }
          } else if (event.userDetailModelIndex >= 4) {
            if (event.value) {
              profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex == 0 ? 1 : 0] =
                  profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex == 0 ? 1 : 0]
                      .copyWith(value: false);
            } else {
              profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex == 0 ? 1 : 0] =
                  profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex == 0 ? 1 : 0]
                      .copyWith(value: true);
            }
          } else {
            profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries = profileBloc
                .userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries
                .map<Entries>((entry) => entry.copyWith(value: false) as Entries)
                .toList();
          }
        }
        if (event.bloodPressureIndex == 0) {
          profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value = event.value;
        } else {
          profileBloc.userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value = profileBloc
              .userModel!.userDetailList[event.tabIndex][event.userDetailModelIndex].entries[event.entryIndex].value
              .replaceRange(event.bloodPressureIndex == 1 ? 0 : 4, event.bloodPressureIndex == 1 ? 3 : 7,
                  event.value < 100 ? '0${event.value}' : event.value.toString());
        }
      } else {
        profileBloc.userModel!.userDetailList[event.tabIndex][event.entryIndex].value = event.value;
      }
    }
    emitDetail(emit);
  }
}
