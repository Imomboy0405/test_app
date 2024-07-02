import 'dart:convert';

ArticleModel articleModelFromJson(String str) => ArticleModel.fromJson(json.decode(str));
String articleModelToJson(ArticleModel data) => json.encode(data.toJson());

class ArticleModel {
  late String content;
  late String id;
  late String image;
  late int order;
  late String title;

  ArticleModel({
    required this.content,
    required this.id,
    required this.image,
    required this.order,
    required this.title,
  });

  ArticleModel.fromJson(dynamic json) {
    content = json['content'];
    id = json['id'];
    image = json['image'];
    order = json['order'];
    title = json['title'];
  }

  ArticleModel copyWith({
    String? content,
    String? id,
    String? image,
    int? order,
    String? title,
  }) =>
      ArticleModel(
        content: content ?? this.content,
        id: id ?? this.id,
        image: image ?? this.image,
        order: order ?? this.order,
        title: title ?? this.title,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['id'] = id;
    map['image'] = image;
    map['order'] = order;
    map['title'] = title;
    return map;
  }
}
