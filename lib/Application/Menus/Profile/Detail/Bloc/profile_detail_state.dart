part of 'profile_detail_bloc.dart';

sealed class ProfileDetailState extends Equatable {
  const ProfileDetailState();
}

final class ProfileDetailInitialState extends ProfileDetailState {
  final List<int> currentIndexes;
  final UserModel userModel;

  const ProfileDetailInitialState({
    required this.currentIndexes,
    required this.userModel,
  });

  @override
  List<Object> get props => [currentIndexes, userModel];
}

final class ProfileDetailLoadingState extends ProfileDetailState {
  @override
  List<Object> get props => [];
}
