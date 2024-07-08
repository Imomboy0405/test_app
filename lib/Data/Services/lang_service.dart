import 'db_service.dart';
import 'locals/en_us.dart';
import 'locals/ru_ru.dart';
import 'locals/uz_kr.dart';
import 'locals/uz_uz.dart';
import 'locals/uz_qr.dart';

enum Language { en, ru, uz, kr, qr }

abstract class LangService {
  static Language _language = Language.uz;

  static Future<Language> currentLanguage() async {
    String? lang = await DBService.loadData(StorageKey.lang);
    _language = _stringToLanguage(lang);
    return _language;
  }

  // setter
  static Future<void> language(Language language) async {
    _language = language;
    await DBService.saveLang(language.name);
  }

  // getter
  static Language get getLanguage => _language;

  static Language _stringToLanguage(String? lang) {
    switch (lang) {
      case "en":
        return Language.en;
      case "ru":
        return Language.ru;
      case "qr":
        return Language.qr;
      case "kr":
        return Language.kr;
      default:
        return Language.uz;
    }
  }
}

extension Translation on String {
  String tr({Language? language}) {
    switch (language ?? LangService.getLanguage) {
      case Language.en:
        return enUS[this] ?? 'EN_NULL';
      case Language.ru:
        return ruRU[this] ?? 'RU_NULL';
      case Language.uz:
        return uzUZ[this] ?? 'UZ_NULL';
      case Language.kr:
        return uzKR[this] ?? 'KR_NULL';
      case Language.qr:
        return uzQR[this] ?? 'QR_NULL';
    }
  }
}
