import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Application/Menus/Home/Bloc/home_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class HomePage extends StatelessWidget {
  static const id = '/home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          HomeBloc bloc = context.read<HomeBloc>();
          bloc.add(InitialDataEvent());

          return Scaffold(
            backgroundColor: AppColors.transparent,
            appBar: MyAppBar(titleText: 'hello'.tr() + (locator<MainBloc>().userModel?.fullName ?? '')),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 83),
              child: SingleChildScrollView(
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
                        onPageChanged: (page, reason) => bloc.add(HomeScrollCardEvent(page: page)),
                      ),
                      items: [1, 2, 3].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                // #card_shadows
                                ClipRRect(
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
                                          'assets/images/img_doctor_$i.png',
                                          height: 200,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // #card_text
                                              SizedBox(
                                                height: 80,
                                                width: 170,
                                                child: Text(
                                                  'card_text_$i'.tr(),
                                                  style: AppTextStyles.style4_1(context),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                              // #card_info_text
                                              SizedBox(
                                                height: 50,
                                                width: 170,
                                                child: Text(
                                                  'card_info_text_$i'.tr(),
                                                  style: AppTextStyles.style27(context),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        12,
                            (index) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('$index) ${'card_info_text_${bloc.currentPage}'.tr()}', style: AppTextStyles.style26(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
