import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));
String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? uId;
  String? email;
  String? fullName;
  String? password;
  String? createdTime;
  String? loginType;
  List<List> userDetailList = [];

  UserModel({
    required this.uId,
    required this.email,
    required this.fullName,
    required this.password,
    required this.createdTime,
    required this.loginType,
    required this.userDetailList,
  });

  UserModel copyWith({
    String? uId,
    String? email,
    String? fullName,
    String? password,
    String? createdTime,
    String? loginType,
    List<List>? userDetailList,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      createdTime: createdTime ?? this.createdTime,
      loginType: loginType ?? this.loginType,
      userDetailList: userDetailList ?? this.userDetailList,
    );
  }

  UserModel deepCopy() {
    String json = jsonEncode(this);
    return UserModel.fromJson(jsonDecode(json));
  }

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    uId = json['uId'];
    email = json['email'];
    fullName = json['fullName'];
    password = json['password'];
    createdTime = json['createdTime'];
    loginType = json['loginType'];
    if (json['userDetailList'] != null) {
      json['userDetailList'].forEach((list) {
        userDetailList.add(list.map((v) => v['type'] == 'group' ? UserDetailModel.fromJson(v) : Entries.fromJson(v)).toList());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = uId;
    map['email'] = email;
    map['fullName'] = fullName;
    map['password'] = password;
    map['createdTime'] = createdTime;
    map['loginType'] = loginType;
    map['userDetailList'] = userDetailList.map((list) => list.map((v) => v.toJson()).toList()).toList();
    return map;
  }
}

UserDetailModel medicalHistoryModelFromJson(String str) => UserDetailModel.fromJson(json.decode(str));
String medicalHistoryModelToJson(UserDetailModel data) => json.encode(data.toJson());

class UserDetailModel {
  late List<Entries> entries;
  late String id;
  late int index;
  late bool? flex;
  late String? title;
  late String type;

  UserDetailModel({
    required this.entries,
    required this.id,
    required this.index,
    required this.title,
    required this.type,
    required this.flex,
  });

  UserDetailModel.fromJson(dynamic json) {
    if (json['entries'] != null) {
      entries = [];
      json['entries'].forEach((v) {
        entries.add(Entries.fromJson(v));
      });
    }
    id = json['id'];
    index = json['index'];
    title = json['title'];
    type = json['type'];
    flex = json['flex'];
  }

  UserDetailModel copyWith({
    List<Entries>? entries,
    String? id,
    int? index,
    String? title,
    String? type,
    bool? flex,
  }) =>
      UserDetailModel(
        entries: entries ?? this.entries,
        id: id ?? this.id,
        index: index ?? this.index,
        title: title ?? this.title,
        type: type ?? this.type,
        flex: flex ?? this.flex,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['entries'] = entries.map((v) => v.toJson()).toList();
    map['id'] = id;
    map['index'] = index;
    map['title'] = title;
    map['type'] = type;
    map['flex'] = flex;
    return map;
  }
}

Entries entriesFromJson(String str) => Entries.fromJson(json.decode(str));
String entriesToJson(Entries data) => json.encode(data.toJson());

class Entries {
  late String id;
  late int index;
  late dynamic value;
  late int? max;
  late int? min;
  late String title;
  late String type;

  Entries({
    required this.id,
    required this.index,
    required this.value,
    this.max,
    this.min,
    required this.title,
    required this.type,
  });

  Entries.fromJson(dynamic json) {
    id = json['id'];
    index = json['index'];
    value = json['type'] == 'boolean' ? json['value'] ?? false : json['value'];
    max = json['max'];
    min = json['min'];
    title = json['title'];
    type = json['type'];
  }

  Entries copyWith({
    String? id,
    int? index,
    dynamic value,
    int? max,
    int? min,
    String? title,
    String? type,
  }) =>
      Entries(
        id: id ?? this.id,
        index: index ?? this.index,
        value: value ?? this.value,
        max: max ?? this.max,
        min: min ?? this.min,
        title: title ?? this.title,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['index'] = index;
    map['value'] = value;
    map['max'] = max;
    map['min'] = min;
    map['title'] = title;
    map['type'] = type;
    return map;
  }
}
