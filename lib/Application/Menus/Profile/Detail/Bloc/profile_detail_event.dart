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
  final String id;
  final dynamic value;

  const UpdateDetailPageEvent({
    required this.id,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];
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

class InitialDataEvent extends ProfileDetailEvent {
  final int index;

  const InitialDataEvent({this.index = -1});

  @override
  List<Object?> get props => [index];

}
