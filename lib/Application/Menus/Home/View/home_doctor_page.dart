import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Menus/Home/Bloc/home_bloc.dart';
import 'package:test_app/Application/Menus/View/menus_widgets.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/locator_service.dart';

class HomeDoctorPage extends StatelessWidget {
  static const id = '/home_doctor_page';

  const HomeDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    HomeBloc bloc = locator<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        return PopScope(
          canPop: true,
          onPopInvoked: (v) => bloc.add(HomePopDoctorPageEvent()),
          child: Scaffold(
            backgroundColor: AppColors.black,
            appBar: MyAppBar(titleText: 'doctor_profile'.tr()),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // #animations
                      Positioned(
                        left: width * .04,
                        top: width * 0.05,
                        child: AnimatedScale(
                            duration: const Duration(milliseconds: 1500),
                            scale: 1- bloc.scaleAnime + 0.7,
                            child: const MyCircleGlassContainer(isStartPage: false, mini: true, shadow: true)),
                      ),
                      Positioned(
                        left: width * .8,
                        top: width * 1.03,
                        child: AnimatedScale(
                            duration: const Duration(seconds: 2),
                            scale: bloc.scaleAnime,
                            child: const MyCircleGlassContainer(isStartPage: false, mini: true, shadow: true)),
                      ),
                      Positioned(
                        left: width * .8,
                        top: width * 0.13,
                        child: AnimatedScale(
                          duration: const Duration(seconds: 3),
                          scale: bloc.scaleAnime,
                          child: AnimatedOpacity(
                              duration: const Duration(seconds: 2),
                              opacity: bloc.scaleAnime == .7 ? .3 : bloc.scaleAnime,
                              child: const MyCircleGlassContainer(isStartPage: false, mini: true, shadow: true)),
                        ),
                      ),

                      // #frame
                      Container(
                        margin: EdgeInsets.fromLTRB(width * 0.062, width * 0.04, width * 0.062, width * 0.062),
                        height: width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.pink,
                                AppColors.purpleAccent,
                                AppColors.purpleAccent,
                                Colors.black.withOpacity(.5),
                              ],
                              begin: Alignment.topCenter,
                              end: const Alignment(0, 1.3),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width * .5),
                              topRight: Radius.circular(width * .5),
                              bottomLeft: Radius.circular(width * 0.04),
                              bottomRight: Radius.circular(width * 0.04),
                            ),
                            border: Border.all(color: AppColors.whitePurple, width: width * .035),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.transparentWhite, spreadRadius: 0, blurRadius: width * 0.04, offset: const Offset(0, 1)),
                            ]),
                      ),

                      // #doctor_image
                      Padding(
                        padding: EdgeInsets.only(top: width * 0.007),
                        child: Hero(
                          tag: '${bloc.doctorNumber}',
                          child: Image.asset(
                            'assets/images/img_doctor_${bloc.doctorNumber}.png',
                            height: width,
                            width: width - width * .195,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),

                      // #text
                      SizedBox(
                        height: width * 1.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // #doctor_full_name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('doctor_fullname'.tr(), style: AppTextStyles.style1(context)),
                                const SizedBox(width: 5),
                                Icon(CupertinoIcons.checkmark_seal_fill, color: AppColors.blue, size: width * .06)
                              ],
                            ),

                            // #doctor_position
                            Text('doctor_field'.tr(), style: AppTextStyles.style7(context)),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    ],
                  ),

                  // #doctor_info
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: width * .05),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withOpacity(.8),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(width * .12), topRight: Radius.circular(width * .12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // #doctor_skills
                        Container(
                          height: width * .35,
                          margin: EdgeInsets.only(top: width * .04),
                          decoration: BoxDecoration(color: AppColors.transparentBlack, borderRadius: BorderRadius.circular(width * .07)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              doctorSkill(
                                width: width,
                                context: context,
                                icon: CupertinoIcons.person_2,
                                text1: '1000+',
                                text2: 'patients'.tr(),
                              ),
                              doctorSkill(
                                width: width,
                                context: context,
                                icon: CupertinoIcons.heart,
                                text1: '5 ${'year'.tr()}',
                                text2: 'experience'.tr(),
                              ),
                              doctorSkill(
                                width: width,
                                context: context,
                                icon: CupertinoIcons.star,
                                text1: '4.8',
                                text2: 'rating'.tr(),
                              ),
                            ],
                          ),
                        ),

                        // #about_doctor
                        SizedBox(height: width * .03),
                        Text('about_doctor'.tr(), style: AppTextStyles.style11(context)),
                        Text(
                          'test_detail_info_0'.tr(),
                          style: AppTextStyles.style8(context),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: width * .04),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column doctorSkill({
    required double width,
    required BuildContext context,
    required IconData icon,
    required String text1,
    required String text2,
  }) {
    return Column(
      children: [
        // #icon
        Container(
          height: width * .18,
          width: width * .18,
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(.7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(width * .04),
              bottomRight: Radius.circular(width * .04),
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.whiteConst,
            size: width * 0.08,
          ),
        ),

        const Spacer(),
        // #texts
        Text(text1, style: AppTextStyles.style3(context).copyWith(color: AppColors.whiteConst)),
        Text(text2, style: AppTextStyles.style8(context)),
        const Spacer(),
      ],
    );
  }
}
