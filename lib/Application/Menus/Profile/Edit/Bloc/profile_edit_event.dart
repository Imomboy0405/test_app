part of 'profile_edit_bloc.dart';

sealed class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();
}

class InitialEvent extends ProfileEditEvent {
  final String? phone;

  const InitialEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class ChangeEvent extends ProfileEditEvent {
  @override
  List<Object?> get props => [];
}

class SaveEvent extends ProfileEditEvent {
  final BuildContext context;

  const SaveEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
