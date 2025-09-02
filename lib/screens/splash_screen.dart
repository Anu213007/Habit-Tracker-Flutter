import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeController.forward();
    _floatController.repeat(reverse: true);

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkRememberedUser();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => authProvider.isAuthenticated ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.parchmentBackground, AppTheme.cardBackground],
          ),
        ),
        child: Stack(
          children: [
            // Stars
            ...List.generate(5, (i) {
              return Positioned(
                left: (i * 80) % size.width,
                top: 100 + (i * 60),
                child: Icon(Icons.star, color: AppTheme.softYellow.withOpacity(0.6), size: 20 + i * 2)
                    .animate(controller: _floatController)
                    .moveY(begin: 0, end: -20)
                    .fadeIn(duration: Duration(milliseconds: 500 + i * 200)),
              );
            }),

            // Leaves
            ...List.generate(3, (i) {
              return Positioned(
                left: (i * 120) % (size.width * 0.8),
                bottom: 50 + i * 40,
                child: Icon(Icons.eco, color: AppTheme.sageGreen.withOpacity(0.4), size: 30 + i * 5)
                    .animate(controller: _floatController)
                    .moveY(begin: 0, end: -15)
                    .fadeIn(duration: Duration(milliseconds: 800 + i * 300)),
              );
            }),

            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSplashCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.warmBrown.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          _buildAppIcon(),
          const SizedBox(height: 24),
          _buildAppTitle(),
          const SizedBox(height: 8),
          _buildSubtitle(),
          const SizedBox(height: 32),
          _buildLoadingIndicator(),
        ],
      ),
    ).animate(controller: _fadeController).fadeIn(delay: const Duration(milliseconds: 300)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  Widget _buildAppIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.sageGreen,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [BoxShadow(color: AppTheme.sageGreen.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: const Icon(Icons.eco, size: 60, color: Colors.white),
    ).animate(controller: _fadeController).scale(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 1.0)).then().shake(duration: const Duration(milliseconds: 500));
  }

  Widget _buildAppTitle() {
    return Text(
      'Habit Tracker',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ).animate(controller: _fadeController).fadeIn(delay: const Duration(milliseconds: 500)).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSubtitle() {
    return Text(
      'Your magical journey to better habits',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.mutedText, fontStyle: FontStyle.italic),
      textAlign: TextAlign.center,
    ).animate(controller: _fadeController).fadeIn(delay: const Duration(milliseconds: 800)).slideY(begin: 0.3, end: 0);
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.warmBrown),
      ),
    ).animate(controller: _fadeController).fadeIn(delay: const Duration(milliseconds: 1200)).rotate(duration: const Duration(seconds: 2));
  }
}
