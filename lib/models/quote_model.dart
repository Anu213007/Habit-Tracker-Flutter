import 'dart:convert';

class QuoteModel {
  final String id;
  final String text;
  final String author;
  final String? category;
  final bool isFavorite;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    this.category,
    this.isFavorite = false,
  });

  factory QuoteModel.fromMap(Map<String, dynamic> map, String id) {
    return QuoteModel(
      id: id,
      text: map['text'] ?? '',
      author: map['author'] ?? '',
      category: map['category'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  factory QuoteModel.fromApi(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: map['content'] ?? map['text'] ?? '',
      author: map['author'] ?? 'Unknown',
      category: map['tags']?.isNotEmpty == true ? map['tags'][0] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  factory QuoteModel.fromJson(String source) =>
      QuoteModel.fromMap(json.decode(source), json.decode(source)['id']);

  String toJson() => json.encode(toMap());

  QuoteModel copyWith({
    String? id,
    String? text,
    String? author,
    String? category,
    bool? isFavorite,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
