import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.score,
    required this.date,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['userName']! as String,
          score: json['score']! as int,
          date: json['date']! as Timestamp,
        );

  final String id;
  final String name;
  final int score;
  final Timestamp date;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userName': name,
      'score': score,
      'date': date,
    };
  }
}
