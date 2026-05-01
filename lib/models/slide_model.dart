// lib/models/slide_model.dart

import 'package:flutter/material.dart';

class SlideModel {
  String id;
  String title;
  String content;
  String subject;
  int slideCount;
  DateTime savedDate;
  Color thumbnailColor;

  SlideModel({
    required this.id,
    required this.title,
    required this.content,
    required this.subject,
    required this.slideCount,
    required this.savedDate,
    required this.thumbnailColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'subject': subject,
      'slideCount': slideCount,
      'savedDate': savedDate.toIso8601String(),
      'thumbnailColor': thumbnailColor.value,
    };
  }

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      subject: json['subject'],
      slideCount: json['slideCount'],
      savedDate: DateTime.parse(json['savedDate']),
      thumbnailColor: Color(json['thumbnailColor']),
    );
  }

  // Copy with method for updates
  SlideModel copyWith({
    String? id,
    String? title,
    String? content,
    String? subject,
    int? slideCount,
    DateTime? savedDate,
    Color? thumbnailColor,
  }) {
    return SlideModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      subject: subject ?? this.subject,
      slideCount: slideCount ?? this.slideCount,
      savedDate: savedDate ?? this.savedDate,
      thumbnailColor: thumbnailColor ?? this.thumbnailColor,
    );
  }
}