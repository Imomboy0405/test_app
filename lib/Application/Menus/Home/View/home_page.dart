import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            return Scaffold(
              backgroundColor: AppColors.transparent,
              appBar: MyAppBar(animatedHellos: bloc.helloAnime, titleText: (locator<MainBloc>().userModel?.fullName ?? '')),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 75),
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
                                                      style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst),
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
                      ),

                      // #animated_text_image
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox.shrink(),
                                          // #text
                                          Builder(builder: (context) {
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.4,
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
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Text('more_read'.tr(), style: AppTextStyles.style8(context), textAlign: TextAlign.center,),
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
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              height: MediaQuery.of(context).size.width * 0.37,
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
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              height: MediaQuery.of(context).size.width * .34,
                              width: MediaQuery.of(context).size.width - 24,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.pink.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // #category
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child:
                                    Text('Category', style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst)),
                                  ),

                                  // #categoryies
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: List.generate(4, (int i) =>
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            // todo
                                          },
                                          child: Stack(
                                            alignment: const Alignment(0, .8),
                                            children: [
                                              SvgPicture.asset('assets/images/img_category_$i.svg'),
                                              Text(bloc.category[i], style: AppTextStyles.style8(context)),
                                          ],
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
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              height: MediaQuery.of(context).size.width * .875,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.pink.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // #top_doctors
                                        Text('Top Doctors', style: AppTextStyles.style4_1(context).copyWith(color: AppColors.whiteConst)),

                                        // #see_all_button
                                        ElevatedButton(
                                          onPressed: () {
                                            //todo
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 7),
                                            visualDensity: VisualDensity.compact,
                                            backgroundColor: AppColors.black,
                                          ),
                                          child: Text('See all', style: AppTextStyles.style7(context).copyWith(color: AppColors.pink)),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // #doctor_cards
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(children: List.generate(5, (int i) => MyDoctorButton(i: i, onPressed: () {})),
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
                    decoration:
                        BoxDecoration(color: AppColors.pink, borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/img_doctor_$i.png',
                        width: MediaQuery.of(context).size.width * .28,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // #info_texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Doctor full name',
                          style: AppTextStyles.style4_1(context).copyWith(color: AppColors.pinkWhite)),
                      Text('Doctor position', style: AppTextStyles.style4(context).copyWith(color: AppColors.pinkWhite)),
                      Text('🕙 10:30 - 18:30', style: AppTextStyles.style8(context).copyWith(color: AppColors.pinkWhite)),
                      Text('Fee: 120 000 so\'m', style: AppTextStyles.style4(context).copyWith(color: AppColors.pinkWhite)),
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
                          Icon(CupertinoIcons.star_circle_fill,
                              color: AppColors.pink, size: MediaQuery.of(context).size.width * .055),
                          Text('4.8',
                              style: AppTextStyles.style4(context).copyWith(color: AppColors.pink)),
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
                        child: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.whiteConst,
                          size: 28,
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
