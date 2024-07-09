import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Models/show_case_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CarouselController carouselController = CarouselController();
  int currentPage = 0;
  int newPage = 0;
  MainBloc mainBloc;
  bool first = true;
  bool helloAnime = true;
  double opacityAnime = 1;
  String fullName = '';
  List<ArticleModel> articles = [];

  final keyCarousel = GlobalKey(debugLabel: 'showCarousel');


  HomeBloc({required this.mainBloc}) : super(HomeLoadingState()) {
    on<HomeScrollCardEvent>(scrollCard);
    on<HomeInitialDataEvent>(initialData);
    on<HomeShowCaseEvent>(showCase);
  }

  void emitInitial(Emitter<HomeState> emit) {
    emit(HomeInitialState(
      fullName: fullName,
      currentPage: currentPage,
      articles: articles,
      opacityAnime: opacityAnime,
      newPage: newPage,
    ));
  }

  Future<void> showCase(HomeShowCaseEvent event, Emitter<HomeState> emit) async {
    ShowCaseWidget.of(event.context).startShowCase([keyCarousel]);
    emitInitial(emit);
    mainBloc.showCaseModel.home = true;
    await DBService.saveShowCase(mainBloc.showCaseModel);
  }

  void initialData(HomeInitialDataEvent event, Emitter<HomeState> emit) async {
    if (first) {
      emit(HomeLoadingState());
      first = false;
      if (mainBloc.userModel == null) {
        String? json = await DBService.loadData(StorageKey.user);
        mainBloc.userModel = userFromJson(json!);
        fullName = mainBloc.userModel!.fullName!;
      }

      String? json = await DBService.loadData(StorageKey.test);
      if (json != null) {
        mainBloc.resultTests = List<int>.from(jsonDecode(json));
      }

      json = null;
      json = await DBService.loadData(StorageKey.showCase);
      if (json != null) {
        mainBloc.showCaseModel = showCaseModelFromJson(json);
      }

      json = null;
      json = await DBService.loadData(StorageKey.sound);
      if (json != null) {
        mainBloc.sound = json == 'true';
      }

      if (articles.isEmpty) {
        articles = articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      }
      emitInitial(emit);
    }
  }

  void scrollCard(HomeScrollCardEvent event, Emitter<HomeState> emit) async {
    opacityAnime = 0;
    emitInitial(emit);
    if (event.page != currentPage) {
      currentPage = event.page;
      emitInitial(emit);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    newPage = currentPage;
    opacityAnime = 1;
    emitInitial(emit);
  }
}
