import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero widget with Icon (no image needed)
            Hero(
              tag: 'about_hero',
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.red.shade300, blurRadius: 12),
                  ],
                ),
                child: const Icon(Icons.school, size: 80, color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AI Lecturer App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'This app helps teachers create AI-powered lectures and presentations.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/gratitude');
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Go to Gratitude Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}