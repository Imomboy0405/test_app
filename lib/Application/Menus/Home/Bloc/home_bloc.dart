
import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CarouselController carouselController = CarouselController();
  int currentPage = 1;

  HomeBloc() : super(const HomeInitialState(currentPage: 1)) {
    on<HomeScrollCardEvent>(scrollCard);
  }

  void scrollCard(HomeScrollCardEvent event, Emitter<HomeState> emit) {
    currentPage = event.page + 1;
    emit(HomeInitialState(currentPage: currentPage));
  }
}
