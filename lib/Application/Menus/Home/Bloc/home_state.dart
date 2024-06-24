part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitialState extends HomeState {
  final int currentPage;
  final String fullName;

  const HomeInitialState({required this.fullName, required this.currentPage});

  @override
  List<Object> get props => [currentPage, fullName];
}

final class HomeLoadingState extends HomeState {
  @override
  List<Object> get props => [];
}
