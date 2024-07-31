import 'lang_service.dart';
import 'theme_service.dart';

class Init {
  static Future<void> initialize() async {
    await _loading();
  }

  static Future<void> _loading() async {
    await LangService.currentLanguage();
    await ThemeService.currentTheme();
    // await Future.delayed(const Duration(seconds: 1));
  }
}