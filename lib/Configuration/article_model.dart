import 'dart:convert';

ArticleModel articleModelFromJson(String str) => ArticleModel.fromJson(json.decode(str));

class ArticleModel {
  late List<Content> content;
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
    content = parseString(json['content']);
    id = json['id'];
    image = json['image'];
    order = json['order'];
    title = json['title'];
  }
}

class Content {
  final String content;
  final bool bold;
  final bool large;
  final bool italic;

  Content({
    required this.content,
    this.bold = false,
    this.large = false,
    this.italic = false,
  });
}

List<Content> parseString(String text) {
  List<Content> result = [];
  bool isBold = false;
  bool isLarge = false;
  bool isItalic = false;
  String currentContent = "";

  for (int i = 0; i < text.length; i++) {
    String char = text[i];

    if (char == '*' && i + 1 < text.length && text[i + 1] == '*') {
      if (currentContent.isNotEmpty) {
        if (text[i + 2] == ':') {
          result.add(Content(content: currentContent + text[i + 2], bold: isBold, large: isLarge, italic: isItalic));
          i++;
        } else {
          result.add(Content(content: currentContent, bold: isBold, large: isLarge, italic: isItalic));
        }
        currentContent = "";
      }
      isBold = !isBold;
      i++; // Ikkinchi yulduzchani o'tkazib yuboramiz
    } else if (char == '#' && i + 4 < text.length && text.substring(i, i + 5) == '#####') {
      if (currentContent.isNotEmpty) {
        result.add(Content(content: currentContent, bold: isBold, large: isLarge, italic: isItalic));
        currentContent = "";
      }
      isBold = true;
      isItalic = true;
      i += 5; // Qolgan # belgilarini o'tkazib yuboramiz
    } else if (char == '#' && i + 3 < text.length && text.substring(i, i + 4) == '####') {
      if (currentContent.isNotEmpty && currentContent != ' ' && currentContent != '\n') {
        result.add(Content(content: currentContent, bold: isBold, large: isLarge, italic: isItalic));
        currentContent = "";
      }
      isBold = true;
      isLarge = true;
      i += 3; // Qolgan # belgilarini o'tkazib yuboramiz
    } else {
      currentContent += char;
      // Agar nuqta yoki bosh harfli so'z boshlansa, bold va large ni o'chiramiz
      if ((char == '.' || char == '\n' ||
              (currentContent.length > 3 && char.toUpperCase() == char && char != ' ' && char != ',')) &&
          (isBold || isLarge)) {
        if (char == '\n') {
          if (currentContent.isNotEmpty) {
            result.add(Content(content: currentContent.substring(0, currentContent.length - 1), bold: isBold, large: isLarge, italic: isItalic));
            currentContent = "\n";
          }
        } else
        if (currentContent.isNotEmpty) {
          result.add(Content(content: currentContent, bold: isBold, large: isLarge, italic: isItalic));
          currentContent = "";
        }
        isBold = false;
        isLarge = false;
        isItalic = false;
      }
    }
  }

  return result;
}
