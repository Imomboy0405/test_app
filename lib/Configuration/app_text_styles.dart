import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  /// color: blue, size: 40, weight: bold, font: monda
  static TextStyle style0 = const TextStyle(color: Color(0xffFF00FA), fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Monda', letterSpacing: 1.5);

  /// Example text style: color - blue, size - 20, weight - bold, font - monda
  static TextStyle style0_1(BuildContext context) => _baseStyle(context, AppColors.purple, 20, FontWeight.bold, 'Monda', letterSpacing: 1.5);

  /// Example text style: color - blue, size - 26, weight - bold, font - monda
  static TextStyle style0_2(BuildContext context) => _baseStyle(context, AppColors.purple, 26, FontWeight.bold, 'Monda', letterSpacing: 1.5);

  /// Example text style: color - blue, size - 22, weight - bold, font - Poppins
  static TextStyle style1(BuildContext context) => _baseStyle(context, AppColors.purple, 22, FontWeight.bold, 'Poppins');

  /// Example text style: color - black, size - 14, font - Poppins
  static TextStyle style2(BuildContext context) => _baseStyle(context, AppColors.black, 14, FontWeight.normal, 'Poppins');

  /// Example text style: color - purple, size - 18, weight - bold, font - Poppins
  static TextStyle style3(BuildContext context) => _baseStyle(context, AppColors.purple, 18, FontWeight.bold, 'Poppins');

  /// Example text style: color - green, size - 30, weight - bold, font - Poppins
  static TextStyle style3_0(BuildContext context) => _baseStyle(context, AppColors.green, 30, FontWeight.bold, 'Poppins');

  /// Example text style: color - red, size - 18, weight - bold, font - Poppins
  static TextStyle style3_1(BuildContext context) => _baseStyle(context, AppColors.red, 18, FontWeight.bold, 'Poppins');

  /// Example text style: color - black, size - 18, weight - w500, font - Poppins
  static TextStyle style4(BuildContext context) => _baseStyle(context, AppColors.black, 18, FontWeight.w500, 'Poppins');

  /// Example text style: color - black, size - 18, weight - bold, font - Poppins
  static TextStyle style4_1(BuildContext context) => _baseStyle(context, AppColors.black, 18, FontWeight.bold, 'Poppins');

  /// Example text style: color - transparentBlue, size - 18, weight - w500, font - Poppins
  static TextStyle style5(BuildContext context) => _baseStyle(context, AppColors.transparentPurple, 18, FontWeight.w500, 'Poppins');

  /// Example text style: color - darkGrey, size - 18, font - Poppins
  static TextStyle style6(BuildContext context) => _baseStyle(context, AppColors.darkGrey, 18, FontWeight.normal, 'Poppins');

  /// Example text style: color - purple, size - 18, font - Poppins
  static TextStyle style7(BuildContext context) => _baseStyle(context, AppColors.purple, 18, FontWeight.normal, 'Poppins');

  /// Example text style: color - purpleAccent, size - 18, font - Poppins
  static TextStyle style7_0(BuildContext context) => _baseStyle(context, AppColors.purpleAccent, 18, FontWeight.normal, 'Poppins');

  /// Example text style: color - red, size - 18, font - Poppins
  static TextStyle style7_1(BuildContext context) => _baseStyle(context, AppColors.red, 18, FontWeight.normal, 'Poppins');

  /// Example text style: color - black, size - 14, font - Poppins
  static TextStyle style8(BuildContext context) => _baseStyle(context, AppColors.black, 14, FontWeight.normal, 'Poppins');

  /// Example text style: color - purple, size - 14, weight - bold, font - Poppins
  static TextStyle style9(BuildContext context) => _baseStyle(context, AppColors.purple, 14, FontWeight.bold, 'Poppins');

  /// Example text style: color - purpleAccent, size - 22, font - Poppins
  static TextStyle style10(BuildContext context) => _baseStyle(context, AppColors.pink, 22, FontWeight.normal, 'Poppins');

  /// Example text style: color - black, size - 24, weight - bold, font - Poppins
  static TextStyle style11(BuildContext context) => _baseStyle(context, AppColors.black, 24, FontWeight.bold, 'Poppins');

  /// Example text style: color - black, size - 30, weight - bold, font - Poppins
  static TextStyle style12(BuildContext context) => _baseStyle(context, AppColors.black, 30, FontWeight.bold, 'Poppins');

  /// Example text style: color - white, size - 14, weight - w400, font - Poppins
  static TextStyle style13(BuildContext context) => _baseStyle(context, AppColors.white, 14, FontWeight.w400, 'Poppins');

  /// Example text style: color - transparentBlue, size - 14, weight - w400, font - Poppins
  static TextStyle style14(BuildContext context) => _baseStyle(context, AppColors.transparentPurple, 14, FontWeight.w400, 'Poppins');

  /// Example text style: color - white, size - 14, font - Poppins
  static TextStyle style15(BuildContext context) => _baseStyle(context, AppColors.white, 14, FontWeight.normal, 'Poppins');

  /// Example text style: color - purple, size - 24, weight - bold, font - Poppins
  static TextStyle style16(BuildContext context) => _baseStyle(context, AppColors.purple, 24, FontWeight.bold, 'Poppins');

  /// Example text style: color - blue, size - 11, font - Poppins
  static TextStyle style17(BuildContext context) => _baseStyle(context, AppColors.purple, 11, FontWeight.normal, 'Poppins');

  /// Example text style: color - black, size - 18, weight - w500, font - Ubuntu
  static TextStyle style18(BuildContext context) => _baseStyle(context, AppColors.black, 18, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - purple, size - 18, weight - w500, font - Ubuntu
  static TextStyle style18_0(BuildContext context) => _baseStyle(context, AppColors.purple, 18, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - white, size - 18, weight - w700, font - Ubuntu
  static TextStyle style18_1(BuildContext context) => _baseStyle(context, AppColors.white, 18, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - whiteConst, size - 14, weight - w500, font - Ubuntu
  static TextStyle style19(BuildContext context) => _baseStyle(context, AppColors.whiteConst, 14, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - lightGrey, size - 14, weight - w500, font - Ubuntu
  static TextStyle style19_1(BuildContext context) => _baseStyle(context, AppColors.lightGrey, 14, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - black, size - 16, weight - w700, font - Ubuntu
  static TextStyle style20(BuildContext context) => _baseStyle(context, AppColors.black, 16, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - black, size - 16, weight - w400, font - Ubuntu
  static TextStyle style20_1(BuildContext context) => _baseStyle(context, AppColors.black, 16, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - white, size - 16, weight - w400, font - Ubuntu
  static TextStyle style20_2(BuildContext context) => _baseStyle(context, AppColors.white, 16, FontWeight.w400, 'Ubuntu');

  /// Example text style: color - white, size - 11, weight - w700, font - Ubuntu
  static TextStyle style21(BuildContext context) => _baseStyle(context, AppColors.purple, 11, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - lightGrey, size - 10, weight - w500, font - Ubuntu
  static TextStyle style22(BuildContext context) => _baseStyle(context, AppColors.lightGrey, 10, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - purple, size - 14, weight - w400, font - Ubuntu
  static TextStyle style23(BuildContext context) => _baseStyle(context, AppColors.purple, 14, FontWeight.w400, 'Ubuntu');

  /// Example text style: color - purple, size - 14, weight - w500, font - Ubuntu
  static TextStyle style23_0(BuildContext context) => _baseStyle(context, AppColors.purple, 14, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - white, size - 14, weight - w700, font - Ubuntu
  static TextStyle style23_1(BuildContext context) => _baseStyle(context, AppColors.white, 14, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - green, size - 14, weight - w700, font - Ubuntu
  static TextStyle style23_3(BuildContext context) => _baseStyle(context, AppColors.green, 14, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - red, size - 14, weight - w700, font - Ubuntu
  static TextStyle style23_2(BuildContext context) => _baseStyle(context, AppColors.red, 14, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - white, size - 16, weight - w500, font - Ubuntu
  static TextStyle style24(BuildContext context) => _baseStyle(context, AppColors.white, 16, FontWeight.w500, 'Ubuntu');

  /// Example text style: color - gray, size - 14, weight - w400, font - Ubuntu
  static TextStyle style25(BuildContext context) => _baseStyle(context, AppColors.gray, 14, FontWeight.w400, 'Ubuntu');

  /// Example text style: color - darkGrey, size - 14, weight - w700, font - Ubuntu
  static TextStyle style25_1(BuildContext context) => _baseStyle(context, AppColors.darkGrey, 14, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - lightGrey, size - 14, weight - w700, font - Ubuntu
  static TextStyle style25_2(BuildContext context) => _baseStyle(context, AppColors.lightGrey, 14, FontWeight.w700, 'Ubuntu');

  /// Example text style: color - white, size - 16, weight - w400, font - Ubuntu
  static TextStyle style26(BuildContext context) => _baseStyle(context, AppColors.white, 16, FontWeight.w400, 'Ubuntu');

  /// Example text style: color - black, size - 12, weight - w500, font - Ubuntu
  static TextStyle style27(BuildContext context) => _baseStyle(context, AppColors.black, 11, FontWeight.w500, 'Ubuntu');

  /// Base text style function to avoid code duplication.
  static TextStyle _baseStyle(BuildContext context, Color color, double fontSize, FontWeight fontWeight, String fontFamily, {double letterSpacing = 0.0}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
    );
  }
}