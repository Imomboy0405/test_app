import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/View/test_detail_page.dart';
import 'package:test_app/Data/Services/db_service.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  MainBloc mainBloc;

  List<String> question = [
    '20',
    '20',
    '20',
  ];

  final keyTest = GlobalKey(debugLabel: 'showTest');

  TestBloc({required this.mainBloc}) : super(TestInitialState()) {
    on<EnterTestEvent>(pressEnterTest);
    on<ShowCaseEvent>(showCase);
  }

  Future<void> showCase(ShowCaseEvent event, Emitter<TestState> emit) async {
    ShowCaseWidget.of(event.context).startShowCase([keyTest]);
    emit(TestInitialState());
    mainBloc.showCaseModel.test = true;
    await DBService.saveShowCase(mainBloc.showCaseModel);
  }

  void pressEnterTest(EnterTestEvent event, Emitter<TestState> emit) {
    Navigator.pushNamed(event.context, TestDetailPage.id, arguments: event.index);
  }
}
