import 'package:test_app/Data/Models/user_model.dart';
import 'package:test_app/Data/Services/lang_service.dart';

class LogicService {
  static bool checkFullName(String fullName) {
    if (fullName.replaceAll(' ', '').length > 2) {
      return true;
    }
    return false;
  }

  static bool checkEmail(String email) {
    if (email.contains('@') &&
        email.contains('.') &&
        email.trim().length > 4) {
      return true;
    }
    return false;
  }

  static bool checkPassword(String password) {
    if (password.length > 5 &&
        !password.contains(' ') &&
        (password.contains(RegExp('[a-z]')) || password.contains(RegExp('[A-Z]'))) &&
        password.contains(RegExp('[0-9]')) &&
        !password.trim().contains(' ')) {
      return true;
    }
    return false;
  }

  static String parseError(String e) {
    return e.substring(e.indexOf('/') + 1, e.indexOf(']'));
  }

  static bool selectModelsFound(List list, Map<String, dynamic> map) {
    for (var model in list) {
      if (model is Entries && map[model.id] is bool && map[model.id]) {
        return true;
      }
    }
    return false;
  }

  static bool selectModelsFoundOrOtherModel(var model, Map<String, dynamic> map) {
    for (Entries entry in model.entries) {
      if (map[entry.id] is bool && map[entry.id] || map[entry.id] is! bool) {
        return true;
      }
    }
    return false;
  }

  static bool selectModelFound(var model, Map<String, dynamic> map) {
    return model.entries.lastIndexWhere((Entries entry) => map[entry.id] is bool && map[entry.id]) != -1;
  }

  static String selectedEntryTitles(model) {
    List list = model.entries
        .where((entry) => entry.value == true || entry.value is int)
        .map((entry) => entry.value == true ? entry.title : [entry.title, entry.value])
        .toList();
    if (list.length == 2) {
      return '${list[0].toString().tr()}, ${list[1] is List ? '${list[1][0].toString().tr()} ${list[1][1]}' : list[1].toString().tr()}';
    }
    return list[0].toString().tr();
  }


}
