import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Profile/Profile/Bloc/profile_bloc.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/locator_service.dart';

part 'profile_detail_event.dart';
part 'profile_detail_state.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  List<int> currentIndexes = List.filled(5, 0);
  final profileBloc = locator<ProfileBloc>();

  ProfileDetailBloc()
      : super(ProfileDetailInitialState(
          currentIndexes: const [0, 0, 0, 0, 0],
          userModel: locator<ProfileBloc>().userModel!,
        )) {
    on<UpdateDetailPageEvent>(updateDetail);
    on<UpdateDetailExpansionPanelEvent>(updateExpansionPanel);
    on<DetailLoadingEvent>(loadingPage);
    on<DetailPopEvent>(popInvoiced);
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
