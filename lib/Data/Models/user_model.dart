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

  UserModel({
    required this.uId,
    required this.email,
    required this.fullName,
    required this.password,
    required this.createdTime,
    required this.loginType,
  });

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    uId = json['uId'];
    email = json['email'];
    fullName = json['fullName'];
    password = json['password'];
    createdTime = json['createdTime'];
    loginType = json['loginType'];
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['uId'] = uId;
    map['email'] = email;
    map['fullName'] = fullName;
    map['password'] = password;
    map['createdTime'] = createdTime;
    map['loginType'] = loginType;
    return map;
  }
}