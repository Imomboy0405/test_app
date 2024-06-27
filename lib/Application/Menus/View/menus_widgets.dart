import 'dart:ui';

import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_svg/svg.dart';
import 'package:test_app/Application/Main/Bloc/main_bloc.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
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

  const MyAppBar({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.black,
      surfaceTintColor: AppColors.black,
      shadowColor: AppColors.purple,
      foregroundColor: AppColors.purple,
      titleSpacing: 10,
      title: Row(
        children: [
          // #color_image
          const SizedBox(width: 10),
          const Image(
            image: AssetImage('assets/images/img_heart.png'),
            width: 24,
            height: 24,
            color: AppColors.red,
          ),
          const SizedBox(width: 12),

          // #title
          Text(titleText, style: AppTextStyles.style18_0(context)),
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
    this.red = false,
  });

  final String textTitle;
  final String textCancel;
  final String? textDone;
  final Function functionCancel;
  final Function? functionDone;
  final Widget child;
  final bool doneButton;
  final bool red;

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
                  red
                      ? Flexible(
                          child: SingleButton(
                            onPressed: () => functionCancel(),
                            red: true,
                            text: textCancel,
                          ),
                        )
                      : SelectButton(
                          context: context,
                          text: textCancel,
                          function: () => functionCancel(),
                          select: false,
                        ),
                  const SizedBox(width: 15),
                  if (doneButton)
                    red
                        ? Flexible(
                            child: SingleButton(
                              onPressed: () => functionDone!(),
                              red: true,
                              redDone: true,
                              text: textDone!,
                            ),
                          )
                        : SelectButton(
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

class SingleButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool red;
  final bool redDone;

  const SingleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.red = false,
    this.redDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 40,
      minWidth: double.infinity,
      elevation: 0,
      color: redDone
          ? AppColors.red
          : red
              ? AppColors.transparentRed
              : AppColors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: red && !redDone ? AppTextStyles.style23_2(context) : AppTextStyles.style23_1(context).copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
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
          height: text == null ? 188 : 44,
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
