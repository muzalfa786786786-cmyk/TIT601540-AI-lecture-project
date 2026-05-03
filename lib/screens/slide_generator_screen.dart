// lib/screens/slide_generator_screen.dart
// AI Slide Generator with form, progress, and preview

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/slides_provider.dart';
import '../theme/app_theme.dart';

class SlideGeneratorScreen extends StatefulWidget {
  const SlideGeneratorScreen({super.key});

  @override
  State<SlideGeneratorScreen> createState() => _SlideGeneratorScreenState();
}

class _SlideGeneratorScreenState extends State<SlideGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicCtrl = TextEditingController();
  String _subject = 'Mathematics';
  String _level = 'Undergraduate';
  int _slideCount = 10;
  bool _includeImages = true;
  bool _includeQuiz = false;

  final _subjects = ['Mathematics', 'Physics', 'Chemistry',
    'Computer Science', 'Biology', 'History', 'English'];
  final _levels = ['School', 'Undergraduate', 'Postgraduate', 'Professional'];

  @override
  void dispose() {
    _topicCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SlidesProvider>().generateSlides(
      topic: _topicCtrl.text.trim(),
      subject: _subject,
      level: _level,
      count: _slideCount,
    );
  }

  void _showSlideDetails(String title, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.slideshow, color: AppTheme.primary, size: 24),
              const SizedBox(width: 8),
              Text('Slide ${index + 1}'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.slideshow, size: 30, color: AppTheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This slide covers key concepts and important points about the topic.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening Slide ${index + 1}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Open Slide'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI Slide Generator'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/saved-slides');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // ✅ Force scroll
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Generate Lecture Slides',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                          Text(
                            'AI creates professional slides instantly',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Topic Input
              const Text('Lecture Topic',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _topicCtrl,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  hintText: 'e.g. Introduction to Calculus, Newton\'s Laws...',
                  prefixIcon: const Icon(Icons.title_rounded, color: AppTheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primary),
                  ),
                ),
                maxLines: 2,
                validator: (v) => v == null || v.isEmpty ? 'Topic is required' : null,
              ),

              const SizedBox(height: 18),

              // Subject & Level Row
              Row(
                children: [
                  Expanded(child: _buildDropdown('Subject', _subject,
                      _subjects, (v) => setState(() => _subject = v!))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDropdown('Level', _level,
                      _levels, (v) => setState(() => _level = v!))),
                ],
              ),

              const SizedBox(height: 18),

              // Slide Count Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Number of Slides',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryLight),
                    ),
                    child: Text('$_slideCount slides',
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.primary,
                  inactiveTrackColor: AppTheme.divider,
                  thumbColor: AppTheme.primary,
                  overlayColor: AppTheme.primary.withOpacity(0.1),
                ),
                child: Slider(
                  value: _slideCount.toDouble(),
                  min: 5, max: 30, divisions: 25,
                  onChanged: (v) => setState(() => _slideCount = v.toInt()),
                ),
              ),

              const SizedBox(height: 8),

              // Options
              _buildToggle('Include Visual Images',
                  Icons.image_outlined, _includeImages,
                      (v) => setState(() => _includeImages = v)),
              const SizedBox(height: 8),
              _buildToggle('Add Quiz Questions',
                  Icons.quiz_outlined, _includeQuiz,
                      (v) => setState(() => _includeQuiz = v)),

              const SizedBox(height: 28),

              // Generate / Progress
              Consumer<SlidesProvider>(
                builder: (_, provider, __) {
                  if (provider.isGenerating) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_getProgressMsg(provider.progress),
                                style: const TextStyle(
                                    color: AppTheme.primary, fontSize: 13)),
                            Text('${(provider.progress * 100).toInt()}%',
                                style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: provider.progress,
                            minHeight: 8,
                            backgroundColor: AppTheme.divider,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ),
                        ),
                      ],
                    );
                  }
                  return ElevatedButton(
                    onPressed: _generate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome),
                        const SizedBox(width: 8),
                        Text(provider.hasSlides
                            ? 'Regenerate Slides'
                            : 'Generate Slides with AI'),
                      ],
                    ),
                  );
                },
              ),

              // Slides Preview
              Consumer<SlidesProvider>(
                builder: (_, provider, __) {
                  if (!provider.hasSlides) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Generated — ${provider.generatedSlides.length} Slides',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All slides saved to library!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text('Save All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: provider.generatedSlides.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (_, i) {
                            final slideTitle = provider.generatedSlides[i];
                            return GestureDetector(
                              onTap: () => _showSlideDetails(slideTitle, i),
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.primary.withOpacity(0.1),
                                      AppTheme.primary.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppTheme.primaryLight.withOpacity(0.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Slide ${i + 1}',
                                            style: const TextStyle(
                                              color: AppTheme.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.slideshow_rounded,
                                            color: AppTheme.primary, size: 18),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: Text(
                                        slideTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [AppTheme.primary, AppTheme.primaryLight],
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Starting presentation mode...'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle_filled),
                                  SizedBox(width: 8),
                                  Text('Present Now'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Exporting slides...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: const Text('Export'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _getProgressMsg(double p) {
    if (p < 0.3) return 'Analyzing topic...';
    if (p < 0.6) return 'Generating content...';
    if (p < 0.9) return 'Adding visuals...';
    return 'Finalizing slides...';
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              style: const TextStyle(color: AppTheme.textDark, fontSize: 13),
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, IconData icon, bool value,
      ValueChanged<bool> onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Switch(value: value, onChanged: onChange, activeColor: AppTheme.primary),
        ],
      ),
    );
  }
}