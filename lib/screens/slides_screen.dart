import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class SlidesScreen extends StatelessWidget {
  const SlidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Slides')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 6,
        itemBuilder: (context, index) {
          // Slide animation when page loads
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: ModalRoute.of(context)!.animation!, curve: Curves.easeOutQuad),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => SlideDetailScreen(slideIndex: index),
                      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                onLongPress: () {
                  // Scale animation on long press
                  showDialog(
                    context: context,
                    builder: (_) => ScaleTransition(
                      scale: CurvedAnimation(parent: ModalRoute.of(context)!.animation!, curve: Curves.elasticOut),
                      child: AlertDialog(
                        title: Text('Slide ${index + 1}'),
                        content: const Text('Options: Edit, Delete, Share'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                        ],
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'slide_$index',
                  child: CustomCard(
                    child: ListTile(
                      leading: Icon(Icons.slideshow, color: Colors.red.shade700),
                      title: Text('Lecture ${index + 1}'),
                      subtitle: Text('Created on day ${index + 1}'),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SlideDetailScreen extends StatelessWidget {
  final int slideIndex;
  const SlideDetailScreen({super.key, required this.slideIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slide ${slideIndex + 1} Details')),
      body: Center(
        child: Hero(
          tag: 'slide_$slideIndex',
          child: CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.description, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Content of slide ${slideIndex + 1}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}