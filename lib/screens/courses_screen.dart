import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
// Uncomment for Firestore option
// import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = true;
  String _searchQuery = "";
  String _selectedCategory = "All";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // MARK: - Load from Local JSON
  Future<void> _loadCourses() async {
    try {
      final String response = await rootBundle.loadString('assets/courses.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _allCourses = (data['courses'] as List)
            .map((course) => Course.fromJson(course))
            .toList();
        _filteredCourses = _allCourses;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading courses: $e");
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar("Failed to load courses");
    }
  }

  // MARK: - Load from Firestore (Alternative)
  /*
  Future<void> _loadCoursesFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .get();

      setState(() {
        _allCourses = querySnapshot.docs
            .map((doc) => Course.fromFirestore(doc))
            .toList();
        _filteredCourses = _allCourses;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading courses from Firestore: $e");
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar("Failed to load courses");
    }
  }
  */

  void _filterCourses() {
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        // Filter by search query
        final matchesSearch = _searchQuery.isEmpty ||
            course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course.instructor.toLowerCase().contains(_searchQuery.toLowerCase());

        // Filter by category
        final matchesCategory = _selectedCategory == "All" ||
            course.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterCourses();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<String> get _categories {
    final categories = _allCourses.map((c) => c.category).toSet().toList();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Courses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search courses...',
                      prefixIcon: const Icon(Icons.search, color: Colors.red),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Filter
          if (!_isLoading && _allCourses.isNotEmpty)
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _filterCourses();
                        });
                      },
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.red.shade100,
                      checkmarkColor: Colors.red,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.red : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? Colors.red : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Courses Grid
          Expanded(
            child: _isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading courses...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
                : _filteredCourses.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No courses found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your search',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                final course = _filteredCourses[index];
                return CourseCard(course: course);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Course Card Widget
class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'design_services':
        return Icons.design_services;
      case 'code':
        return Icons.code;
      case 'psychology':
        return Icons.psychology;
      case 'cloud':
        return Icons.cloud;
      case 'storage':
        return Icons.storage;
      default:
        return Icons.school;
    }
  }

  Color _getProgressColor(int progress) {
    if (progress >= 70) return Colors.green;
    if (progress >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to course details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${course.title}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header with Icon
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red.shade400,
                    Colors.red.shade700,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  _getIconData(course.icon),
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),

            // Course Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Instructor
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            course.instructor,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              '${course.progress}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _getProgressColor(course.progress),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: course.progress / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(course.progress),
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 10,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.completedLessons}/${course.totalLessons} lessons',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Course Model
class Course {
  final String id;
  final String title;
  final String description;
  final int progress;
  final String icon;
  final String category;
  final String instructor;
  final int totalLessons;
  final int completedLessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.icon,
    required this.category,
    required this.instructor,
    required this.totalLessons,
    required this.completedLessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      progress: json['progress'],
      icon: json['icon'],
      category: json['category'],
      instructor: json['instructor'],
      totalLessons: json['totalLessons'],
      completedLessons: json['completedLessons'],
    );
  }

// For Firestore - Comment this out if not using Firestore
// factory Course.fromFirestore(DocumentSnapshot doc) {
//   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//   return Course(
//     id: doc.id,
//     title: data['title'],
//     description: data['description'],
//     progress: data['progress'],
//     icon: data['icon'],
//     category: data['category'],
//     instructor: data['instructor'],
//     totalLessons: data['totalLessons'],
//     completedLessons: data['completedLessons'],
//   );
// }
}