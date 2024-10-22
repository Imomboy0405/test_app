part of 'profile_edit_bloc.dart';

sealed class ProfileEditState extends Equatable {
  const ProfileEditState();
}

final class ProfileEditInitial extends ProfileEditState {
  final bool suffixDone;

  const ProfileEditInitial({required this.suffixDone});

  @override
  List<Object> get props => [suffixDone];
}

final class ProfileEditLoading extends ProfileEditState {
  const ProfileEditLoading();

  @override
  List<Object> get props => [];
}
