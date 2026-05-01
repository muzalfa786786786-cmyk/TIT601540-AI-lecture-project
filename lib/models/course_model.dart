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
