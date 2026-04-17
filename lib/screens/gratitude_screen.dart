import 'package:flutter/material.dart';

class GratitudeScreen extends StatelessWidget {
  const GratitudeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Same Hero tag - smooth transition from about screen
            Hero(
              tag: 'about_hero',
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red.shade200,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.red.shade400, blurRadius: 20),
                  ],
                ),
                child: const Icon(Icons.favorite, size: 100, color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Thank You!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'We appreciate your support. Keep learning with AI Lecturer!',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
              child: const Text('Back to About'),
            ),
          ],
        ),
      ),
    );
  }
}