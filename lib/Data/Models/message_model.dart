import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String? message;
  final String? sentBy;
  final Timestamp? sentAt;
  final Map? meta;
  final List? readBy;

  MessageModel({
    required this.id,
    required this.message,
    required this.sentBy,
    required this.sentAt,
    required this.meta,
    required this.readBy,
});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        id: json['id'],
        message: json['message'],
        sentBy: json['sentBy'],
        sentAt: json['sentAt'],
        meta: json['meta'],
        readBy: json['readBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "sentBy": sentBy,
      "sentAt": sentAt,
      "meta": meta,
      "readBy": readBy,
    };
  }
  @override
  int get hashCode => id.hashCode ^ sentBy.hashCode;

  @override
  bool operator == (Object other) {
    if (other.hashCode == hashCode){
      return true;
    } else {
      return false;
    }
  }

}