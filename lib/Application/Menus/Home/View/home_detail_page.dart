import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Home/Bloc/home_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class HomeDetailPage extends StatelessWidget {
  static const id = '/home_detail_page';

  const HomeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = locator<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: MyAppBar(titleText: bloc.articles[bloc.currentPage].title),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // #animated_text_image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // #animated_text
                          AnimatedTextKit(
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                bloc.articles[bloc.currentPage].content[0].content,
                                textStyle: AppTextStyles.style18(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteConst,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),

                          // #image
                          Hero(
                            tag: bloc.articles[bloc.currentPage].content[0].content,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                width: MediaQuery.of(context).size.width - 22,
                                'assets/images/img_article_${bloc.opacityAnime == 0 ? bloc.newPage : bloc.newPage}.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),

                // #content_texts
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bloc.articles[bloc.currentPage].content.length,
                      itemBuilder: (BuildContext context, int index) {
                        Content content = bloc.articles[bloc.currentPage].content[index];
                        if (index == 0) return const SizedBox.shrink();

                        // #content_text
                        return Text(
                          content.content,
                          style: AppTextStyles.style26(context).copyWith(
                            color: AppColors.whiteConst,
                            fontSize: content.large ? 18 : null,
                            fontWeight: content.bold ? FontWeight.w600 : null,
                            fontStyle: content.italic ? FontStyle.italic : null,
                          ),
                          textAlign: TextAlign.justify,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
