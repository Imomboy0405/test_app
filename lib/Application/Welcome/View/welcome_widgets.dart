import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/Application/Welcome/Start/Bloc/start_bloc.dart';
import 'package:test_app/Configuration/app_colors.dart';
import 'package:test_app/Configuration/app_text_styles.dart';
import 'package:test_app/Data/Services/lang_service.dart';
import 'package:test_app/Data/Services/theme_service.dart';
import 'package:test_app/Data/Services/util_service.dart';

class MyFlagButton extends StatelessWidget {
  final Language currentLang;
  final void Function({required Language lang, required BuildContext context}) onChanged;
  static const List<Language> lang = [
    Language.uz,
    Language.ru,
    Language.en,
  ];

  const MyFlagButton({
    super.key,
    required this.currentLang,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 40,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showModalBottomSheet(
              elevation: 0,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.47,
                  maxChildSize: 0.5,
                  expand: true,
                  builder: (BuildContext cont, ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: AppColors.purple,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 4,
                        itemBuilder: (c, index) {
                          return index == 0
                              ? Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'choose_lang'.tr(),
                                    style: AppTextStyles.style4(context),
                                  ),
                                )
                              : RadioListTile(
                                  activeColor: AppColors.black,
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  secondary: Image(
                                    image: AssetImage('assets/icons/ic_flag_${lang[index - 1].name}.png'),
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.fill,
                                  ),
                                  title: Text('button_${index - 1}'.tr(), style: AppTextStyles.style8(context)),
                                  selected: lang[index - 1] == currentLang,
                                  value: lang[index - 1],
                                  groupValue: currentLang,
                                  onChanged: (value) => onChanged(lang: value as Language, context: cont));
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
          icon: Image(
            image: AssetImage('assets/icons/ic_flag_${currentLang.name}.png'),
            width: 28,
            height: 28,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class MyCircleGlassContainer extends StatelessWidget {
  final bool mini;
  final bool childPos;
  final bool isStartPage;
  final bool transparent;

  const MyCircleGlassContainer({
    this.mini = false,
    this.childPos = false,
    this.isStartPage = true,
    this.transparent = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isStartPage
        ? BlocBuilder<StartBloc, StartState>(
            builder: (context, state) {
              StartBloc? bloc = context.read<StartBloc>();
              return buildGlassContainer(bloc);
            },
          )
        : buildGlassContainer(null);
  }

  ClipRRect buildGlassContainer(StartBloc? bloc) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(130),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: mini ? 70 : bloc == null ? 170 : 250,
          width: mini ? 70 : bloc == null ? 170 : 250,
          decoration: BoxDecoration(
            color: transparent ? AppColors.transparent : AppColors.transparentBlack,
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: AppColors.black, width: 2),
          ),
          alignment: childPos
              ? bloc!.left == 41
                  ? Alignment.bottomLeft
                  : bloc.left == 40
                      ? Alignment.bottomRight
                      : Alignment.topLeft
              : null,
          padding: const EdgeInsets.all(30),
          child: childPos
              ? Image(
                  image: AssetImage('assets/images/img_${bloc!.left == 41 ? 'shield' : bloc.left == 40 ? 'heart' : 'test'}.png'),
                  height: 100,
                  width: 100,
                  color: bloc.left == 41
                      ? AppColors.blue
                      : bloc.left == 40
                          ? AppColors.red
                          : AppColors.green,
                )
              : null,
        ),
      ),
    );
  }
}

Container myIsLoading(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: AppColors.transparentBlack,
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      color: AppColors.purple,
      backgroundColor: AppColors.transparentPurple,
    ),
  );
}

TextButton myTextButton({
  required BuildContext context,
  required String? assetIc,
  required Function() onPressed,
  required String txt,
}) {
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      overlayColor: WidgetStateProperty.all(AppColors.transparentPurple),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        assetIc != null ? SizedBox(height: 25, child: Image(image: AssetImage('assets/icons/ic_$assetIc.png'))) : const SizedBox.shrink(),
        Text(' $txt', style: AppTextStyles.style9(context)),
      ],
    ),
  );
}

class MyTextField extends StatelessWidget {
  final BuildContext context1;
  final TextEditingController controller;
  final TextInputType keyboard;
  final FocusNode focus;
  final String errorTxt;
  final bool errorState;
  final bool suffixIc;
  final IconData icon;
  final String labelTxt;
  final String hintTxt;
  final String snackBarTxt;
  final bool? obscure;
  final bool disabled;
  final bool actionDone;
  final void Function() onChanged;
  final void Function() onTap;
  final void Function() onSubmitted;
  final void Function()? onTapEye;

