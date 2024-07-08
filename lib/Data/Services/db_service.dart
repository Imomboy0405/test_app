import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/Data/Models/show_case_model.dart';
import 'package:test_app/Data/Models/chat_model.dart';
import 'package:test_app/Data/Models/user_model.dart';

enum StorageKey { lang, theme, user, chat, test, showCase, sound }

class DBService {

  static Future<bool> saveLang(String lang) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.lang.name, lang);
  }

  static Future<bool> saveTheme(String theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.theme.name, theme);
  }

  static Future<bool> saveSound(String sound) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.sound.name, sound);
  }

  static Future<bool> saveUser(UserModel user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.user.name, userToJson(user));
  }

  static Future<bool> saveChat(ChatModel chat) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.chat.name, jsonEncode(chat.toJson()));
  }

  static Future<bool> saveTest(List<int> list) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.test.name, jsonEncode(list));
  }

  static Future<bool> saveShowCase(ShowCaseModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(StorageKey.showCase.name, showCaseModelToJson(model));
  }

  static Future<String?> loadData(StorageKey storageKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(storageKey.name);
  }

  static Future<bool> deleteData(StorageKey storageKey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(storageKey.name);
  }
}
