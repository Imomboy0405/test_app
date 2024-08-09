import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Home/Bloc/home_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
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
        if (bloc.helloAnime) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Future.delayed(const Duration(seconds: 7), () => bloc.helloAnime = false));
        }
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
            double width = MediaQuery.of(context).size.width;
            return Scaffold(
              backgroundColor: AppColors.transparent,
              appBar: MyAppBar(animatedHellos: bloc.helloAnime, titleText: (locator<MainBloc>().userModel?.fullName ?? '')),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: Stack(
                  children: [
                    // #initial_screen
                    SingleChildScrollView(
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
                                autoPlay: bloc.autoPlayCarousel,
                                autoPlayInterval: const Duration(seconds: 6),
                                initialPage: bloc.currentPage,
                                height: width * .5,
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
                                                  width: width - 80,
                                                  margin: EdgeInsets.only(top: width * .35),
                                                  height: width * .13,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.purpleLight.withOpacity(0.5),
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                ),
                                                Container(
                                                  width: width - 120,
                                                  margin: EdgeInsets.only(top: width * .35),
                                                  height: width * .15,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.purpleLight.withOpacity(0.25),
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
                                                  height: width * .45,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      // #card_title
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          maxHeight: width * .15,
                                                          maxWidth: width * .45,
                                                          minWidth: width * .45,
                                                        ),
                                                        child: Text(
                                                          article.title,
                                                          style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.only(right: 8.0),
                                                        child: Divider(),
                                                      ),
                                                      // #card_info_text
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                          maxHeight: width * .15,
                                                          maxWidth: width * .45,
                                                          minWidth: width * .45,
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
                            padding: EdgeInsets.fromLTRB(width * 0.03, width * 0.02, width * 0.03, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  splashColor: AppColors.pink,
                                  highlightColor: AppColors.pink,
                                  onPressed: () => bloc.add(HomePressArticleEvent(context: context)),
                                  child: Container(
                                      height: width * 0.4,
                                      padding: EdgeInsets.all(width * 0.015),
                                      decoration: BoxDecoration(
                                        color: AppColors.pink.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          // #text
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox.shrink(),
                                              // #title_text
                                              Builder(builder: (context) {
                                                return SizedBox(
                                                  width: width * 0.4,
                                                  child: AnimatedTextKit(
                                                    totalRepeatCount: 1,
                                                    key: Key(bloc.articles[bloc.currentPage].content[0].content),
                                                    animatedTexts: [
                                                      TyperAnimatedText(
                                                        bloc.articles[bloc.currentPage].content[0].content,
                                                        textStyle: AppTextStyles.style18(context).copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColors.whiteConst,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),

                                              // #read_more_text
                                              SizedBox(
                                                width: width * 0.4,
                                                child: Text(
                                                  'more_read'.tr(),
                                                  style: AppTextStyles.style8(context),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // #image
                                          AnimatedOpacity(
                                            opacity: bloc.opacityAnime,
                                            duration: const Duration(milliseconds: 300),
                                            child: Hero(
                                              tag: bloc.articles[bloc.currentPage].content[0].content,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.asset(
                                                  width: width * 0.51,
                                                  height: width * 0.37,
                                                  'assets/images/img_article_${bloc.opacityAnime == 0 ? bloc.newPage : bloc.newPage}.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ),

                          // #category
                          Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  height: width * .47,
                                  width: width - 24,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // #category_text
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text('category'.tr(), style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst)),
                                      ),

                                      // #categoryies
                                      Flexible(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                              bloc.category.length,
                                              (int i) => CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () => bloc.add(HomeCategoryEvent(selectedCategory: bloc.category[i].tr(), selectedCategoryImage: i)),
                                                child: Container(
                                                  height: width * .4,
                                                  width: width * .23,
                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: Stack(
                                                    children: [
                                                      // #category_image
                                                      Container(
                                                        height: width * .23,
                                                        margin: const EdgeInsets.only(top: 5),
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.black,
                                                          borderRadius: BorderRadius.circular(100),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: AppColors.pink,
                                                              spreadRadius: 0,
                                                              blurRadius: 7,
                                                            )
                                                          ]
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(100),
                                                          child: Image.asset(
                                                            'assets/images/img_category_$i.png',
                                                            height: width * .23,
                                                            width: width * .23,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),

                                                      // #category_text
                                                      Container(
                                                        margin: EdgeInsets.only(top: width * .245),
                                                        child: Text(
                                                          bloc.category[i].tr(),
                                                          style: AppTextStyles.style8(context),
                                                          maxLines: 2,
                                                          textAlign: TextAlign.center,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // #top_doctors
                          Padding(
                            padding: EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, width * 0.05),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  height: width * .875,
                                  padding: EdgeInsets.all(width * 0.015),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: width * .01),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // #top_doctors
                                            Text('top_doctors'.tr(), style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst)),

                                            // #see_all_button
                                            ElevatedButton(
                                              onPressed: () {
                                                //todo
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(horizontal: width * 0.018),
                                                visualDensity: VisualDensity.compact,
                                                backgroundColor: AppColors.black,
                                              ),
                                              child: Text('see_all'.tr(), style: AppTextStyles.style7(context).copyWith(color: AppColors.pink)),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // #doctor_cards
                                      Flexible(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(
                                              5,
                                              (int i) => MyDoctorButton(
                                                i: i,
                                                onPressed: () => bloc.add(HomePressDoctorEvent(context: context, index: i)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // #category_screen
                    if (state is HomeCategoryState)
                      MyProfileScreen(
                        doneButton: true,
                        textTitle: 'category'.tr(),
                        textCancel: 'back'.tr(),
                        textDone: 'done'.tr(),
                        functionCancel: () => bloc.add(HomeCancelEvent()),
                        functionDone: () => bloc.add(HomeCancelEvent()),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/img_category_${bloc.selectedCategoryImage}.png',
                                  width: width * .8,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(bloc.selectedCategory, style: AppTextStyles.style13(context).copyWith(color: AppColors.whiteConst)),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          });
        }
      },
    );
  }
}

class MyDoctorButton extends StatelessWidget {
  final int i;
  final void Function() onPressed;

  const MyDoctorButton({
    super.key,
    required this.i,
    required this.onPressed(),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: i != 0 ? const EdgeInsets.only(top: 10) : EdgeInsets.zero,
      child: MaterialButton(
        elevation: 4,
        color: AppColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.zero,
        onPressed: () => onPressed(),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * .3,
              child: Row(
                children: [
                  // #doctor_image
                  Container(
                    decoration: BoxDecoration(color: AppColors.purpleLight.withOpacity(.3), borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: '$i',
                        child: Image.asset(
                          'assets/images/img_doctor_$i.png',
                          width: MediaQuery.of(context).size.width * .28,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // #info_texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('doctor_fullname'.tr(), style: AppTextStyles.style4_1(context).copyWith(color: AppColors.pinkWhite)),
                      Text('doctor_field'.tr(), style: AppTextStyles.style4(context).copyWith(color: AppColors.pinkWhite)),
                      Text('🕙 10:30 - 18:30', style: AppTextStyles.style8(context).copyWith(color: AppColors.pinkWhite)),
                      Text('${'working_days'.tr()}: 5/2', style: AppTextStyles.style8(context).copyWith(color: AppColors.pinkWhite)),
                    ],
                  ),
                  const Spacer(),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // #star_ball
                      Row(
                        children: [
                          Icon(CupertinoIcons.star_circle_fill, color: AppColors.pink, size: MediaQuery.of(context).size.width * .055),
                          Text('4.8', style: AppTextStyles.style4(context).copyWith(color: AppColors.pink)),
                        ],
                      ),

                      // #next
                      Container(
                        height: MediaQuery.of(context).size.width * .1,
                        width: MediaQuery.of(context).size.width * .12,
                        decoration: BoxDecoration(
                          color: AppColors.pink,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.whiteConst,
                          size: MediaQuery.of(context).size.width * .06,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
