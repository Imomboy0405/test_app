class MessageModel {
  final String id;
  final String msg;
  String dateTime;
  final bool typeUser;

  MessageModel({required this.id, required this.msg, required this.dateTime, required this.typeUser});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      msg: json['msg'] as String,
      dateTime: json['dateTime'] as String,
      typeUser: json['typeUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'msg': msg,
      'dateTime': dateTime,
      'typeUser': typeUser,
    };
  }
  @override
  int get hashCode => id.hashCode ^ dateTime.hashCode;

  @override
  bool operator == (Object other) {
    if (other.hashCode == hashCode){
      return true;
    } else {
      return false;
    }
  }

}