import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'about_screen.dart';
import 'gratitude_screen.dart';
class TabDrawerDemo extends StatefulWidget {
  const TabDrawerDemo({super.key});
  @override
  State<TabDrawerDemo> createState() => _TabDrawerDemoState();
}
class _TabDrawerDemoState extends State<TabDrawerDemo> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBar & Drawer Demo'),
        backgroundColor: Colors.red.shade700,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.chat), text: 'Chat'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              accountName: const Text('Muzalfa Bibi'),
              accountEmail: const Text('muzalfa@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: const Icon(Icons.person, color: Colors.red, size: 40),
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
              ),
            ),
            // Menu Items
            ListTile(
              leading: const Icon(Icons.home, color: Colors.red),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _tabController.animateTo(0); // Switch to Home tab
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.red),
              title: const Text('Chat'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.red),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(2);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.red),
              title: const Text('About (Hero Animation)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Gratitude'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/gratitude');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Home Tab Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 80, color: Colors.red),
                SizedBox(height: 16),
                Text('Home Tab', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Welcome to TabBar Demo!'),
              ],
            ),
          ),
          // Chat Tab Content (reusing existing ChatScreen)
          ChatScreen(),
          // Profile Tab Content (reusing existing ProfileScreen)
          ProfileScreen(),
        ],
      ),
    );
  }
}