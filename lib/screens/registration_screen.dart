import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import 'dashboard_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _heightController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String? _selectedGender;
  DateTime? _selectedDate;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.warmBrown,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        displayName: _displayNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        gender: _selectedGender,
        dateOfBirth: _selectedDate?.toIso8601String(),
        height: _heightController.text.trim().isEmpty ? null : _heightController.text.trim(),
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to the Terms & Conditions'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24, // Add padding for keyboard
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48, // Ensure minimum height
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16), // Reduced from 40

                      // Header
                      Text(
                        'Join the Journey 🌟',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.warmBrown,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: const Duration(milliseconds: 300))
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 8),

                      Text(
                        'Create your magical habit tracking account',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.mutedText,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: const Duration(milliseconds: 500))
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 32), // Reduced from 40

                      // Registration form
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
                              // Display Name field
                              TextFormField(
                                controller: _displayNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Display Name *',
                                  hintText: 'Enter your display name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your display name';
                                  }
                                  if (value.length < 2) {
                                    return 'Name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ).animate().fadeIn(delay: const Duration(milliseconds: 600))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 16), // Reduced from 20

                              // Email field
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email *',
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ).animate().fadeIn(delay: const Duration(milliseconds: 700))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 16), // Reduced from 20

                              // Password field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password *',
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                                    return 'Password must include uppercase, lowercase, and number';
                                  }
                                  return null;
                                },
                              ).animate().fadeIn(delay: const Duration(milliseconds: 800))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 16), // Reduced from 20

                              // Confirm Password field
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password *',
                                  hintText: 'Confirm your password',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ).animate().fadeIn(delay: const Duration(milliseconds: 900))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 16), // Reduced from 20

                              // Gender dropdown
                              DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: const InputDecoration(
                                  labelText: 'Gender (Optional)',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                items: _genderOptions.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                              ).animate().fadeIn(delay: const Duration(milliseconds: 1000))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 16), // Reduced from 20

                              // Date of Birth field
                              InkWell(
                                onTap: _selectDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.warmBrown.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme.cardBackground,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, color: AppTheme.mutedText),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          _selectedDate != null
                                              ? 'Date of Birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                              : 'Date of Birth (Optional)',
                                          style: TextStyle(
                                            color: _selectedDate != null ? AppTheme.mutedText : AppTheme.mutedText.withOpacity(0.6),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).animate().fadeIn(delay: const Duration(milliseconds: 1100))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 16), // Reduced from 20

                              // Height field
                              TextFormField(
                                controller: _heightController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Height (Optional)',
                                  hintText: 'e.g., 5\'8" or 173 cm',
                                  prefixIcon: Icon(Icons.height),
                                ),
                              ).animate().fadeIn(delay: const Duration(milliseconds: 1200))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 20), // Reduced from 24

                              // Terms and Conditions checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                    activeColor: AppTheme.warmBrown,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'I agree to the Terms & Conditions *',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.mutedText,
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(delay: const Duration(milliseconds: 1300))
                                  .slideX(begin: 0.3, end: 0),

                              const SizedBox(height: 24), // Reduced from 32

                              // Register button
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: authProvider.isLoading ? null : _register,
                                      child: authProvider.isLoading
                                          ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                          : const Text(
                                        'Create Account',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                              ).animate().fadeIn(delay: const Duration(milliseconds: 1400))
                                  .slideY(begin: 0.3, end: 0),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: const Duration(milliseconds: 500))
                          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),

                      const SizedBox(height: 32), // Reduced from 40

                      // Floating decorative elements
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.eco,
                            color: AppTheme.sageGreen.withOpacity(0.3),
                            size: 30,
                          ).animate(onPlay: (controller) => controller.repeat())
                              .moveY(begin: 0, end: -10, duration: const Duration(seconds: 2)),

                          Icon(
                            Icons.star,
                            color: AppTheme.softYellow.withOpacity(0.3),
                            size: 25,
                          ).animate(onPlay: (controller) => controller.repeat())
                              .moveY(begin: 0, end: -8, duration: const Duration(seconds: 3)),

                          Icon(
                            Icons.favorite,
                            color: AppTheme.gentlePink.withOpacity(0.3),
                            size: 28,
                          ).animate(onPlay: (controller) => controller.repeat())
                              .moveY(begin: 0, end: -12, duration: const Duration(seconds: 2, milliseconds: 500)),
                        ],
                      ).animate().fadeIn(delay: const Duration(milliseconds: 1600)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}