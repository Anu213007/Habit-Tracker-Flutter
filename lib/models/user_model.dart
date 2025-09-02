// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? gender;
  final String? dateOfBirth;
  final String? height;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isDarkMode;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.height,
    required this.createdAt,
    required this.lastLoginAt,
    this.isDarkMode = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      height: map['height'],
      createdAt: map['createdAt'] is String
          ? DateTime.parse(map['createdAt'])
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      lastLoginAt: map['lastLoginAt'] is String
          ? DateTime.parse(map['lastLoginAt'])
          : DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt']),
      isDarkMode: map['isDarkMode'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'height': height,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'isDarkMode': isDarkMode,
    };
  }

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? height,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isDarkMode,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, displayName: $displayName, email: $email)';
  }
}
