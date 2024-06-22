import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/Test/Bloc/test_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Services/lang_service.dart';

import 'test_widgets.dart';

class TestPage extends StatelessWidget {
  static const id = '/test_page';

  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          // final mainBloc = BlocProvider.of<MainBloc>(context);
          return BlocProvider(
            create: (context) => TestBloc(),
            child: BlocBuilder<TestBloc, TestState>(
              builder: (context, state) {
                TestBloc bloc = context.read<TestBloc>();
                return Scaffold(
                  backgroundColor: AppColors.transparent,
                  appBar: MyAppBar(titleText: 'test'.tr()),
                  body: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 170,
                    color: AppColors.black,
                    child: Stack(
                      children: [
                        myBackground(context),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [1, 2, 3].map((i) {
                                return Builder(builder: (context) {
                                  return MyTestCard(
                                    imgAsset: 'assets/images/img_test_$i.png',
                                    title: 'card_text_$i'.tr(),
                                    content: 'card_text_$i'.tr(),
                                    question: bloc.question[i - 1],
                                    result: bloc.result[i - 1],
                                    enterTest: () => bloc.add(EnterTestEvent(context: context, index: i)),
                                  );
                                });
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
