import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/View/test_detail_page.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Data/Services/db_service.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  MainBloc mainBloc;
  int asset = 0;
  List<String> question = [
    '19',
    '21',
    '21',
  ];
  bool animation = true;

  final keyTest = GlobalKey(debugLabel: 'showTest');

  TestBloc({required this.mainBloc}) : super(TestInitialState()) {
    on<EnterTestEvent>(pressEnterTest);
    on<ShowCaseEvent>(showCase);
    on<ShowCaseTapEvent>(tapShowCase);
  }

  Future<void> tapShowCase(ShowCaseTapEvent event, Emitter<TestState> emit) async {
    mainBloc.showCaseModel.test = true;
    await DBService.saveShowCase(mainBloc.showCaseModel);
    emit(TestInitialState());
  }

  Future<void> showCase(ShowCaseEvent event, Emitter<TestState> emit) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (event.context.mounted) {
        ShowCaseWidget.of(event.context).startShowCase([keyTest]);
      }
    });
    emit(TestInitialState());
  }

  void pressEnterTest(EnterTestEvent event, Emitter<TestState> emit) {
    asset = event.index;
    myAnimatedPush(context: event.context, pushPage: const TestDetailPage(), offset: const Offset(0, .7));
  }
}
