import 'package:firebase_database/firebase_database.dart';
import 'package:test_app/Data/Models/chat_model.dart';
import 'package:test_app/Data/Models/user_model.dart';

class RTDBService {
  static final database = FirebaseDatabase.instance.ref();


  static Future<Stream<DatabaseEvent>> storeUser(UserModel userModel) async {
    await database.child('users').child(userModel.uId!).set(userModel.toJson());
    return database.onChildAdded;
  }

  static Future<Stream<DatabaseEvent>> deleteUser(UserModel userModel) async {
    await database.child('users').child(userModel.uId!).remove();
    return database.onChildAdded;
  }

  static Future<UserModel?> loadUser(String uId) async {
    final snapshot = await database.child('users/$uId').get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.value as Map);
    }
    return null;
  }

  static Future<List<UserModel>> loadUsers() async {
    Query query = database.child('users');
    DatabaseEvent event = await query.once();
    List<UserModel> users = [];
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      users = (event.snapshot.value as Map<dynamic, dynamic>).values
          .map((model) {
        try {
          return UserModel.fromJson(Map<String, dynamic>.from(model));
        } catch (e) {
          print('Xatolik: $e');
          return null;
        }
      })
          .whereType<UserModel>()
          .toList();
    }
    return users;
  }

  static Future<Stream<DatabaseEvent>> storeChat(ChatModel model, String uId) async {
    await database.child('chat').child(uId).set(model.toJson());
    return database.onChildAdded;
  }

  static Future<ChatModel> loadChat(String uId) async {
    Query query = database.child('chat').child(uId);
    DatabaseEvent event = await query.once();
    ChatModel chatModel = ChatModel(messages: []);
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      chatModel = ChatModel.fromJson(Map<String, dynamic>.from(event.snapshot.value as Map));
    }
    return chatModel;
  }
}