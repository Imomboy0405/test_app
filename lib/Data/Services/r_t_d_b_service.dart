import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/Configuration/article_model.dart';
import 'package:test_app/Data/Models/user_model.dart';

class RTDBService {
  static final database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> storeUser(UserModel userModel) async {
    await database.child('users').child(userModel.uid!).set(userModel.toJson());
    return database.onChildAdded;
  }

  static Future<List<UserModel>> loadUsers() async {
    Query query = database.child('users');
    DatabaseEvent event = await query.once();
    List<UserModel> users = [];
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      users = (event.snapshot.value as Map<dynamic, dynamic>)
          .values
          .map((model) {
            try {
              return UserModel.fromJson(Map<String, dynamic>.from(model));
            } catch (e) {
              debugPrint('Xatolik: $e');
              return null;
            }
          })
          .whereType<UserModel>()
          .toList();
    }
    return users;
  }

  static Future<List<ArticleModel>> loadArticles() async {
    Query query = database.child('articles/ru');
    DatabaseEvent event = await query.once();
    List<ArticleModel> articles = [];
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      articles = (event.snapshot.value as Map<dynamic, dynamic>)
          .entries
          .map((article) {
            try {
              article.value['id'] = article.key;
              return ArticleModel.fromJson(article.value);
            } catch (e) {
              debugPrint('Xatolik: $e');
              return null;
            }
          })
          .whereType<ArticleModel>()
          .toList();
    }
    return articles;
  }

  static Future<List<Map>> loadSeed() async {
    Query query = database.child('seed');
    DatabaseEvent event = await query.once();
    List<Map> seed = [];
    if (event.snapshot.value != null) {
      Map map = event.snapshot.value as Map;
      map.forEach((key, value) => seed.add(value));
    }
    return seed;
  }
}
