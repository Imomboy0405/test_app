import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.screenWidth,
    required this.bloc,
  });

  final double screenWidth;
  final MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      height: 83,
      decoration: BoxDecoration(
        color: AppColors.purpleLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.transparentBlack,
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
        itemBuilder: (context, index) => SizedBox(
          width: screenWidth * .245,
          child: MaterialButton(
            onPressed: () => bloc.add(MainMenuButtonEvent(index: index)),
            splashColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.transparentPurple,
            highlightColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.transparentPurple,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // #menu_icon
                Image(
                  image: index + 1 == bloc.currentScreen
                      ? ThemeService.getTheme == ThemeMode.light
                          ? bloc.listOfMenuIcons[index + 4]
                          : bloc.listOfMenuIconsDarkMode[index + 4]
                      : ThemeService.getTheme == ThemeMode.light
                          ? bloc.listOfMenuIcons[index]
                          : bloc.listOfMenuIconsDarkMode[index],
                  height: index == 0 && !(index + 1 == bloc.currentScreen) ? 59 : 50,
                  width: index == 0 && !(index + 1 == bloc.currentScreen) ? 59 : 50,
                ),
                // #shadow
                if (index + 1 == bloc.currentScreen && bloc.currentScreen != 1)
                  Container(
                    width: 65,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(.5),
                          spreadRadius: -8,
                          blurRadius: 12,
                          offset: const Offset(0, 12),
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
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final bool animatedHellos;
  final bool purpleBackground;
  final void Function()? titleTap;

  const MyAppBar({super.key, required this.titleText, this.animatedHellos = false, this.titleTap, this.purpleBackground = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: purpleBackground ? AppColors.purpleAccent : AppColors.black,
      surfaceTintColor: AppColors.black,
      shadowColor: AppColors.purple,
      foregroundColor: AppColors.purple,
      titleSpacing: 10,
      title: Row(
        children: [
          // #image
          const SizedBox(width: 10),
          const Image(
            image: AssetImage('assets/images/img_heart.png'),
            width: 24,
            height: 24,
            color: AppColors.red,
          ),
          const SizedBox(width: 12),

          // #title_text
          if (titleTap != null)
            GestureDetector(
              onTap: () => titleTap!(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(titleText, style: AppTextStyles.style18_0(context)),
              ),
            )
          else
            Flexible(
              flex: 4,
              child: Text(
                titleText,
                style: purpleBackground
                    ? AppTextStyles.style18(context).copyWith(color: AppColors.whiteConst)
                    : AppTextStyles.style18_0(context),
              ),
            ),

          // #animated_text
          if (animatedHellos)
            Flexible(
              flex: 3,
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  for (int i = 1; i <= 7; i++)
                    RotateAnimatedText('hello$i'.tr(), textStyle: AppTextStyles.style18_0(context), alignment: Alignment.centerLeft),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, 57);
}

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({
    super.key,
    required this.textTitle,
    required this.textCancel,
    this.textDone,
    required this.functionCancel,
    this.functionDone,
    required this.child,
    this.doneButton = false,
  });

  final String textTitle;
  final String textCancel;
  final String? textDone;
  final Function functionCancel;
  final Function? functionDone;
  final Widget child;
  final bool doneButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // #backgoround
        Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => functionCancel(),
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: AppColors.transparentBlack,
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          decoration: BoxDecoration(
            color: AppColors.purpleLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: AppColors.transparent,
                child: Text(textTitle, style: AppTextStyles.style20(context).copyWith(color: Colors.white), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              child,
              // #cancel_done_button
              Row(
                mainAxisAlignment: doneButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  SelectButton(
                    context: context,
                    text: textCancel,
                    function: () => functionCancel(),
                    select: false,
                  ),
                  const SizedBox(width: 15),
                  if (doneButton)
                    SelectButton(
                      context: context,
                      text: textDone!,
                      function: () => functionDone!(),
                      select: true,
                      selectFunctionOn: true,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectButton extends StatelessWidget {
  final BuildContext context;
  final Function function;
  final String text;
  final bool select;
  final bool selectFunctionOn;

  const SelectButton({
    super.key,
    required this.context,
    required this.function,
    required this.text,
    required this.select,
    this.selectFunctionOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => select
          ? selectFunctionOn
              ? function()
              : () {}
          : function(),
      color: select ? AppColors.purple : AppColors.purpleLight,
      splashColor: AppColors.pink,
      elevation: 0,
      highlightColor: AppColors.pink,
      minWidth: (MediaQuery.of(context).size.width - 130) / 2,
      height: 37,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: AppTextStyles.style13(context).copyWith(color: Colors.white),
      ),
    );
  }
}

class MyProfileButton extends StatelessWidget {
  final Function function;
  final String? text;
  final Widget endElement;

  const MyProfileButton({
    super.key,
    this.text,
    required this.function,
    required this.endElement,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: MaterialButton(
          onPressed: () => function(),
          height: text == null ? MediaQuery.of(context).size.width * 0.46 : MediaQuery.of(context).size.width * 0.115,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.purpleLight,
          splashColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.pink,
          highlightColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.purpleLight : AppColors.pink,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: text != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text!, style: AppTextStyles.style19(context)),
                    endElement,
                  ],
                )
              : endElement,
        ),
      ),
    );
  }
}

Padding myBackground(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 100.0),
    child: Opacity(
      opacity: 0.4,
      child: SvgPicture.asset(
        'assets/images/img_stethoscope.svg',
        height: MediaQuery.of(context).size.height,
      ),
    ),
  );
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

Showcase myShowcase({
  required BuildContext context,
  required GlobalKey key,
  required String title,
  required String description,
  required Widget child,
  void Function()? onTap,
}) {
  return Showcase(
    key: key,
    description: description,
    title: title,
    titleTextStyle: AppTextStyles.style18_0(context),
    descTextStyle: AppTextStyles.style23(context),
    titleAlignment: TextAlign.center,
    disableMovingAnimation: true,
    disableScaleAnimation: true,
    tooltipPadding: const EdgeInsets.all(15),
    onBarrierClick: () => onTap != null ? onTap() : (),
    onToolTipClick: () => onTap != null ? onTap() : (),
    onTargetClick: () => onTap != null ? onTap() : (),
    disposeOnTap: true,
    child: child,
  );
}
