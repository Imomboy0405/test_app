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