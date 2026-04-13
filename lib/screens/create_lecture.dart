import 'package:flutter/material.dart';
class CreateLecture extends StatefulWidget {
  const CreateLecture({super.key});
  @override
  State<CreateLecture> createState() => _CreateLectureState();
}
class _CreateLectureState extends State<CreateLecture> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedLanguage = 'English';
  bool _isGenerating = false;
  bool _showSuccess = false;

  late AnimationController _successController;

  final List<String> _languages = ['English', 'Urdu', 'Spanish', 'French'];

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void _generateSlides() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isGenerating = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _showSuccess = true;
        });
        _successController.forward();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _successController.reverse();
            setState(() => _showSuccess = false);
          }
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Lecture'), elevation: 6),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red.shade50, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero image with zoom on tap
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FullScreenHeroImage()));
                  },
                  child: Hero(
                    tag: 'ai_hero',
                    child: Image.asset(
                      'lib/assets/image.png',
                      height: 120,
                      errorBuilder: (_, __, ___) => Container(height: 120, color: Colors.red.shade100, child: const Icon(Icons.image, size: 60)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Animated container for focus effect
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _topicController.text.isNotEmpty ? [BoxShadow(color: Colors.red.shade200, blurRadius: 8)] : null,
                  ),
                  child: TextFormField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      labelText: 'Lecture Topic',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: 'Language',
                      prefixIcon: const Icon(Icons.language),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _languages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                    onChanged: (v) => setState(() => _selectedLanguage = v!),
                  ),
                ),
                const SizedBox(height: 32),
                // Scale transition success message
                ScaleTransition(
                  scale: _successController,
                  child: FadeTransition(
                    opacity: _successController,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('Slides generated!')],
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateSlides,
                  icon: _isGenerating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : const Icon(Icons.auto_awesome),
                  label: Text(_isGenerating ? 'Generating...' : 'Generate Slides'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenHeroImage extends StatelessWidget {
  const FullScreenHeroImage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: 'ai_hero',
            child: Image.asset('lib/assets/image.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}