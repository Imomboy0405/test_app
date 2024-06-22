import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Test/TestDetail/Bloc/test_detail_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class TestDetailPage extends StatelessWidget {
  static const id = '/test_detail_page';

  const TestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int asset = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      create: (context) => TestDetailBloc(),
      child: BlocBuilder<TestDetailBloc, TestDetailState>(
        builder: (context, state) {
          TestDetailBloc bloc = context.read<TestDetailBloc>();
          return Scaffold(
            backgroundColor: AppColors.black,
            appBar: const MyAppBar(
              titleText: 'Test Detail Page',
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.purpleAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // #title_text
                        Text(
                          'test_detail_title_$asset'.tr(),
                          style: AppTextStyles.style18_0(context),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 6),

                        // #image
                        Hero(
                          tag: 'assets/images/img_test_$asset.png',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/images/img_test_$asset.png'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // #info_text
                  const SizedBox(height: 6),
                  Text(
                    'test_detail_info_$asset'.tr(),
                    style: AppTextStyles.style13(context),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 12),
                  // #start_button
                  MyButton(
                    enable: true,
                    text: 'start_test'.tr(),
                    function: () => bloc.add(StartTestEvent(index: asset, context: context)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
