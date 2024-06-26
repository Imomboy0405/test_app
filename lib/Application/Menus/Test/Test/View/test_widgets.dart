import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class MyTestCard extends StatelessWidget {
  final String imgAsset;
  final String title;
  final String content;
  final String? question;
  final String? result;
  final void Function() enterTest;

  const MyTestCard({
    super.key,
    required this.imgAsset,
    required this.title,
    required this.content,
    required this.question,
    required this.result,
    required this.enterTest,
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
                  color: AppColors.purpleAccent.withOpacity(0.4),
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
                        padding: const EdgeInsets.all(5),
                        child: question == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imgAsset,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Hero(
                                tag: imgAsset,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    imgAsset,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),

                      // #title
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // #title
                            Text(
                              title,
                              style: AppTextStyles.style3(context),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            // #content
                            Text(
                              content,
                              style: AppTextStyles.style9(context),
                              overflow: TextOverflow.ellipsis,
                              maxLines: question != null ? 2 : 5,
                            ),
                            // #number_of_question
                            if (question != null)
                              iconText(
                                  color: AppColors.red,
                                  text: Text(' ${'number_of_question'.tr()}: $question', style: AppTextStyles.style23_2(context))),
                            // #result
                            if (result != null)
                              iconText(
                                color: AppColors.green,
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
                  text: question != null ? 'enter_test'.tr() : 'enter_chat'.tr(),
                  function: () => enterTest(),
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
          child: Icon(color == AppColors.red ? Icons.question_mark : Icons.check_circle, color: color, size: 18),
        ),
        text,
      ],
    );
  }
}
