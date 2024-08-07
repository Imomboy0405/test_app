import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Menus/Test/Test/Bloc/test_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/Bloc/test_detail_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class TestDetailPage extends StatelessWidget {
  static const id = '/test_detail_page';

  const TestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TestDetailBloc bloc = locator<TestDetailBloc>();
    bloc.asset = locator<TestBloc>().asset;
    return BlocBuilder<TestDetailBloc, TestDetailState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: const MyAppBar(
            titleText: 'Test Detail Page',
          ),
          body: SingleChildScrollView(
            controller: bloc.controller,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.pink.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // #title_text
                        AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                'test_detail_title_${bloc.asset}'.tr(),
                                textStyle: AppTextStyles.style18(context).copyWith(color: AppColors.whiteConst),
                                textAlign: TextAlign.center,
                              ),
                            ]
                        ),
                        const SizedBox(height: 6),
            
                        // #image
                        Hero(
                          tag: 'assets/images/img_test_${bloc.asset}.png',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/images/img_test_${bloc.asset}.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
            
                  // #info_text
                  const SizedBox(height: 6),
                  Text(
                    'test_detail_info_${bloc.asset}'.tr(),
                    style: AppTextStyles.style26(context),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 12),

                  // #start_button
                  ShowCaseWidget(
                    builder: (showCaseContext) {
                      if (!bloc.mainBloc.showCaseModel.testDetail) {
                        bloc.add(TestDetailShowCaseEvent(context: showCaseContext));
                      }
                      return myShowcase(
                        context: showCaseContext,
                        key: bloc.keyTestDetail,
                        title: 'show_test_detail_title'.tr(),
                        description: 'show_test_detail_description'.tr(),
                        child: MyButton(
                          enable: true,
                          text: 'start_test'.tr(),
                          function: () => bloc.add(StartTestEvent(context: context)),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
