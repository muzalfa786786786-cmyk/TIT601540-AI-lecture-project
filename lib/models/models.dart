import 'package:flutter/material.dart';

// ==================== USER MODEL ====================
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // student | teacher | admin
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    uid: m['uid'] ?? '',
    name: m['name'] ?? '',
    email: m['email'] ?? '',
    role: m['role'] ?? 'student',
    photoUrl: m['photoUrl'],
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'role': role,
    'photoUrl': photoUrl,
  };
}

// ==================== SLIDE MODEL ====================
class SlideModel {
  String id;
  String title;
  String topic;
  String subject;
  String level;
  int slideCount;
  List<String> slides;
  DateTime createdAt;
  String? content; // Added for Provider compatibility
  Color? thumbnailColor; // Added for Provider compatibility

  SlideModel({
    required this.id,
    required this.title,
    required this.topic,
    required this.subject,
    required this.level,
    required this.slideCount,
    required this.slides,
    required this.createdAt,
    this.content,
    this.thumbnailColor,
  });
}

// ==================== MESSAGE MODEL ====================
class MessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// ==================== COURSE MODEL ====================
class CourseModel {
  final String id;
  final String name;
  final String subject;
  final String instructor;
  final double progress;
  final int totalLectures;
  final String colorHex;
  final String icon;

  CourseModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.instructor,
    required this.progress,
    required this.totalLectures,
    required this.colorHex,
    required this.icon,
  });
}

// ==================== UPLOAD MODEL ====================
class UploadModel {
  final String id;
  final String fileName;
  final String fileType;
  final String fileSize;
  final DateTime uploadedAt;
  final String status; // pending | processing | ready

  UploadModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    required this.status,
  });
}
