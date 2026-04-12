import 'package:flutter/material.dart';

class SlidesScreen extends StatelessWidget {
  const SlidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slides")),
      body: const Center(child: Text("Slides Screen")),
    );
  }
}