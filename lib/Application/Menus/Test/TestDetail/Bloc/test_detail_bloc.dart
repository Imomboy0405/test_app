import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/Quiz/View/quiz_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Data/Services/db_service.dart';

part 'test_detail_event.dart';
part 'test_detail_state.dart';

class TestDetailBloc extends Bloc<TestDetailEvent, TestDetailState> {
  int asset = 0;
  ScrollController controller = ScrollController();
  MainBloc mainBloc;

  final keyTestDetail = GlobalKey(debugLabel: 'showTestDetail');

  TestDetailBloc({required this.mainBloc}) : super(TestDetailInitialState()) {
    on<StartTestEvent>(startTest);
    on<TestDetailShowCaseEvent>(showCase);
  }

  Future<void> showCase(TestDetailShowCaseEvent event, Emitter<TestDetailState> emit) async {
    controller.jumpTo(controller.position.maxScrollExtent);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (event.context.mounted) {
        ShowCaseWidget.of(event.context).startShowCase([keyTestDetail]);
      }
    });
    emit(TestDetailInitialState());
    mainBloc.showCaseModel.testDetail = true;
    await DBService.saveShowCase(mainBloc.showCaseModel);
  }

  void startTest(StartTestEvent event, Emitter<TestDetailState> emit) {
    myAnimatedPush(context: event.context, pushPage: const QuizPage(), offset: const Offset(-1, 0));
  }
}
