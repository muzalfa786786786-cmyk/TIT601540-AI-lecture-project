// lib/screens/avatar_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  AvatarType? _selectedAvatar;
  String _selectedVoice = "en-US-Neural2-F";
  bool _isStartingPresentation = false;

  final List<VoiceOption> _voiceOptions = [
    VoiceOption(
      id: "en-US-Neural2-F",
      name: "Sarah - Female (US English)",
      gender: "Female",
      accent: "American",
      language: "English (US)",
    ),
    VoiceOption(
      id: "en-US-Neural2-M",
      name: "James - Male (US English)",
      gender: "Male",
      accent: "American",
      language: "English (US)",
    ),
    VoiceOption(
      id: "en-GB-Neural2-F",
      name: "Emma - Female (UK English)",
      gender: "Female",
      accent: "British",
      language: "English (UK)",
    ),
    VoiceOption(
      id: "en-GB-Neural2-M",
      name: "Oliver - Male (UK English)",
      gender: "Male",
      accent: "British",
      language: "English (UK)",
    ),
    VoiceOption(
      id: "en-AU-Neural2-F",
      name: "Olivia - Female (Australian)",
      gender: "Female",
      accent: "Australian",
      language: "English (AU)",
    ),
    VoiceOption(
      id: "en-IN-Neural2-F",
      name: "Priya - Female (Indian)",
      gender: "Female",
      accent: "Indian",
      language: "English (IN)",
    ),
  ];

  Future<void> _startPresentation() async {
    if (_selectedAvatar == null) {
      _showSnackBar('Please select an AI teacher first', Colors.orange);
      return;
    }

    setState(() {
      _isStartingPresentation = true;
    });

    // Simulate AI preparation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isStartingPresentation = false;
      });

      final selectedVoice = _voiceOptions.firstWhere((v) => v.id == _selectedVoice);
      final teacherName = _selectedAvatar == AvatarType.male ? "Abdul Rehman" : "Muzalfa Bibi";
      final title = _selectedAvatar == AvatarType.male ? "Mr." : "Ms.";

      _showSnackBar(
        'Starting presentation with $title $teacherName using ${selectedVoice.name} voice',
        Colors.green,
      );

      _showPresentationDialog();
    }
  }

  void _showPresentationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_circle_filled,
                  size: 80,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Presentation Ready!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your AI teacher is ready to present',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to presentation screen
                          _showSnackBar('Starting presentation mode...', Colors.green);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Start Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Select AI Teacher',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Your AI Teacher',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a professional AI avatar to deliver your presentation',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: _buildAvatarCard(
                          type: AvatarType.male,
                          name: 'Abdul Rehman',
                          title: 'Senior AI Instructor',
                          specialization: 'Computer Science & AI',
                          experience: '12+ years',
                          imageUrl: 'assets/images/male-teacher.jpeg',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildAvatarCard(
                          type: AvatarType.female,
                          name: 'Muzalfa Bibi',
                          title: 'Lead AI Educator',
                          specialization: 'Data Science & Analytics',
                          experience: '5+ years',
                          imageUrl: 'assets/images/female-teacher.png',
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Voice Selection Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppTheme.primary, AppTheme.primaryLight],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.record_voice_over,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Voice Selection',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Choose the voice for your AI teacher',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedVoice,
                              icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                              iconSize: 32,
                              isExpanded: true,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                              items: _voiceOptions.map((VoiceOption voice) {
                                return DropdownMenuItem<String>(
                                  value: voice.id,
                                  child: Row(
                                    children: [
                                      Icon(
                                        voice.gender == "Female"
                                            ? Icons.female
                                            : Icons.male,
                                        size: 18,
                                        color: voice.gender == "Female"
                                            ? Colors.pink
                                            : Colors.blue,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              voice.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '${voice.accent} • ${voice.language}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedVoice = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.05),
                          Colors.orange.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your selected AI teacher will deliver the presentation with natural expressions and gestures. The voice will match the selected avatar\'s personality.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryDark,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Start Presentation Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _isStartingPresentation ? null : _startPresentation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                child: _isStartingPresentation
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Preparing Presentation...'),
                  ],
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_filled, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Start Presentation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCard({
    required AvatarType type,
    required String name,
    required String title,
    required String specialization,
    required String experience,
    required String imageUrl,
    required Color color,
  }) {
    final isSelected = _selectedAvatar == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatar = type;
        });
        _showSnackBar('Selected $name as your AI teacher', Colors.green);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          elevation: isSelected ? 8 : 2,
          shadowColor: isSelected ? AppTheme.primary.withOpacity(0.3) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isSelected
                ? const BorderSide(color: AppTheme.primary, width: 3)
                : BorderSide.none,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  imageUrl,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            specialization,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.work,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Experience: $experience',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedAvatar = type;
                        });
                        _showSnackBar('Selected $name as your AI teacher', Colors.green);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppTheme.primary : Colors.grey.shade200,
                        foregroundColor: isSelected ? Colors.white : Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: Text(
                        isSelected ? 'Selected' : 'Select',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AvatarType {
  male,
  female,
}

class VoiceOption {
  final String id;
  final String name;
  final String gender;
  final String accent;
  final String language;

  VoiceOption({
    required this.id,
    required this.name,
    required this.gender,
    required this.accent,
    required this.language,
  });
}