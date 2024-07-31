import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class MyTestCard extends StatelessWidget {
  final String imgAsset;
  final String title;
  final String content;
  final String question;
  final String result;
  final int position;
  final bool animation;
  final void Function() enterTest;

  const MyTestCard({
    super.key,
    required this.imgAsset,
    required this.title,
    required this.content,
    required this.question,
    required this.result,
    required this.enterTest,
    required this.position,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (animation) {
      return AnimationConfiguration.staggeredList(
        delay: const Duration(milliseconds: 50),
        position: position,
        child: SlideAnimation(
          duration: const Duration(milliseconds: 750),
          curve: Curves.linear,
          horizontalOffset: 0,
          verticalOffset: 200.0,
          child: FlipAnimation(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
            flipAxis: FlipAxis.y,
            child: buildCard(context),
          ),
        ),
      );
    } else {
      return buildCard(context);
    }
  }

  Padding buildCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        key: key,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: MediaQuery.of(context).size.width * .58,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.pink.withOpacity(.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // #image
                      Container(
                        width: MediaQuery.of(context).size.width * .382,
                        height: MediaQuery.of(context).size.width * .382,
                        decoration: BoxDecoration(
                          color: AppColors.transparentPurple.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Hero(
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

                      // #title_content
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // #title
                            Text(
                              title,
                              style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            // #content
                            Text(
                              content,
                              style: AppTextStyles.style8(context),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            // #number_of_question

                            iconText(
                              color: AppColors.red,
                              text: Text('${'number_of_question'.tr()}: $question', style: AppTextStyles.style19(context)),
                              width: MediaQuery.of(context).size.width,
                            ),
                            // #result
                            iconText(
                              color: AppColors.green,
                              text: Text('${'result'.tr()}: $result', style: AppTextStyles.style19(context)),
                              width: MediaQuery.of(context).size.width,
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
                  text: 'enter_test'.tr(),
                  function: () => enterTest(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row iconText({required Color color, required Text text, required double width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          color == AppColors.red ? CupertinoIcons.question_circle_fill : CupertinoIcons.checkmark_circle_fill,
          color: color,
          size: width * .045,
        ),
        const SizedBox(width: 5),
        Flexible(child: text),
      ],
    );
  }
}
