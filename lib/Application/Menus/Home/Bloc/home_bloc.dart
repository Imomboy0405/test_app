import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CarouselController carouselController = CarouselController();
  int currentPage = 1;
  MainBloc mainBloc = locator<MainBloc>();
  bool first = true;
  String fullName = '';

  HomeBloc() : super(const HomeInitialState(currentPage: 1, fullName: '')) {
    on<HomeScrollCardEvent>(scrollCard);
    on<InitialDataEvent>(initialData);
  }

  void initialData(InitialDataEvent event, Emitter<HomeState> emit) async {
    if (first) {
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
      emit(HomeInitialState(currentPage: currentPage, fullName: fullName));
    }
  }

  void scrollCard(HomeScrollCardEvent event, Emitter<HomeState> emit) {
    int newPage = event.page + 1;
    if (newPage != currentPage) {
      currentPage = newPage;
      emit(HomeInitialState(currentPage: currentPage, fullName: fullName));
    }
  }
}
