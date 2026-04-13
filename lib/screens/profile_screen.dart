import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  late AnimationController _rotateController;
  bool _isRotated = false;
  int _lectureCount = 12;
  int _slidesCount = 48;

  late AnimationController _lectureCounterController;
  late Animation<int> _lectureAnimation;
  late AnimationController _slidesCounterController;
  late Animation<int> _slidesAnimation;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    // Lecture counter animation
    _lectureCounterController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _lectureAnimation = IntTween(begin: 0, end: _lectureCount).animate(
      CurvedAnimation(parent: _lectureCounterController, curve: Curves.easeOut),
    );
    // Slides counter animation
    _slidesCounterController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _slidesAnimation = IntTween(begin: 0, end: _slidesCount).animate(
      CurvedAnimation(parent: _slidesCounterController, curve: Curves.easeOut),
    );
    _lectureCounterController.forward();
    _slidesCounterController.forward();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _lectureCounterController.dispose();
    _slidesCounterController.dispose();
    super.dispose();
  }

  void _rotateAvatar() {
    if (_isRotated) {
      _rotateController.reverse();
    } else {
      _rotateController.forward();
    }
    setState(() => _isRotated = !_isRotated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: CustomCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rotating profile image (instead of icon)
                GestureDetector(
                  onTap: _rotateAvatar,
                  child: RotationTransition(
                    turns: _rotateController,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.red.shade300, blurRadius: 12, spreadRadius: 2),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'lib/assets/image.png', // Make sure this image exists
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.red.shade100,
                              child: const Icon(Icons.person, size: 70, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Muzalfa Bibi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('muzalfa@example.com', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                // Animated counters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard('Lectures', _lectureAnimation),
                    _buildStatCard('Slides', _slidesAnimation),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile feature coming soon')),
                    );
                  },
                  icon: Icons.edit,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, Animation<int> animation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.red.shade100, blurRadius: 8)],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Text(
                animation.value.toString(),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}