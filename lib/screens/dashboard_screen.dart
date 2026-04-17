import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import 'bottom_nav_demo.dart';
import 'bottom_appbar_demo.dart';
import 'tab_drawer_demo.dart';
import 'card_list_grid_sliver_demo.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  bool _isFabExpanded = false;
  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.add_circle_outline, 'title': 'Create Lecture', 'route': '/create'},
    {'icon': Icons.slideshow, 'title': 'My Slides', 'route': '/slides'},
    {'icon': Icons.chat_bubble_outline, 'title': 'AI Chat', 'route': '/chat'},
    {'icon': Icons.info, 'title': 'About (Hero Animation)', 'route': '/about'},
    {'icon': Icons.tab, 'title': 'Bottom Navigation Bar', 'screen': const BottomNavDemo()},
    {'icon': Icons.apps, 'title': 'BottomAppBar with FAB', 'screen': const BottomAppBarDemo()},
    {'icon': Icons.person_outline, 'title': 'Profile & Posts', 'route': '/profile_posts'},
    {'icon': Icons.tab, 'title': 'TabBar & Drawer Demo', 'screen': const TabDrawerDemo()},
    {'icon': Icons.grid_view, 'title': 'Cards, Lists, Grids & Slivers', 'screen': const CardListGridSliverDemo()},
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    if (_isFabExpanded) {
      _fabController.reverse();
    } else {
      _fabController.forward();
    }
    setState(() => _isFabExpanded = !_isFabExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
                ),
              ),
              child: FadeTransition(
                opacity: ModalRoute.of(context)!.animation!,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomCard(
                    onTap: () {
                      if (_menuItems[index].containsKey('screen')) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => _menuItems[index]['screen']));
                      } else {
                        Navigator.pushNamed(context, _menuItems[index]['route']);
                      }
                    },
                    child: ListTile(
                      leading: Icon(_menuItems[index]['icon'], color: Colors.red.shade700, size: 32),
                      title: Text(_menuItems[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isFabExpanded)
            ScaleTransition(
              scale: CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FloatingActionButton(
                  heroTag: 'present',
                  onPressed: () => Navigator.pushNamed(context, '/presentation'),
                  backgroundColor: Colors.red.shade600,
                  child: const Icon(Icons.play_arrow),
                ),
              ),
            ),
          FloatingActionButton(
            onPressed: _toggleFab,
            backgroundColor: Colors.red.shade700,
            child: AnimatedBuilder(
              animation: _fabController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _fabController.value * 0.75 * 3.14159,
                  child: Icon(_isFabExpanded ? Icons.close : Icons.menu),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}