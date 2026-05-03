// lib/screens/home_screen.dart (Updated with Drawer integration)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import '../widgets/app_drawer.dart';  // ✅ Import AppDrawer

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      // ✅ Drawer integration
      drawer: AppDrawer(onNavigate: onNavigate),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Sliver App Bar ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            // ✅ Menu icon automatically opens drawer
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: -60,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.name ?? 'Student',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Ready to learn today?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Body Content ─────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard('12', 'Active Courses', Icons.book_rounded, AppTheme.primary, context),
                    _buildStatCard('48', 'Slides Generated', Icons.slideshow_rounded, Colors.blue, context),
                    _buildStatCard('36', 'Q&A Sessions', Icons.question_answer_rounded, Colors.green, context),
                    _buildStatCard('5h 20m', 'Study Time', Icons.timer_rounded, Colors.orange, context),
                  ],
                ),

                const SizedBox(height: 28),

                // Quick Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All quick actions available in drawer'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildQuickActions(context),

                const SizedBox(height: 28),

                // Recent Courses
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Courses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onNavigate(4);
                      },
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildRecentCourses(context),

                const SizedBox(height: 28),

                // Saved Slides
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saved Slides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.saved);
                      },
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildSavedSlides(context),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 👋';
    if (hour < 17) return 'Good Afternoon 👋';
    return 'Good Evening 👋';
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing $label'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      (Icons.auto_awesome, 'AI Slides', AppTheme.primary, 1),
      (Icons.upload_file, 'Upload', Colors.blue, 3),
      (Icons.chat_bubble_rounded, 'Live Q&A', Colors.green, 2),
      (Icons.draw_rounded, 'Whiteboard', Colors.orange, -1),
      (Icons.smart_toy_rounded, 'AI Avatar', const Color(0xFF9333EA), -2),
      (Icons.analytics_rounded, 'Progress', const Color(0xFFDB2777), -3),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: actions.map((a) {
        return GestureDetector(
          onTap: () {
            if (a.$4 >= 0) {
              onNavigate(a.$4);
            } else if (a.$4 == -1) {
              Navigator.pushNamed(context, AppRoutes.whiteboard);
            } else if (a.$4 == -2) {
              Navigator.pushNamed(context, AppRoutes.avatar);
            }
            else if (a.$4 == -3) {
              Navigator.pushNamed(context, AppRoutes.progress);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: a.$3.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(a.$1, color: a.$3, size: 22),
                ),
                const SizedBox(height: 8),
                Text(a.$2,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentCourses(BuildContext context) {
    final courses = [
      ('Mathematics', 'Calculus & Algebra', 0.65, AppTheme.primary),
      ('Physics', 'Classical Mechanics', 0.42, Colors.blue),
      ('Computer Science', 'Data Structures', 0.88, Colors.green),
    ];

    return Column(
      children: courses.map((c) {
        return GestureDetector(
          onTap: () {
            onNavigate(4);
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.$4.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.menu_book_rounded,
                        color: c.$4, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.$1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        Text(c.$2,
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textMuted)),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: c.$3,
                          backgroundColor: AppTheme.divider,
                          valueColor: AlwaysStoppedAnimation(c.$4),
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${(c.$3 * 100).toInt()}%',
                      style: TextStyle(
                          color: c.$4,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSavedSlides(BuildContext context) {
    final slides = [
      ('Calculus Basics', 'Mathematics', AppTheme.primary),
      ("Newton's Laws", 'Physics', Colors.blue),
      ('Sorting Algo', 'CS', Colors.green),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: slides.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final s = slides[i];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.saved);
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.slideshow_rounded, color: s.$3, size: 22),
                    const SizedBox(height: 8),
                    Text(s.$1,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                        overflow: TextOverflow.ellipsis),
                    Text(s.$2,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.textMuted)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}