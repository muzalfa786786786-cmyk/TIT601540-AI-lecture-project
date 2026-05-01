// lib/screens/main_nav.dart
// BottomNavigationBar + Drawer shell for the main app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import 'home_screen.dart';
import 'slide_generator_screen.dart';
import 'live_qa_screen.dart';
import 'student_upload_screen.dart';
import 'courses_screen.dart';
import 'saved_slides_screen.dart';
import 'whiteboard_screen.dart';
import 'avatar_screen.dart';
import 'profile_screen.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;

  void _goTo(int i) => setState(() => _currentIndex = i);

  late final List<Widget> _screens = [
    HomeScreen(onNavigate: _goTo),
    const SlideGeneratorScreen(),
    const LiveQAScreen(),
    const StudentUploadScreen(),
    const CoursesScreen(),
  ];

  static const _navItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
        label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.auto_awesome_outlined),
        activeIcon: Icon(Icons.auto_awesome),
        label: 'AI Slides'),
    BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline_rounded),
        activeIcon: Icon(Icons.chat_bubble_rounded),
        label: 'Q&A'),
    BottomNavigationBarItem(
        icon: Icon(Icons.upload_file_outlined),
        activeIcon: Icon(Icons.upload_file),
        label: 'Upload'),
    BottomNavigationBarItem(
        icon: Icon(Icons.book_outlined),
        activeIcon: Icon(Icons.book),
        label: 'Courses'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: _navItems,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  // ─── App Drawer ──────────────────────────────────────────────
  Widget _buildDrawer() {
    final user = context.watch<AuthProvider>().user;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ─── Drawer Header ────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'TeachLearn User',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                        Text(user?.email ?? 'user@example.com',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            user?.role.toUpperCase() ?? 'STUDENT',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Drawer Items ──────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(Icons.home_rounded, 'Dashboard', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 0);
                  }),
                  _drawerItem(Icons.auto_awesome, 'AI Slide Generator', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 1);
                  }),
                  _drawerItem(Icons.question_answer_rounded, 'Live Q&A', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 2);
                  }),
                  _drawerItem(Icons.upload_file_rounded, 'Upload Files', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 3);
                  }),
                  _drawerItem(Icons.book_rounded, 'My Courses', () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 4);
                  }),
                  const Divider(indent: 16, endIndent: 16),

                  // New Screens Section
                  _drawerItem(Icons.slideshow_rounded, 'Saved Slides', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.saved);
                  }),
                  _drawerItem(Icons.draw_rounded, 'Whiteboard', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.whiteboard);
                  }),
                  _drawerItem(Icons.smart_toy_rounded, 'AI Avatar', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.avatar);
                  }),

                  const Divider(indent: 16, endIndent: 16),

                  _drawerItem(Icons.person_outline, 'Profile & Settings', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.profile);
                  }),
                  _drawerItem(Icons.help_outline_rounded, 'Help & Support', () {
                    Navigator.pop(context);
                    _showHelpDialog();
                  }),
                  _drawerItem(Icons.info_outline, 'About TeachLearn', () {
                    Navigator.pop(context);
                    _showAboutDialog();
                  }),
                ],
              ),
            ),

            // ─── Logout ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.auth);
                  }
                },
                icon: const Icon(Icons.logout_rounded,
                    color: AppTheme.primary),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  side: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      horizontalTitleGap: 8,
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
            'For assistance, please contact:\n\n'
                '📧 Email: support@teachablearn.com\n'
                '📞 Phone: +1 (555) 123-4567\n\n'
                'Hours: Mon-Fri, 9 AM - 6 PM',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About TeachLearn'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school, size: 50, color: AppTheme.primary),
              SizedBox(height: 10),
              Text(
                'TeachLearn - AI Lecturer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                'An AI-powered learning platform that helps students with lecture generation, Q&A, whiteboard, and more.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}