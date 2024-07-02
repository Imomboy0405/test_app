part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitialState extends HomeState {
  final int currentPage;
  final int newPage;
  final String fullName;
  final double opacityAnime;
  final List<ArticleModel> articles;

  const HomeInitialState({
    required this.fullName,
    required this.currentPage,
    required this.articles,
    required this.opacityAnime,
    required this.newPage,
  });

  @override
  List<Object> get props => [currentPage, fullName, articles, opacityAnime, newPage];
}

final class HomeLoadingState extends HomeState {
  @override
  List<Object> get props => [];
}
