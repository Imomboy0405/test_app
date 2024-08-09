import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Home/View/home_detail_page.dart';
import 'package:test_app/Application/Menus/Home/View/home_doctor_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_constants.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Models/show_case_model.dart';
import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/db_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CarouselSliderController carouselController = CarouselSliderController();
  int currentPage = 0;
  int newPage = 0;
  MainBloc mainBloc;
  bool first = true;
  bool helloAnime = true;
  bool autoPlayCarousel = true;
  double opacityAnime = 1;
  double scaleAnime = 1;
  String fullName = '';
  String selectedCategory = '';
  int selectedCategoryImage = 0;
  List<ArticleModel> articles = [];
  List<String> category =[
    "what_is_menopause",
    "symptoms_and_signs_of_menopause",
    "menopause_hormonal_changes",
    "emotional_and_psychological_aspects_of_menopause",
    "bone_health_and_osteoporosis",
    "cardiovascular_health",
    "sleep_problems",
    "changes_in_weight_and_metabolism",
    "skin_and_hair_problems",
    "treatment_and_therapy_of_menopause",
    "hormone_replacement_therapy_hrt",
    "alternative_and_natural_treatments",
    "nutrition_and_diet_during_menopause",
    "physical_activity_and_exercise",
    "sexual_health",
    "psychological_support_and_counseling",
    "menopause_and_work",
    "support_from_family_and_friends",
    "menopause_and_common_myths",
  ];

  final keyCarousel = GlobalKey(debugLabel: 'showCarousel');
  int doctorNumber = 0;
  Timer? timer;


  HomeBloc({required this.mainBloc}) : super(HomeLoadingState()) {
    on<HomeScrollCardEvent>(scrollCard);
    on<HomeInitialDataEvent>(initialData);
    on<HomeShowCaseEvent>(showCase);
    on<HomePressArticleEvent>(pushDetail);
    on<HomePressDoctorEvent>(pushDoctorInfo);
    on<HomeScaleAnimationEvent>(scaleAnimation);
    on<HomePopDoctorPageEvent>(backHome);
    on<HomeCategoryEvent>(pressCategory);
    on<HomeCancelEvent>(pressCancel);
  }

  void emitInitial(Emitter<HomeState> emit) {
    emit(HomeInitialState(
      fullName: fullName,
      currentPage: currentPage,
      articles: articles,
      opacityAnime: opacityAnime,
      newPage: newPage,
      scaleAnime: scaleAnime,
    ));
  }

  Future<void> showCase(HomeShowCaseEvent event, Emitter<HomeState> emit) async {
    ShowCaseWidget.of(event.context).startShowCase([keyCarousel]);
    emitInitial(emit);
    mainBloc.showCaseModel.home = true;
    await DBService.saveShowCase(mainBloc.showCaseModel);
  }

  Future<void> initialData(HomeInitialDataEvent event, Emitter<HomeState> emit) async {
    if (first) {
      emit(HomeLoadingState());
      first = false;
      mainBloc.darkMode = ThemeService.getTheme == ThemeMode.dark;
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

  Future<void> scrollCard(HomeScrollCardEvent event, Emitter<HomeState> emit) async {
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

  void pushDetail(HomePressArticleEvent event, Emitter<HomeState> emit) {
    myAnimatedPush(context: event.context, pushPage: const HomeDetailPage(), offset: const Offset(0, .7));
  }

  Future<void> pushDoctorInfo(HomePressDoctorEvent event, Emitter<HomeState> emit) async {
    doctorNumber = event.index;
    if (timer != null) timer!.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 2700), (timer) async {
      add(HomeScaleAnimationEvent());
    });
    myAnimatedPush(context: event.context, pushPage: const HomeDoctorPage(), offset: const Offset(1, 0));
    await Future.delayed(const Duration(milliseconds: 1));
    add(HomeScaleAnimationEvent());
  }

  void scaleAnimation(HomeScaleAnimationEvent event, Emitter<HomeState> emit) {
    scaleAnime = scaleAnime == 1 ? .7 : 1;
    emitInitial(emit);
  }

  void backHome(HomePopDoctorPageEvent event, Emitter<HomeState> emit) {
    timer?.cancel();
  }

  void pressCategory(HomeCategoryEvent event, Emitter<HomeState> emit) {
    autoPlayCarousel = false;
    selectedCategory = event.selectedCategory;
    selectedCategoryImage = event.selectedCategoryImage;
    emit(HomeCategoryState());
  }

  void pressCancel(HomeCancelEvent event, Emitter<HomeState> emit) {
    autoPlayCarousel = true;
    emitInitial(emit);
  }
}
