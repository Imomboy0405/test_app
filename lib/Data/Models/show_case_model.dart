import 'dart:convert';

ShowCaseModel showCaseModelFromJson(String str) => ShowCaseModel.fromJson(json.decode(str));
String showCaseModelToJson(ShowCaseModel data) => json.encode(data.toJson());

class ShowCaseModel {
  late bool home;
  late bool test;
  late bool profile;
  late bool profileDetail;
  late bool testDetail;
  late bool quiz;

  ShowCaseModel({
    this.home = false,
    this.test = false,
    this.profile = false,
    this.profileDetail = false,
    this.testDetail = false,
    this.quiz = false,
  });

  ShowCaseModel.fromJson(dynamic json) {
    home = json['home'];
    test = json['test'];
    profile = json['profile'];
    profileDetail = json['profileDetail'];
    testDetail = json['testDetail'];
    quiz = json['quiz'];
  }

  ShowCaseModel copyWith({
    bool? home,
    bool? test,
    bool? profile,
    bool? profileDetail,
    bool? testDetail,
    bool? quiz,
  }) =>
      ShowCaseModel(
        home: home ?? this.home,
        test: test ?? this.test,
        profile: profile ?? this.profile,
        profileDetail: profileDetail ?? this.profileDetail,
        testDetail: testDetail ?? this.testDetail,
        quiz: quiz ?? this.quiz,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['home'] = home;
    map['test'] = test;
    map['profile'] = profile;
    map['profileDetail'] = profileDetail;
    map['testDetail'] = testDetail;
    map['quiz'] = quiz;
    return map;
  }
}
