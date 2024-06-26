import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/View/test_detail_page.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  List<String> question = [
    '20',
    '20',
    '20',
  ];

  TestBloc() : super(TestInitialState()) {
    on<EnterTestEvent>(pressEnterTest);
  }

  void pressEnterTest(EnterTestEvent event, Emitter<TestState> emit) {
    Navigator.pushNamed(event.context, TestDetailPage.id, arguments: event.index);
  }
}
