part of 'profile_detail_bloc.dart';

sealed class ProfileDetailEvent extends Equatable {
  const ProfileDetailEvent();
}

class DetailLoadingEvent extends ProfileDetailEvent {
  @override
  List<Object?> get props => [];
}

class DetailPopEvent extends ProfileDetailEvent {
  @override
  List<Object?> get props => [];
}

class UpdateDetailPageEvent extends ProfileDetailEvent {
  final int tabIndex;
  final int userDetailModelIndex;
  final int entryIndex;
  final dynamic value;
  final bool expansionPanel;
  final bool bmi;
  final bool bmiHeight;
  final int bloodPressureIndex;

  const UpdateDetailPageEvent({
    required this.tabIndex,
    required this.userDetailModelIndex,
    required this.entryIndex,
    required this.value,
    this.expansionPanel = false,
    this.bmi = false,
    this.bmiHeight = false,
    this.bloodPressureIndex = 0,
  });

  @override
  List<Object?> get props => [tabIndex, userDetailModelIndex, entryIndex, value, expansionPanel, bmi, bmiHeight, bloodPressureIndex];
}

class UpdateDetailExpansionPanelEvent extends ProfileDetailEvent {
  final int tabIndex;
  final int value;
  final bool pressSaveButton;

  const UpdateDetailExpansionPanelEvent({required this.tabIndex, required this.value, this.pressSaveButton = false});

  @override
  List<Object?> get props => [tabIndex, value, false];
}

class ShowCaseEvent extends ProfileDetailEvent {
  final BuildContext context;
  final bool tapCheckBox;
  final bool tapNextButton;
  final bool tapBMI;
  final bool tapSave;

  const ShowCaseEvent({
    required this.context,
    this.tapCheckBox = false,
    this.tapNextButton = false,
    this.tapBMI = false,
    this.tapSave = false,
  });

  @override
  List<Object?> get props => [context, tapCheckBox, tapNextButton, tapBMI, tapSave];
}
