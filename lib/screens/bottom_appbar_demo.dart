import 'package:flutter/material.dart';
class BottomAppBarDemo extends StatelessWidget {
  const BottomAppBarDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomAppBar Demo'),
        backgroundColor: Colors.red.shade700,
      ),
      body: const Center(
        child: Text(
          'Floating Action Button embedded in BottomAppBar\nwith CircularNotchedRectangle',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAB Pressed!')),
          );
        },
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // notch for FAB
        color: Colors.red.shade50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
              color: Colors.red.shade700,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: Colors.red.shade700,
            ),
            const SizedBox(width: 40), // space for FAB
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
              color: Colors.red.shade700,
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
              color: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }
}