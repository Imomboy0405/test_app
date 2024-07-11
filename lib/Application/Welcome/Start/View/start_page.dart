import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Welcome/Start/Bloc/start_bloc.dart';
import 'package:test_app/Application/Welcome/View/welcome_widgets.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';

import 'start_view.dart';

class StartPage extends StatelessWidget {
  static const id = '/start_page';

  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => StartBloc(),
      child: BlocBuilder<StartBloc, StartState>(
        builder: (context, state) {
          StartBloc bloc = context.read<StartBloc>();
          bloc.controller.addListener(() => bloc.listenPageScroll());
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.purple,
                  AppColors.purpleAccent,
                ],
                center: const Alignment(0, -.2),
              ),
            ),
            child: Scaffold(
              backgroundColor: AppColors.transparent,

              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 91,
                backgroundColor: AppColors.transparent,

                // #flag
                actions: [
                  MyFlagButton(
                    currentLang: bloc.selectedLang,
                    onChanged: ({required BuildContext context, required Language lang}) =>
                        bloc.add(SelectLanguageEvent(context: context, language: lang)),
                  ),
                ],

                // #IBilling
                title: Text('Test App', style: AppTextStyles.style0_1(context)),
                leadingWidth: 60,
              ),

              body: DefaultTabController(
                length: 3,
                child: SizedBox(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      // #line_img
                      const Padding(
                        padding: EdgeInsets.only(left: 250),
                        child: Image(
                          image: AssetImage('assets/images/img_line.png'),
                          height: 100,
                          width: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 250, left: 300),
                        child: Image(
                          image: const AssetImage('assets/images/img_line.png'),
                          height: 80,
                          width: 40,
                          color: AppColors.purple,
                        ),
                      ),

                      // #circle_grass_container
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutBack,
                        left: bloc.left1,
                        top: bloc.top1,
                        child: const MyCircleGlassContainer(childPos: true),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutBack,
                        left: bloc.left,
                        top: bloc.top,
                        child: const MyCircleGlassContainer(),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        width: bloc.left == 41 ? 85 : bloc.left,
                        height: bloc.left == 41 ? 85 : bloc.left,
                        left: bloc.left2,
                        top: bloc.top2,
                        child: const MyCircleGlassContainer(mini: true),
                      ),
                      const TabBarView(
                        children: [
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                          SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 270,
                        child: PageView(
                          physics: const BouncingScrollPhysics(),
                          controller: bloc.controller,
                          children: const [
                            StartView(img: 1),
                            StartView(img: 2),
                            StartView(img: 3),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(bottom: 48, right: 24, left: 24),
                        height: MediaQuery.of(context).size.height - 125,
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                const SizedBox(height: 80),
                                // #tab_page_selector
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      height: 25,
                                      width: 50,
                                      child: TabPageSelector(
                                        indicatorSize: 8,
                                        color: AppColors.darkGrey,
                                        selectedColor: AppColors.purple,
                                        borderStyle: BorderStyle.none,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),

                                // #skip
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 700),
                                  width: bloc.next ? 0 : 200,
                                  onEnd: () => bloc.add(LoginAnimateEvent(first: true)),
                                  curve: Curves.easeInCirc,
                                  padding: const EdgeInsets.only(right: 40),
                                  child: MaterialButton(
                                    onPressed: () => context.read<StartBloc>().add(SkipEvent(context: context)),
                                    color: AppColors.purple,
                                    splashColor: AppColors.purpleAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    height: 50,
                                    padding: const EdgeInsets.only(left: 20, right: 45),
                                    child: Text(
                                      'skip'.tr(),
                                      style: AppTextStyles.style4(context),
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),

                                // #next
                                BlocBuilder<StartBloc, StartState>(
                                  builder: (context, state) {
                                    TabController c = DefaultTabController.of(context);
                                    c.animateTo(bloc.controller.page?.round() ?? 0, duration: const Duration(milliseconds: 350));
                                    return AnimatedPadding(
                                      duration: const Duration(milliseconds: 300),
                                      padding: bloc.loginHeight != 75 ? EdgeInsets.zero : const EdgeInsets.only(right: 2.5),
                                      child: AvatarGlow(
                                        glowRadiusFactor: 0.35,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            color: bloc.login ? AppColors.purple : AppColors.black,
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          onEnd: () => bloc.add(LoginAnimateEvent()),
                                          curve: Curves.easeInOutBack,
                                          height: bloc.loginHeight,
                                          width: bloc.loginHeight,
                                          child: MaterialButton(
                                            onPressed: () => context.read<StartBloc>().add(NextEvent(context: context)),
                                            shape: const CircleBorder(),
                                            splashColor: AppColors.purpleAccent,
                                            child: Icon(
                                              bloc.login ? Icons.login : Icons.arrow_forward,
                                              color: bloc.login ? AppColors.black : AppColors.purple,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),

                            // #text
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'log_info'.tr(),
                                    style: AppTextStyles.style2(context),
                                  ),

                                  // #terms_of_use
                                  TextSpan(
                                    text: 'terms'.tr(),
                                    style: AppTextStyles.style9(context),
                                    recognizer: TapGestureRecognizer()..onTap = () => context.read<StartBloc>().add(TermsEvent()),
                                  ),
                                  TextSpan(
                                    text: 'and'.tr(),
                                    style: AppTextStyles.style2(context),
                                  ),

                                  // #privacy_policy
                                  TextSpan(
                                    text: 'policy'.tr(),
                                    style: AppTextStyles.style9(context),
                                    recognizer: TapGestureRecognizer()..onTap = () => context.read<StartBloc>().add(TermsEvent(policy: true)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


