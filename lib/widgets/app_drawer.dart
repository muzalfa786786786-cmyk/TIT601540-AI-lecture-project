// lib/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onNavigate;

  const AppDrawer({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // ─── Drawer Header ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Name
                  Text(
                    user?.name ?? 'Guest User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // User Email
                  Text(
                    user?.email ?? 'guest@teachlearn.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role.toUpperCase() ?? 'STUDENT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── Drawer Menu Items ────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(0); // Home tab
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.auto_awesome_rounded,
                    title: 'AI Slides',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(1); // AI Slides tab
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.chat_rounded,
                    title: 'Live Q&A',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(2); // Live Q&A tab
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.upload_file_rounded,
                    title: 'Upload Files',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(3); // Upload tab
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.book_rounded,
                    title: 'My Courses',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(4); // Courses tab
                    },
                  ),

                  const Divider(height: 20, indent: 16, endIndent: 16),

                  _buildDrawerItem(
                    context,
                    icon: Icons.slideshow_rounded,
                    title: 'Saved Slides',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.saved);
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.draw_rounded,
                    title: 'Whiteboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.whiteboard);
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.smart_toy_rounded,
                    title: 'AI Avatar',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.avatar);
                    },
                  ),

                  const Divider(height: 20, indent: 16, endIndent: 16),

                  _buildDrawerItem(
                    context,
                    icon: Icons.person_rounded,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.help_rounded,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpDialog(context);
                    },
                  ),

                  _buildDrawerItem(
                    context,
                    icon: Icons.info_rounded,
                    title: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // ─── Logout Button ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context, authProvider),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary, width: 1.5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─── Drawer Item Builder ──────────────────────────────────────
  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      hoverColor: AppTheme.primary.withOpacity(0.05),
      splashColor: AppTheme.primary.withOpacity(0.1),
    );
  }

  // ─── Logout Dialog ────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.auth,
                        (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ─── Help Dialog ──────────────────────────────────────────────
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Help & Support'),
          content: const Text(
            'For assistance, please contact:\n\n'
                '📧 Email: support@teachlearn.com\n'
                '📞 Phone: +1 (555) 123-4567\n\n'
                'Hours: Mon-Fri, 9 AM - 6 PM\n\n'
                'We\'re here to help you 24/7!',
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

  // ─── About Dialog ─────────────────────────────────────────────
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('About TeachLearn'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 60,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 12),
              const Text(
                'TeachLearn',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'AI Lecturer Platform',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildInfoRow('Version', '1.0.0'),
              _buildInfoRow('Developer', 'TeachLearn Team'),
              _buildInfoRow('Email', 'info@teachlearn.com'),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'An AI-powered learning platform that helps students with lecture generation, Q&A, whiteboard, and more.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            ': $value',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}