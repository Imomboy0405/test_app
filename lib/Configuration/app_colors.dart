import 'dart:ui';
import 'package:test_app/Data/Services/theme_service.dart';

abstract class AppColors {

  static Color get white => ThemeService.getTheme == ThemeMode.dark ? _white : _black;

  static Color get black => ThemeService.getTheme == ThemeMode.dark ? _black : _white;

  static Color get blackBlue => ThemeService.getTheme == ThemeMode.dark ? _darker : _darkerLight;

  static Color get purple => ThemeService.getTheme == ThemeMode.dark ? _purple : _purpleLight;

  static Color get transparentPurple => ThemeService.getTheme == ThemeMode.dark ? _transparentBlue : _transparentBlueLight;

  static Color get darkGrey => ThemeService.getTheme == ThemeMode.dark ? _darkGrey : _transparentBlueLight;

  static Color get lightGrey => ThemeService.getTheme == ThemeMode.dark ? _lightGrey : _darkerLight;

  static Color get orange => ThemeService.getTheme == ThemeMode.dark ? _orange : _white;

  static Color get transparentBlueStatus => ThemeService.getTheme == ThemeMode.dark ? _transparentBlue : _cyan;

  static Color get blueStatus => ThemeService.getTheme == ThemeMode.dark ? _purple : _white;

  static Color get transparentRedStatus => ThemeService.getTheme == ThemeMode.dark ? transparentRed : red;

  static Color get redStatus => ThemeService.getTheme == ThemeMode.dark ? red : _white;

  static Color get transparentOrange => ThemeService.getTheme == ThemeMode.dark ? _transparentOrange : _orange;

  static Color get transparentBlack => ThemeService.getTheme == ThemeMode.dark ? _transparentBlack : _transparentWhite;

  static Color get transparentWhite => ThemeService.getTheme == ThemeMode.dark ? _transparentWhite : _transparentBlack;

  static Color get darker => ThemeService.getTheme == ThemeMode.dark ? _darker : _white;

  static Color get dark => ThemeService.getTheme == ThemeMode.dark ? _dark : _white;

  static Color get gray => ThemeService.getTheme == ThemeMode.dark ? _gray : _transparentBlueLight;

  static Color get transparentGray => ThemeService.getTheme == ThemeMode.dark ? _transparentGray : _transparentBlueLight;

  static Color get purpleLight => ThemeService.getTheme == ThemeMode.dark ? _purpleLightLightMode : _purpleLightDarkMode;

  static Color get purpleAccent => ThemeService.getTheme == ThemeMode.dark ? _purpleAccent : _purpleAccentDarkMode;

  static Color get darkPink => ThemeService.getTheme == ThemeMode.dark ? _darkPink : _purpleAccentDarkMode;

  static const _purpleAccent = Color(0x9fff00Ff);

  static const _darkPink = Color(0xff9F00ff);

  static const whiteConst = Color(0xffffffff);

  static const _purpleAccentDarkMode = Color(0xffEE4AF8);

  static const _purpleLightLightMode = Color(0x77FF0fE8);

  static const _purpleLightDarkMode = Color(0xffFF84E8);

  static const pink = Color(0xffFF00FA);

  static const blue = Color(0xff00AAFF);

  static const green = Color(0xff00dd00);

  static const _white = Color(0xffffffff);

  static const _black = Color(0xff000000);

  static const _purple = Color(0xffff00ff);

  static const _purpleLight = Color(0xff9D25A8);

  static const _cyan = Color(0xff1EBBFF);

  static const _transparentBlue = Color(0x3600A795);

  static const _transparentBlueLight = Color(0x364A21EF);

  static const _transparentBlack = Color(0x86000000);

  static const _transparentWhite = Color(0x86ffffff);

  static const _darkGrey = Color(0xff7C7C7C);

  static const _lightGrey = Color(0xffa6a6a6);

  static const _transparentOrange = Color(0x36FDAB2A);

  static const _orange = Color(0xffFDAB2A);

  static const transparentRed = Color(0x36ff0000);

  static const _transparentGray = Color(0x36a5a5a5);

  static const _darker = Color(0xff141416);

  static const _darkerLight = Color(0xff433073);

  static const _dark = Color(0xff2a2a2d);

  static const _gray = Color(0xff4e4e4e);

  static const transparent = Color(0x00000000);

  static const red = Color(0xffff0000);
}