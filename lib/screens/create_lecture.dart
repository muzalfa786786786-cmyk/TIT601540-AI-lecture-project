import 'package:flutter/material.dart';

class CreateLecture extends StatelessWidget {
  const CreateLecture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Lecture")),
      body: const Center(child: Text("Create Lecture")),
    );
  }
}