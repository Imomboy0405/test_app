part of 'profile_detail_bloc.dart';

sealed class ProfileDetailState extends Equatable {
  const ProfileDetailState();
}

final class ProfileDetailInitialState extends ProfileDetailState {
  final List<int> currentIndexes;
  final List<Map<String, dynamic>> values;

  const ProfileDetailInitialState({
    required this.currentIndexes,
    required this.values,
  });

  @override
  List<Object> get props => [currentIndexes, values];
}

final class ProfileDetailLoadingState extends ProfileDetailState {
  @override
  List<Object> get props => [];
}