  const MyTextField({
    super.key,
    required this.context1,
    required this.controller,
    required this.keyboard,
    required this.focus,
    required this.errorTxt,
    required this.errorState,
    required this.suffixIc,
    required this.icon,
    required this.labelTxt,
    required this.hintTxt,
    required this.snackBarTxt,
    required this.onChanged,
    required this.onTap,
    required this.onSubmitted,
    this.onTapEye,
    this.obscure,
    this.disabled = false,
    this.actionDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.transparentBlack,
        borderRadius: BorderRadius.circular(6),
      ),
      width: MediaQuery.of(context1).size.width - 60,
      child: TextField(
        enabled: !disabled,
        obscureText: icon == Icons.lock ? obscure! : false,
        cursorColor: AppColors.purple,
        controller: controller,
        style: errorState ? AppTextStyles.style7_1(context) : AppTextStyles.style7(context),
        onChanged: (v) => onChanged(),
        onTap: () => onTap(),
        onSubmitted: (v) => onSubmitted(),
        textInputAction: actionDone ? TextInputAction.done : TextInputAction.next,
        keyboardType: keyboard,
        focusNode: focus,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.transparent.withOpacity(.0001),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          error: errorState ? const SizedBox.shrink() : null,
          prefixIcon: SizedBox(
            width: 20,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Icon(
                    icon,
                    color: errorState
                        ? AppColors.red
                        : suffixIc
                            ? AppColors.green
                            : focus.hasFocus
                                ? AppColors.black
                                : AppColors.purple,
                  ),
                ),
              ],
            ),
          ),
          suffixIcon: SizedBox(
            height: 44,
            width: (controller.text.isNotEmpty || focus.hasFocus)
                ? icon == Icons.lock
                    ? 96
                    : 40
                : 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // #eye_button
                icon == Icons.lock && controller.text.isNotEmpty
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => onTapEye!(),
                        icon: Icon(
                          obscure! ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                          color: errorState
                              ? AppColors.red
                              : suffixIc
                                  ? AppColors.green
                                  : focus.hasFocus
                                      ? AppColors.black
                                      : AppColors.purple,
                        ),
                      )
                    : const SizedBox.shrink(),

                // #error_button_and_done
                controller.text.isNotEmpty || focus.hasFocus
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => !suffixIc ? Utils.mySnackBar(context: context1, txt: snackBarTxt, errorState: true) : {},
                        icon: suffixIc && !errorState
                            ? const Icon(Icons.done, color: AppColors.green)
                            : const Icon(Icons.error_outline, color: AppColors.red))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          labelText: labelTxt,
          hintText: hintTxt,
          hintStyle: AppTextStyles.style6(context),
          labelStyle: errorState ? AppTextStyles.style3_1(context) : AppTextStyles.style3(context),
          border: myInputBorder(color1: AppColors.black),
          enabledBorder: suffixIc
              ? myInputBorder(color1: AppColors.green)
              : myInputBorder(
                  color1: AppColors.black,
                  color2: AppColors.purple,
                  itsColor1: focus.hasFocus,
                ),
          disabledBorder: myInputBorder(color1: AppColors.transparentPurple),
          errorBorder: myInputBorder(color1: AppColors.red),
          focusedBorder: myInputBorder(
            color1: AppColors.green,
            color2: AppColors.black,
            itsColor1: suffixIc && !errorState,
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder myInputBorder({required Color color1, bool itsColor1 = true, Color? color2}) {
  return OutlineInputBorder(
    gapPadding: 1,
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(width: 2, color: itsColor1 ? color1 : color2!),
  );
}

class MyButton extends StatelessWidget {
  final bool enable;
  final String text;
  final Function function;
  final DisabledAction? disabledAction;

  const MyButton({
    super.key,
    required this.enable,
    required this.text,
    required this.function,
    this.disabledAction,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (enable) {
          function();
        } else {
          if (disabledAction != null) {
            Utils.mySnackBar(txt: disabledAction!.text, context: disabledAction!.context, errorState: true);
          }
        }
      },
      color: enable ? AppColors.purple : AppColors.transparentPurple,
      minWidth: double.infinity,
      height: 48,
      elevation: 0,
      highlightColor: ThemeService.getTheme == ThemeMode.dark ? AppColors.transparentBlack : AppColors.pink,
      splashColor: AppColors.pink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: enable ? AppTextStyles.style4(context).copyWith(color: Colors.white) : AppTextStyles.style5(context)),
    );
  }
}

class DisabledAction {
  final String text;
  final BuildContext context;

  DisabledAction({required this.text, required this.context});
}

BoxDecoration myGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.purple,
        AppColors.purpleAccent,
        AppColors.purpleLight,
        AppColors.black,
      ],
      begin: const Alignment(2.3, -.9),
      end: const Alignment(-2.8, .7),
    ),
  );
}
