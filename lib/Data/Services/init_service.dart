import 'lang_service.dart';
import 'theme_service.dart';

class Init {
  static Future initialize() async {
    await _loading();
  }

  static _loading() async {
    await LangService.currentLanguage();
    await ThemeService.currentTheme();
    await Future.delayed(const Duration(seconds: 1));
  }
}