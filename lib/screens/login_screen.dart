import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import 'registration_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isShort = screenHeight < 700;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.parchmentBackground,
              AppTheme.cardBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isShort ? 24 : 60),
                Text(
                  'Welcome Back! 🌸',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.warmBrown,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Continue your magical journey',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.mutedText,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 500))
                    .slideY(begin: 0.3, end: 0),
                SizedBox(height: isShort ? 24 : 60),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.warmBrown.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 700))
                            .slideX(begin: 0.3, end: 0),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 900))
                            .slideX(begin: 0.3, end: 0),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? true),
                              activeColor: AppTheme.warmBrown,
                            ),
                            const Text('Remember me'),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 1000))
                            .slideX(begin: 0.3, end: 0),
                        const SizedBox(height: 20),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : _login,
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                                    : const Text('Login', style: TextStyle(fontSize: 18)),
                              ),
                            );
                          },
                        )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 1100))
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppTheme.mutedText.withOpacity(0.3))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('or', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText)),
                            ),
                            Expanded(child: Divider(color: AppTheme.mutedText.withOpacity(0.3))),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 1300)),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                            ),
                            child: const Text('Create New Account', style: TextStyle(fontSize: 18)),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: const Duration(milliseconds: 1500))
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 600))
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
                SizedBox(height: isShort ? 12 : 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.eco, color: AppTheme.sageGreen.withOpacity(0.3), size: 28)
                        .animate(onPlay: (controller) => controller.repeat())
                        .moveY(begin: 0, end: -10, duration: const Duration(seconds: 2)),
                    const SizedBox(width: 40),
                    Icon(Icons.star, color: AppTheme.softYellow.withOpacity(0.3), size: 25)
                        .animate(onPlay: (controller) => controller.repeat())
                        .moveY(begin: 0, end: -8, duration: const Duration(seconds: 3)),
                    const SizedBox(width: 40),
                    Icon(Icons.favorite, color: AppTheme.gentlePink.withOpacity(0.3), size: 28)
                        .animate(onPlay: (controller) => controller.repeat())
                        .moveY(begin: 0, end: -12, duration: const Duration(milliseconds: 2500)),
                  ],
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 1700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
