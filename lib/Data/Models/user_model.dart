import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/Data/Models/group_model.dart';

UserModel userFromJson(String str) => UserModel.fromJsonLocal(json.decode(str));
String userToJson(UserModel data) => json.encode(data.toJsonLocal());

class UserModel {
  String? uid;
  String? email;
  String? displayName;
  Timestamp? createdAt;
  String? role;
  String? photoURL;
  String? phoneNumber;
  bool? verified;
  late List<GroupModel> groups;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.role,
    required this.verified,
    required this.phoneNumber,
    required this.photoURL,
    required this.groups,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    Timestamp? createdAt,
    String? role,
    String? phoneNumber,
    String? photoURL,
    bool? verified,
    List<GroupModel>? groups,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      role: role ?? this.role,
      verified: verified ?? this.verified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      groups: groups ?? this.groups,
    );
  }

  UserModel deepCopy() {
    String json = jsonEncode(this);
    return UserModel.fromJson(jsonDecode(json));
  }

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    createdAt = json['createdAt'];
    role = json['role'];
    verified = json['verified'];
    phoneNumber = json['phoneNumber'];
    photoURL = json['photoURL'];
    groups = [];
  }

  UserModel.fromJsonLocal(Map<dynamic, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    createdAt = Timestamp.fromDate(DateTime.parse(json['createdAt']));
    role = json['role'];
    verified = json['verified'];
    phoneNumber = json['phoneNumber'];
    photoURL = json['photoURL'];
    groups = [];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['email'] = email;
    map['displayName'] = displayName;
    map['createdAt'] = createdAt;
    map['role'] = role;
    map['verified'] = verified;
    map['photoURL'] = photoURL;
    map['phoneNumber'] = phoneNumber;
    map['groups'] = groups;
    return map;
  }

  Map<String, dynamic> toJsonLocal() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['email'] = email;
    map['displayName'] = displayName;
    map['createdAt'] = createdAt?.toDate().toIso8601String();
    map['role'] = role;
    map['verified'] = verified;
    map['photoURL'] = photoURL;
    map['phoneNumber'] = phoneNumber;
    map['groups'] = groups;
    return map;
  }
}

class UserDetailModel {
  late List<Entries> entries;
  late String? id;
  late Map<String, String>? title;

  UserDetailModel({
    required this.entries,
    required this.id,
    required this.title,
  });

  UserDetailModel.fromJson(dynamic json) {
    if (json['entries'] != null) {
      entries = [];
      json['entries'].forEach((k, v) {
        entries.add(Entries.fromJson(v));
      });
    }
    id = json['id'];
    title = Map<String,String>.from(json['title']);
  }

  UserDetailModel copyWith({
    List<Entries>? entries,
    String? id,
    Map<String, String>? title,
  }) =>
      UserDetailModel(
        entries: entries ?? this.entries,
        id: id ?? this.id,
        title: title ?? this.title,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    entries.map((v) => map.addAll(v.toJson()));
    return map;
  }
}

class Entries {
  late String id;
  late List<Entries>? entries;
  late int index;
  late int? max;
  late int? min;
  late Map<String, String>? title;
  late String? type;
  late bool? flex;

  Entries({
    required this.id,
    required this.index,
    this.max,
    this.min,
    this.entries,
    this.flex,
    required this.title,
    required this.type,
  });

  Entries.fromJson(dynamic json) {
    id = json['id'];
    index = json['index'];
    max = json['max'];
    min = json['min'];
    title = json['title'] != null ? Map<String, String>.from(json['title']) : null;
    type = json['type'];
    entries = json['entries']?.map((map) => Entries.fromJson(map)).toList().whereType<Entries>().toList();
    flex = json['flex'];
  }

  Entries copyWith({
    String? id,
    int? index,
    dynamic value,
    int? max,
    int? min,
    Map<String, String>? title,
    String? type,
    List<Entries>? entries,
    bool? flex,
  }) =>
      Entries(
        id: id ?? this.id,
        index: index ?? this.index,
        max: max ?? this.max,
        min: min ?? this.min,
        title: title ?? this.title,
        type: type ?? this.type,
        entries: entries ?? this.entries,
        flex: flex ?? this.flex,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (entries != null && entries!.isNotEmpty) {
      entries!.map((v) => map.addAll(v.toJson()));
    }
    return map;
  }
}
