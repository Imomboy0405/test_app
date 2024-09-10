import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/Data/Models/message_model.dart';

class GroupModel {
  final Timestamp? createdAt;
  final String? createdBy;
  final String? id;
  final List<String>? members;
  final int? membersCount;
  final MessageModel? recentMessage;
  final int? type;
  final Timestamp? updatedAt;

  GroupModel({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.members,
    required this.membersCount,
    required this.recentMessage,
    required this.type,
    required this.updatedAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> map) {
    return GroupModel(
      createdAt: map['createdAt'],
      createdBy: map['createdBy'],
      id: map['id'],
      members: List<String>.from(map['members']),
      membersCount: map['membersCount'],
      recentMessage: MessageModel.fromJson(map['recentMessage']),
      type: map['type'],
      updatedAt: map['updatedAt'],
    );
  }

  GroupModel copyWith(int membersCount, List<String> members) {
    return GroupModel(
      createdAt:  createdAt,
      createdBy: createdBy,
      id: id,
      members: members,
      membersCount: membersCount,
      recentMessage: recentMessage,
      type: type,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'createdBy': createdBy,
    'id': id,
    'members': members,
    'membersCount': membersCount,
    'recentMessage': recentMessage?.toJson(),
    'type': type,
    'updatedAt': updatedAt,
  };
}
