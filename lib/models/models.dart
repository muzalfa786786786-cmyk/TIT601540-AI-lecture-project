// lib/models/models.dart

import 'package:flutter/material.dart';

// ==================== USER MODEL ====================
class UserModel {
  final String id;  // ✅ Changed from uid to id (Firebase consistency)
  final String name;
  final String email;
  final String role; // student | teacher | admin
  final String? photoURL;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoURL,
    this.createdAt,
  });

  // Firestore constructor
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'student',
      photoURL: data['photoURL'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : null,
    );
  }

  // JSON constructor
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      photoURL: json['photoURL'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'role': role,
    'photoURL': photoURL,
    'createdAt': createdAt,
  };

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'role': role,
    'photoURL': photoURL,
    'createdAt': createdAt?.toIso8601String(),
  };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? photoURL,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
    );
  }
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
  String? content;
  Color? thumbnailColor;

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

  // Firestore constructor
  factory SlideModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SlideModel(
      id: id,
      title: data['title'] ?? '',
      topic: data['topic'] ?? '',
      subject: data['subject'] ?? '',
      level: data['level'] ?? '',
      slideCount: data['slideCount'] ?? 0,
      slides: List<String>.from(data['slides'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      content: data['content'],
      thumbnailColor: data['thumbnailColor'] != null
          ? Color(data['thumbnailColor'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'topic': topic,
    'subject': subject,
    'level': level,
    'slideCount': slideCount,
    'slides': slides,
    'createdAt': createdAt,
    'content': content,
    'thumbnailColor': thumbnailColor?.value,
  };

  SlideModel copyWith({
    String? id,
    String? title,
    String? topic,
    String? subject,
    String? level,
    int? slideCount,
    List<String>? slides,
    DateTime? createdAt,
    String? content,
    Color? thumbnailColor,
  }) {
    return SlideModel(
      id: id ?? this.id,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      subject: subject ?? this.subject,
      level: level ?? this.level,
      slideCount: slideCount ?? this.slideCount,
      slides: slides ?? this.slides,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      thumbnailColor: thumbnailColor ?? this.thumbnailColor,
    );
  }
}

// lib/models/models.dart mein ye add karo (already hai check karo)

// ==================== CHAT MESSAGE MODEL ====================
class ChatMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
// ==================== COURSE MODEL ====================
class CourseModel {
  final String id;
  final String name;
  final String subject;
  final String instructor;
  final double progress;
  final int totalLectures;
  final int completedLectures;  // ✅ Added
  final String colorHex;
  final String icon;
  final String? description;  // ✅ Added

  CourseModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.instructor,
    required this.progress,
    required this.totalLectures,
    this.completedLectures = 0,
    required this.colorHex,
    required this.icon,
    this.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? '',
      subject: json['subject'] ?? '',
      instructor: json['instructor'] ?? '',
      progress: (json['progress'] ?? 0).toDouble(),
      totalLectures: json['totalLectures'] ?? 0,
      completedLectures: json['completedLectures'] ?? 0,
      colorHex: json['colorHex'] ?? '#DC2626',
      icon: json['icon'] ?? '📚',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'instructor': instructor,
    'progress': progress,
    'totalLectures': totalLectures,
    'completedLectures': completedLectures,
    'colorHex': colorHex,
    'icon': icon,
    'description': description,
  };

  CourseModel copyWith({
    String? id,
    String? name,
    String? subject,
    String? instructor,
    double? progress,
    int? totalLectures,
    int? completedLectures,
    String? colorHex,
    String? icon,
    String? description,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
      totalLectures: totalLectures ?? this.totalLectures,
      completedLectures: completedLectures ?? this.completedLectures,
      colorHex: colorHex ?? this.colorHex,
      icon: icon ?? this.icon,
      description: description ?? this.description,
    );
  }
}

// ==================== UPLOAD MODEL ====================
class UploadModel {
  final String id;
  final String fileName;
  final String fileType;
  final String fileSize;
  final DateTime uploadedAt;
  final String status; // pending | processing | ready
  final String? fileURL;  // ✅ Added for Firebase Storage
  final String? userId;   // ✅ Added for user reference

  UploadModel({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    required this.status,
    this.fileURL,
    this.userId,
  });

  factory UploadModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UploadModel(
      id: id,
      fileName: data['fileName'] ?? '',
      fileType: data['fileType'] ?? '',
      fileSize: data['fileSize'] ?? '',
      uploadedAt: data['uploadedAt'] != null
          ? (data['uploadedAt'] as dynamic).toDate()
          : DateTime.now(),
      status: data['status'] ?? 'pending',
      fileURL: data['fileURL'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'fileName': fileName,
    'fileType': fileType,
    'fileSize': fileSize,
    'uploadedAt': uploadedAt,
    'status': status,
    'fileURL': fileURL,
    'userId': userId,
  };
}