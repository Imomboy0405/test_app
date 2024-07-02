import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CarouselController carouselController = CarouselController();
  int currentPage = 1;
  int newPage = 1;
  MainBloc mainBloc = locator<MainBloc>();
  bool first = true;
  bool autoPlay = true;
  double opacityAnime = 1;
  String fullName = '';
  List<ArticleModel> articles = [];

  HomeBloc() : super(HomeLoadingState()) {
    on<HomeScrollCardEvent>(scrollCard);
    on<InitialDataEvent>(initialData);
  }

  void emitInitial(Emitter<HomeState> emit) {
    emit(HomeInitialState(fullName: fullName, currentPage: currentPage, articles: articles, opacityAnime: opacityAnime, newPage: newPage));
  }

  void initialData(InitialDataEvent event, Emitter<HomeState> emit) async {
    if (first) {
      emit(HomeLoadingState());
      first = false;
      mainBloc = locator<MainBloc>();
      if (mainBloc.userModel == null) {
        String? json = await DBService.loadData(StorageKey.user);
        mainBloc.userModel = userFromJson(json!);
        fullName = mainBloc.userModel!.fullName!;
      }
      String? json = await DBService.loadData(StorageKey.test);
      if (json != null) {
        mainBloc.resultTests = List<int>.from(jsonDecode(json));
      }
      if (articles.isEmpty) {
        articles = articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }
      emitInitial(emit);
    }
  }

  void scrollCard(HomeScrollCardEvent event, Emitter<HomeState> emit) async {
    if (autoPlay) {
      autoPlay = false;
    }
    opacityAnime = 0;
    emitInitial(emit);
    int newPage = event.page + 1;
    if (newPage != currentPage) {
      currentPage = newPage;
      emitInitial(emit);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    this.newPage = currentPage;
    opacityAnime = 1;
    emitInitial(emit);
  }
}
