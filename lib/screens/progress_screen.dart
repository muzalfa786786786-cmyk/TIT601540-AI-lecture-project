// lib/screens/progress_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Course progress data
  final List<CourseProgress> _courses = [
    CourseProgress(
      name: 'Flutter Development',
      progress: 0.75,
      color: Colors.blue,
      icon: Icons.flutter_dash,
      completedLessons: 18,
      totalLessons: 24,
    ),
    CourseProgress(
      name: 'UI/UX Design',
      progress: 0.45,
      color: Colors.orange,
      icon: Icons.design_services,
      completedLessons: 9,
      totalLessons: 20,
    ),
    CourseProgress(
      name: 'Python Programming',
      progress: 0.90,
      color: Colors.green,
      icon: Icons.code,
      completedLessons: 29,
      totalLessons: 32,
    ),
    CourseProgress(
      name: 'Machine Learning',
      progress: 0.30,
      color: Colors.purple,
      icon: Icons.psychology,
      completedLessons: 12,
      totalLessons: 40,
    ),
    CourseProgress(
      name: 'Cloud Computing',
      progress: 0.60,
      color: Colors.cyan,
      icon: Icons.cloud,
      completedLessons: 17,
      totalLessons: 28,
    ),
    CourseProgress(
      name: 'Database Management',
      progress: 0.20,
      color: Colors.red,
      icon: Icons.storage,
      completedLessons: 7,
      totalLessons: 35,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final overallProgress = _calculateOverallProgress();
    final totalHours = _calculateTotalHours();
    final totalSlides = 48;
    final totalQASessions = 36;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Progress',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Progress Card
            _buildOverallProgressCard(overallProgress),
            const SizedBox(height: 20),

            // Statistics Row
            _buildStatisticsRow(totalHours, totalSlides, totalQASessions),
            const SizedBox(height: 24),

            // Course Progress Section
            const Text(
              'Course Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Course Progress List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildCourseProgressCard(_courses[index]);
              },
            ),

            const SizedBox(height: 24),

            // Achievements Section
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildAchievementsRow(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  double _calculateOverallProgress() {
    if (_courses.isEmpty) return 0.0;
    double total = 0;
    for (var course in _courses) {
      total += course.progress;
    }
    return total / _courses.length;
  }

  int _calculateTotalHours() {
    // Mock calculation: 1.5 hours per course
    return (_courses.length * 1.5).toInt();
  }

  Widget _buildOverallProgressCard(double progress) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text(
              'Overall Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Complete',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep going! You\'re doing great! 🎉',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(int totalHours, int totalSlides, int totalQASessions) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Hours',
            '$totalHours+',
            Icons.timer_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Slides',
            '$totalSlides',
            Icons.slideshow_rounded,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Q&A Sessions',
            '$totalQASessions',
            Icons.chat_rounded,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseProgressCard(CourseProgress course) {
    final percentage = (course.progress * 100).toInt();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: course.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(course.icon, size: 24, color: course.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${course.completedLessons}/${course.totalLessons} lessons completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: course.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: course.progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(course.color),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsRow() {
    final achievements = [
      ('First Course', 'Completed first course', Icons.emoji_events, Colors.amber),
      ('10 Hours', '10 hours of learning', Icons.timer, Colors.blue),
      ('Quiz Master', 'Completed 5 quizzes', Icons.quiz, Colors.green),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final a = achievements[index];
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: a.$4.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(a.$3, size: 30, color: a.$4),
                ),
                const SizedBox(height: 8),
                Text(
                  a.$1,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  a.$2,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Course Progress Model
class CourseProgress {
  final String name;
  final double progress;
  final Color color;
  final IconData icon;
  final int completedLessons;
  final int totalLessons;

  CourseProgress({
    required this.name,
    required this.progress,
    required this.color,
    required this.icon,
    required this.completedLessons,
    required this.totalLessons,
  });
}