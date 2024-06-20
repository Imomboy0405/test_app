import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class TestPage extends StatelessWidget {
  static const id = '/test_page';

  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: MyAppBar(titleText: 'test'.tr()),
      body: Container(
        height: MediaQuery.of(context).size.height - 170,
        color: AppColors.purpleLight,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Opacity(
                opacity: .4,
                child: SvgPicture.asset(
                  'assets/images/img_stethoscope.svg',
                  height: MediaQuery.of(context).size.height,
                  color: AppColors.purple,
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    MyTestCard(
                      imgAsset: 'assets/images/img_doctor_1.png',
                      title: 'card_text_1'.tr(),
                      content: 'card_text_1'.tr(),
                      question: '20',
                      result: '14 %',
                      startTest: () {},
                    ),

                    MyTestCard(
                      imgAsset: 'assets/images/img_doctor_2.png',
                      title: 'card_text_2'.tr(),
                      content: 'card_text_2'.tr(),
                      question: '20',
                      result: '14 %',
                      startTest: () {},

                    ),

                    MyTestCard(
                      imgAsset: 'assets/images/img_doctor_3.png',
                      title: 'card_text_3'.tr(),
                      content: 'card_text_3'.tr(),
                      question: '20',
                      result: '14 %',
                      startTest: () {},

                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTestCard extends StatelessWidget {
  final String imgAsset;
  final String title;
  final String content;
  final String question;
  final String result;
  final void Function() startTest;

  const MyTestCard({
    super.key,
    required this.imgAsset,
    required this.title,
    required this.content,
    required this.question,
    required this.result,
    required this.startTest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        key: key,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 220,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 7,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // #image
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.transparentPurple.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(imgAsset),
                      ),
                      const SizedBox(width: 10),

                      // #title
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // #title
                            Text(
                              title,
                              style: AppTextStyles.style4(context),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            // #content
                            Text(
                              content,
                              style: AppTextStyles.style9(context),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            // #number_of_question
                            iconText(
                                color: AppColors.red,
                                text: Text(' ${'number_of_question'.tr()}: $question', style: AppTextStyles.style23_2(context))
                            ),
                            // #result
                            iconText(
                              color: AppColors.red,
                              text: Text(' ${'result'.tr()}: $result', style: AppTextStyles.style23_3(context)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // #test_button
                MyButton(
                  enable: true,
                  text: 'start_test'.tr(),
                  function: () {
                    // todo code
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row iconText({required Color color, required Text text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 22,
          width: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.transparentBlack,
          ),
          child: Icon(color == AppColors.red ? Icons.question_mark : Icons.question_mark, color: color, size: 18),
        ),
        text,
      ],
    );
  }
}
