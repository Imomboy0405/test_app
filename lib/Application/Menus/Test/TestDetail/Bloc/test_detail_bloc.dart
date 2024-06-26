import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Test/Quiz/View/quiz_page.dart';

part 'test_detail_event.dart';
part 'test_detail_state.dart';

class TestDetailBloc extends Bloc<TestDetailEvent, TestDetailState> {
  int asset = 0;

  TestDetailBloc() : super(TestDetailInitialState()) {
    on<StartTestEvent>((event, emit) {
      Navigator.pushNamed(event.context, QuizPage.id);
    });
  }
}
