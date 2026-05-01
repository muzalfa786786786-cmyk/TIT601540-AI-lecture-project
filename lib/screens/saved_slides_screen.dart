import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SavedSlidesScreen extends StatefulWidget {
  const SavedSlidesScreen({super.key});

  @override
  State<SavedSlidesScreen> createState() => _SavedSlidesScreenState();
}

class _SavedSlidesScreenState extends State<SavedSlidesScreen> {
  List<SavedSlide> _savedSlides = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedSlides();
  }

  // Load slides from SharedPreferences
  Future<void> _loadSavedSlides() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? slidesJson = prefs.getString('saved_slides');

      if (slidesJson != null) {
        final List<dynamic> decodedList = json.decode(slidesJson);
        setState(() {
          _savedSlides = decodedList.map((item) => SavedSlide.fromJson(item)).toList();
          // Sort by saved date (newest first)
          _savedSlides.sort((a, b) => b.savedDate.compareTo(a.savedDate));
        });
      } else {
        // Add sample slides for demonstration
        _addSampleSlides();
      }
    } catch (e) {
      print("Error loading slides: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load slides'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Add sample slides for first-time users
  Future<void> _addSampleSlides() async {
    final sampleSlides = [
      SavedSlide(
        id: '1',
        title: 'Introduction to Flutter',
        description: 'Learn the basics of Flutter framework and Dart programming language.',
        slideCount: 25,
        subject: 'Mobile Development',
        savedDate: DateTime.now(),
        thumbnailColor: Colors.red,
      ),
      SavedSlide(
        id: '2',
        title: 'State Management',
        description: 'Understanding Provider, BLoC, and Riverpod patterns.',
        slideCount: 18,
        subject: 'Flutter Advanced',
        savedDate: DateTime.now().subtract(const Duration(days: 1)),
        thumbnailColor: Colors.orange,
      ),
      SavedSlide(
        id: '3',
        title: 'Firebase Integration',
        description: 'Authentication, Firestore, and Cloud Functions.',
        slideCount: 32,
        subject: 'Backend Development',
        savedDate: DateTime.now().subtract(const Duration(days: 2)),
        thumbnailColor: Colors.blue,
      ),
      SavedSlide(
        id: '4',
        title: 'UI/UX Design Principles',
        description: 'User-centered design, prototyping, and usability testing.',
        slideCount: 20,
        subject: 'Design',
        savedDate: DateTime.now().subtract(const Duration(days: 3)),
        thumbnailColor: Colors.green,
      ),
    ];

    setState(() {
      _savedSlides = sampleSlides;
    });
    await _saveToPreferences();
  }

  // Save slides to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> slidesMap = _savedSlides.map((slide) => slide.toJson()).toList();
      final String slidesJson = json.encode(slidesMap);
      await prefs.setString('saved_slides', slidesJson);
    } catch (e) {
      print("Error saving slides: $e");
    }
  }

  // Add a new slide (can be called from other screens)
  Future<void> addSlide({
    required String title,
    required String description,
    required int slideCount,
    required String subject,
    Color thumbnailColor = Colors.red,
  }) async {
    final newSlide = SavedSlide(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      slideCount: slideCount,
      subject: subject,
      savedDate: DateTime.now(),
      thumbnailColor: thumbnailColor,
    );

    setState(() {
      _savedSlides.insert(0, newSlide); // Add at the beginning
    });
    await _saveToPreferences();
  }

  // Delete a single slide
  Future<void> _deleteSlide(int index) async {
    final slide = _savedSlides[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Slide'),
          content: Text(
            'Are you sure you want to delete "${slide.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _savedSlides.removeAt(index);
                });
                await _saveToPreferences();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"${slide.title}" deleted'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Delete all slides
  Future<void> _deleteAllSlides() async {
    if (_savedSlides.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Slides'),
          content: const Text('Are you sure you want to delete all saved slides?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _savedSlides.clear();
                });
                await _saveToPreferences();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All slides deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Saved Slides',
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
        actions: [
          if (_savedSlides.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: _deleteAllSlides,
              tooltip: 'Delete all slides',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            SizedBox(height: 16),
            Text(
              'Loading saved slides...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : _savedSlides.isEmpty
          ? _buildEmptyState()
          : _buildSlidesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmarks_outlined,
            size: 100,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved slides yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Slides you save will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add slide screen or show dialog
              _showAddSlideDialog();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Sample Slide'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _savedSlides.length,
      itemBuilder: (context, index) {
        final slide = _savedSlides[index];
        return _buildSlideCard(slide, index);
      },
    );
  }

  Widget _buildSlideCard(SavedSlide slide, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Top section with gradient bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    slide.thumbnailColor,
                    slide.thumbnailColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail/Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          slide.thumbnailColor,
                          slide.thumbnailColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.slideshow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Slide details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slide.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Metadata row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: slide.thumbnailColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.subject,
                                    size: 12,
                                    color: slide.thumbnailColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    slide.subject,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: slide.thumbnailColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.slideshow,
                                    size: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${slide.slideCount} slides',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(slide.savedDate),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Delete button
                  IconButton(
                    onPressed: () => _deleteSlide(index),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red.shade400,
                    iconSize: 22,
                    tooltip: 'Delete slide',
                  ),
                ],
              ),
            ),

            // Bottom action buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showSlideDetails(slide);
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${slide.title}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Open'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlideDetails(SavedSlide slide) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(slide.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject: ${slide.subject}'),
              const SizedBox(height: 8),
              Text('Slide Count: ${slide.slideCount}'),
              const SizedBox(height: 8),
              Text('Saved: ${DateFormat('MMM d, yyyy - hh:mm a').format(slide.savedDate)}'),
              const SizedBox(height: 8),
              const Divider(),
              Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(slide.description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSlideDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final subjectController = TextEditingController();
    Color selectedColor = Colors.red;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Slide'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Color Theme:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildColorOption(Colors.red, selectedColor == Colors.red, () {
                          setState(() => selectedColor = Colors.red);
                        }),
                        _buildColorOption(Colors.orange, selectedColor == Colors.orange, () {
                          setState(() => selectedColor = Colors.orange);
                        }),
                        _buildColorOption(Colors.blue, selectedColor == Colors.blue, () {
                          setState(() => selectedColor = Colors.blue);
                        }),
                        _buildColorOption(Colors.green, selectedColor == Colors.green, () {
                          setState(() => selectedColor = Colors.green);
                        }),
                        _buildColorOption(Colors.purple, selectedColor == Colors.purple, () {
                          setState(() => selectedColor = Colors.purple);
                        }),
                        _buildColorOption(Colors.teal, selectedColor == Colors.teal, () {
                          setState(() => selectedColor = Colors.teal);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      await addSlide(
                        title: titleController.text,
                        description: descController.text.isEmpty ? 'No description' : descController.text,
                        slideCount: 10,
                        subject: subjectController.text.isEmpty ? 'General' : subjectController.text,
                        thumbnailColor: selectedColor,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Slide added successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildColorOption(Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.red, width: 3)
              : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
            ),
          ]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}

// Model for Saved Slide
class SavedSlide {
  final String id;
  final String title;
  final String description;
  final int slideCount;
  final String subject;
  final DateTime savedDate;
  final Color thumbnailColor;

  SavedSlide({
    required this.id,
    required this.title,
    required this.description,
    required this.slideCount,
    required this.subject,
    required this.savedDate,
    required this.thumbnailColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'slideCount': slideCount,
      'subject': subject,
      'savedDate': savedDate.toIso8601String(),
      'thumbnailColor': thumbnailColor.value,
    };
  }

  factory SavedSlide.fromJson(Map<String, dynamic> json) {
    return SavedSlide(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      slideCount: json['slideCount'],
      subject: json['subject'],
      savedDate: DateTime.parse(json['savedDate']),
      thumbnailColor: Color(json['thumbnailColor']),
    );
  }
}