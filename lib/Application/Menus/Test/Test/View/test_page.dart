import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Test/Test/Bloc/test_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

import 'test_widgets.dart';

class TestPage extends StatelessWidget {
  static const id = '/test_page';

  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc mainBloc = locator<MainBloc>();
    return BlocBuilder<MainBloc, MainState>(
      bloc: mainBloc,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => TestBloc(mainBloc: locator<MainBloc>()),
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
                  color: AppColors.transparent,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [0, 1, 2].map((i) {
                          return Builder(builder: (context) {
                            if (i == 0) {
                              return ShowCaseWidget(
                                  builder: (showCaseContext) {
                                    if (!mainBloc.showCaseModel.test && mainBloc.controller.page == 2) {
                                      bloc.add(ShowCaseEvent(context: showCaseContext));
                                    }
                                    return myShowcase(
                                      key: bloc.keyTest,
                                      context: showCaseContext,
                                      title: 'show_test_title'.tr(),
                                      description: 'show_test_description'.tr(),
                                      child: MyTestCard(
                                        imgAsset: 'assets/images/img_test_$i.png',
                                        title: 'test_detail_title_$i'.tr(),
                                        content: 'test_detail_info_$i'.tr(),
                                        question: bloc.question[i],
                                        result: mainBloc.resultTests[i] != -1 ? '${mainBloc.resultTests[i]}' : 'not_worked'.tr(),
                                        enterTest: () => bloc.add(EnterTestEvent(context: context, index: i)),
                                      ),
                                    );
                                  }
                              );
                            }
                            return MyTestCard(
                              imgAsset: 'assets/images/img_test_$i.png',
                              title: 'test_detail_title_$i'.tr(),
                              content: 'test_detail_info_$i'.tr(),
                              question: bloc.question[i],
                              result: mainBloc.resultTests[i] != -1 ? '${mainBloc.resultTests[i]}' : 'not_worked'.tr(),
                              enterTest: () => bloc.add(EnterTestEvent(context: context, index: i)),
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
