// lib/screens/auth_screen.dart
// Login & Register with TabBar, role selection, form validation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';  // ✅ Changed from utils to routes
import '../widgets/common_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Login controllers
  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _loginPassVisible = false;

  // Register controllers
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regFormKey = GlobalKey<FormState>();
  bool _regPassVisible = false;
  String _selectedRole = 'Student';

  final _roles = ['Student', 'Teacher', 'Admin'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
        _loginEmailCtrl.text.trim(), _loginPassCtrl.text.trim());
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);  // ✅ Changed to main
    }
  }

  void _onRegister() async {
    if (!_regFormKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      _regNameCtrl.text.trim(),
      _regEmailCtrl.text.trim(),
      _regPassCtrl.text.trim(),
      _selectedRole.toLowerCase(),
    );
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);  // ✅ Changed to main
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ─── Hero Logo ─────────────────────────────────
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: Colors.white, size: 44),
                ),
              ),

              const SizedBox(height: 20),
              Text('TeachLearn',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: AppTheme.primary)),
              const SizedBox(height: 4),
              Text('AI Powered Education Platform',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),

              // ─── TabBar ────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  indicator: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textMuted,
                  tabs: const [Tab(text: 'Login'), Tab(text: 'Register')],
                ),
              ),
              const SizedBox(height: 28),

              // ─── Error Banner ──────────────────────────────
              Consumer<AuthProvider>(
                builder: (_, auth, __) {
                  if (auth.error == null) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppTheme.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(auth.error!,
                              style: const TextStyle(
                                  color: AppTheme.primaryDark,
                                  fontSize: 13)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: AppTheme.primary),
                          onPressed: () =>
                              context.read<AuthProvider>().clearError(),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ─── Tab Views ─────────────────────────────────
              SizedBox(
                height: 440,
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [_buildLoginTab(), _buildRegisterTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── LOGIN TAB ───────────────────────────────────────────────
  Widget _buildLoginTab() {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) => Form(
        key: _loginFormKey,
        child: Column(
          children: [
            AppTextField(
              label: 'Email Address',
              hint: 'you@example.com',
              prefixIcon: Icons.email_outlined,
              controller: _loginEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              controller: _loginPassCtrl,
              obscureText: !_loginPassVisible,
              suffixIcon: IconButton(
                icon: Icon(_loginPassVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                    color: AppTheme.textMuted, size: 20),
                onPressed: () =>
                    setState(() => _loginPassVisible = !_loginPassVisible),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Login',
              onPressed: _onLogin,
              icon: Icons.login_rounded,
              isLoading: auth.isLoading,
            ),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 20),
            _buildSocialRow(),
          ],
        ),
      ),
    );
  }

  // ─── REGISTER TAB ────────────────────────────────────────────
  Widget _buildRegisterTab() {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) => Form(
        key: _regFormKey,
        child: Column(
          children: [
            AppTextField(
              label: 'Full Name',
              hint: 'Your full name',
              prefixIcon: Icons.person_outline,
              controller: _regNameCtrl,
              validator: (v) =>
              v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email Address',
              hint: 'you@example.com',
              prefixIcon: Icons.email_outlined,
              controller: _regEmailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ─── Role Selector ──────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Role',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppTheme.textMuted)),
                const SizedBox(height: 8),
                Row(
                  children: _roles.map((r) {
                    final selected = _selectedRole == r;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: r != _roles.last ? 8 : 0),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedRole = r),
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 200),
                            padding:
                            const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.surface,
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.divider,
                              ),
                            ),
                            child: Text(
                              r,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppTheme.textMuted,
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 14),
            AppTextField(
              label: 'Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              controller: _regPassCtrl,
              obscureText: !_regPassVisible,
              suffixIcon: IconButton(
                icon: Icon(_regPassVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                    color: AppTheme.textMuted, size: 20),
                onPressed: () =>
                    setState(() => _regPassVisible = !_regPassVisible),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Minimum 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Create Account',
              onPressed: _onRegister,
              icon: Icons.person_add_rounded,
              isLoading: auth.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or continue with',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      children: [
        Expanded(child: _socialBtn('Google', Icons.g_mobiledata_rounded,
            Colors.red.shade600)),
        const SizedBox(width: 12),
        Expanded(child: _socialBtn(
            'Apple', Icons.apple_rounded, AppTheme.textDark)),
      ],
    );
  }

  Widget _socialBtn(String label, IconData icon, Color color) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: color, size: 22),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}