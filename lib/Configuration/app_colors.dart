import 'dart:ui';

abstract class AppColors {

  static Color get white => /*ThemeService.getTheme == ThemeMode.dark ? _white :*/ _black;

  static Color get black => /*ThemeService.getTheme == ThemeMode.dark ? _black :*/ _white;

  static Color get purple => /*ThemeService.getTheme == ThemeMode.dark ? _purple :*/ _purpleLight;

  static Color get whitePurple => /*ThemeService.getTheme == ThemeMode.dark ? _purpleLight :*/ _white;

  static Color get transparentPurple => /*ThemeService.getTheme == ThemeMode.dark ? _transparentBlue :*/ _transparentBlueLight;

  static Color get darkGrey => /*ThemeService.getTheme == ThemeMode.dark ? _darkGrey :*/ _transparentBlueLight;

  static Color get transparentBlack => /*ThemeService.getTheme == ThemeMode.dark ? _transparentBlack :*/ _transparentWhite;

  static Color get transparentWhite => /*ThemeService.getTheme == ThemeMode.dark ? _transparentWhite :*/ _transparentBlack;

  static Color get gray => /*ThemeService.getTheme == ThemeMode.dark ? _gray :*/ _transparentBlueLight;

  static Color get purpleLight => /*ThemeService.getTheme == ThemeMode.dark ? _purpleLightLightMode :*/ _purpleLightDarkMode;

  static Color get purpleAccent => /*ThemeService.getTheme == ThemeMode.dark ? _purpleAccent :*/ _purpleAccentDarkMode;

  static Color get darkPink => /*ThemeService.getTheme == ThemeMode.dark ? darkPink1 :*/ _purpleAccentDarkMode;

  static Color get pinkWhite => /*ThemeService.getTheme == ThemeMode.dark ? white :*/ pink;

  static const transparent = Color(0x00000000);

  static const red = Color(0xffff0000);

  static const pink = Color(0xffE8B6B7);

  static const pink2 = Color(0xffD5A8A2);

  static const blue = Color(0xff00AAFF);

  static const green = Color(0xff40B842);

  static const whiteConst = Color(0xffffffff);

  // static const _purpleAccent = Color(0x9fEBB9B2);

  static const darkPink1 = Color(0xff6E346B);

  static const _purpleAccentDarkMode = Color(0xdfEBB9B2);

  // static const _purpleLightLightMode = Color(0x77EBB9B2);

  static const _purpleLightDarkMode = Color(0xffEBB9B2);

  static const _white = Color(0xffffffff);

  static const _black = Color(0xff000000);

  // static const _purple = Color(0xffE0A5A5);

  static const _purpleLight = Color(0xffAD7F7F);

  // static const _transparentBlue = Color(0x36EB7878);

  static const _transparentBlueLight = Color(0x36B5639C);

  static const _transparentBlack = Color(0x86000000);

  static const _transparentWhite = Color(0x86ffffff);

  // static const _darkGrey = Color(0xff7C7C7C);

  // static const _gray = Color(0xff4e4e4e);
}