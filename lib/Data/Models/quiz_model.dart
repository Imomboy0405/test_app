import 'dart:convert';

class QuizModel {
  String question;
  List<Answers> answers;
  String group;

  QuizModel({
    required this.question,
    required this.answers,
    required this.group,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'],
      answers:(json['answers'] as List).map((answer) => Answers.fromJson(answer)).toList(),
      group: json['group'],
    );
  }
  @override
  String toString() {
    return 'Question: $question\nAnswers: $answers\n\n';
  }
}

class Answers {
  late String title;
  late int value;

  Answers({
    required this.title,
    required this.value,
  });

  factory Answers.fromJson(Map<String, dynamic> json) {
    return Answers(
      title: json['title'],
      value: json['value'],
    );
  }
  @override
  String toString() {
    return 'title: $title\nball: $value';
  }
}

List<QuizModel> createQuizModelList(String jsonString) {
  List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => QuizModel.fromJson(json)).toList();
}