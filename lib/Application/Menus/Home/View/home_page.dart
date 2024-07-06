import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Home/Bloc/home_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class HomePage extends StatelessWidget {
  static const id = '/home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = locator<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        bloc.add(HomeInitialDataEvent());
        if (state is HomeLoadingState) {
          return Scaffold(
            backgroundColor: AppColors.transparent,
            body: myIsLoading(context),
          );
        } else {
          return ShowCaseWidget(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Future.delayed(const Duration(milliseconds: 300));
              if (!bloc.mainBloc.showCaseModel.home && bloc.mainBloc.currentScreen == 1) {
                if (context.mounted) {
                  bloc.add(HomeShowCaseEvent(context: context));
                }
              }
            });
            return Scaffold(
              backgroundColor: AppColors.transparent,
              appBar: MyAppBar(animatedHellos: true, titleText: (locator<MainBloc>().userModel?.fullName ?? '')),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 83),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // #cards_scroll
                      myShowcase(
                        context: context,
                        key: bloc.keyCarousel,
                        description: 'show_carousel_description'.tr(),
                        title: 'show_carousel_title'.tr(),
                        onTap: () => ShowCaseWidget.of(context).dismiss(),
                        child: CarouselSlider(
                          carouselController: bloc.carouselController,
                          options: CarouselOptions(
                            initialPage: bloc.currentPage,
                            height: 218.0,
                            enlargeCenterPage: true,
                            viewportFraction: 0.875,
                            enlargeFactor: .2,
                            onPageChanged: (page, reason) => bloc.add(HomeScrollCardEvent(page: page)),
                          ),
                          items: bloc.articles.map((article) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    // #card_shadows
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width - 80,
                                              margin: const EdgeInsets.only(top: 160),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: AppColors.purpleLight.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 120,
                                              margin: const EdgeInsets.only(top: 158),
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: AppColors.purpleLight.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // #card
                                    Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        const MyCard(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // #card_doctor_image
                                            Image.asset(
                                              'assets/images/img_doctor_${(article.order - 1) % 5}.png',
                                              height: 200,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  // #card_title
                                                  ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxHeight: 80,
                                                      maxWidth: 170,
                                                      minWidth: 170,
                                                    ),
                                                    child: Text(
                                                      article.title,
                                                      style: AppTextStyles.style4_1(context),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Divider(color: AppColors.black),
                                                  ),
                                                  // #card_info_text
                                                  ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxHeight: 50,
                                                      maxWidth: 170,
                                                      minWidth: 170,
                                                    ),
                                                    child: Text(
                                                      article.content[0].content.trim(),
                                                      style: AppTextStyles.style8(context),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      // #animated_text_image
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                                height: MediaQuery.of(context).size.width * 0.607,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.transparentPurple.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Builder(builder: (context) {
                                      return SizedBox(
                                        height: 26,
                                        child: AnimatedTextKit(
                                          totalRepeatCount: 1,
                                          key: Key(bloc.articles[bloc.currentPage].content[0].content),
                                          animatedTexts: [
                                            TyperAnimatedText(
                                              bloc.articles[bloc.currentPage].content[0].content,
                                              textStyle: AppTextStyles.style26(context).copyWith(
                                                fontSize: 18,
                                                color: AppColors.pink,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.justify,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                    AnimatedOpacity(
                                      opacity: bloc.opacityAnime,
                                      duration: const Duration(milliseconds: 300),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          width: MediaQuery.of(context).size.width - 22,
                                          height: MediaQuery.of(context).size.width * 0.51,
                                          'assets/images/img_article_${bloc.opacityAnime == 0 ? bloc.newPage : bloc.newPage}.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),

                      // #content_texts
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              decoration: BoxDecoration(
                                color: AppColors.transparentPurple,
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        }
      },
    );
  }
}
