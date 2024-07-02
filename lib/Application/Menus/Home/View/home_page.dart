import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        bloc.add(InitialDataEvent());
        if (state is HomeLoadingState) {
          return Scaffold(
            backgroundColor: AppColors.transparent,
            body: myIsLoading(context),
          );
        } else {
          return Scaffold(
          backgroundColor: AppColors.transparent,
          appBar: MyAppBar(titleText: 'hello'.tr() + (locator<MainBloc>().userModel?.fullName ?? '')),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 83),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // #cards_scroll
                  CarouselSlider(
                    carouselController: bloc.carouselController,
                    options: CarouselOptions(
                      height: 218.0,
                      enlargeCenterPage: true,
                      viewportFraction: 0.875,
                      enlargeFactor: .2,
                      autoPlay: bloc.autoPlay,
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
                                      // #card_image
                                      Image.asset(
                                        'assets/images/img_doctor_${(article.order + 2) % 3 + 1}.png',
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
                                            const Padding(
                                              padding: EdgeInsets.only(right: 8.0),
                                              child: Divider(),
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

                  // #content_texts
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bloc.articles[bloc.currentPage - 1].content.length,
                      itemBuilder: (BuildContext context, int index) {
                        Content content = bloc.articles[bloc.currentPage - 1].content[index];
                        if (index == 0) {
                          return ClipRRect(
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
                                      Text(
                                        content.content,
                                        style: AppTextStyles.style26(context).copyWith(
                                          fontSize: content.large ? 18 : null,
                                          color: AppColors.pink,
                                          fontWeight: content.bold ? FontWeight.w600 : null,
                                          fontStyle: content.italic ? FontStyle.italic : null,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                      AnimatedOpacity(
                                        opacity: bloc.opacityAnime,
                                        duration: const Duration(milliseconds: 500),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/img_test_${bloc.opacityAnime == 0 ? (bloc.newPage + 2) % 3 + 1 : (bloc.newPage + 2) % 3 + 1}.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        }
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
                  )
                ],
              ),
            ),
          ),
        );
        }
      },
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 185,
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.purpleAccent.withOpacity(0.3),
            blurRadius: 7,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              left: -20,
              child: myShadow(),
            ),
            Positioned(
              bottom: -20,
              right: -20,
              child: myShadow(),
            ),
          ],
        ),
      ),
    );
  }

  Container myShadow() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.transparentBlack,
            blurRadius: 50,
            spreadRadius: 75,
          ),
        ],
      ),
    );
  }
}
