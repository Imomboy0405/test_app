import 'message_model.dart';

class ChatModel {
  List<MessageModel>? messages;

  ChatModel({required this.messages});

  ChatModel.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = [];
      for (var v in (json['messages'] as List)) {
        if (v is Map) {
          messages?.add(MessageModel.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (messages != null) {
      map['messages'] = messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}