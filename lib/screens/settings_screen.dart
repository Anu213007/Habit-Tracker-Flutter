import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Settings header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.sageGreen.withOpacity(0.1),
                      AppTheme.softBlue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 40,
                      color: AppTheme.warmBrown,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'App Settings',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.warmBrown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Customize your experience',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedText,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 300))
                .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 24),

              // Theme settings
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.warmBrown.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Theme toggle
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.softYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                              color: AppTheme.softYellow,
                            ),
                          ),
                          title: Text(
                            'Theme',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.mutedText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mutedText.withOpacity(0.7),
                            ),
                          ),
                          trailing: Switch(
                            value: themeProvider.isDarkMode,
                            onChanged: (value) => themeProvider.setTheme(value),
                            activeColor: AppTheme.warmBrown,
                          ),
                        ).animate().fadeIn(delay: const Duration(milliseconds: 400))
                          .slideX(begin: 0.3, end: 0);
                      },
                    ),
                    
                    Divider(color: AppTheme.mutedText.withOpacity(0.1)),
                    
                    // About section
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.sageGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: AppTheme.sageGreen,
                        ),
                      ),
                      title: Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'App version and information',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mutedText.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.mutedText.withOpacity(0.5),
                        size: 16,
                      ),
                      onTap: () => _showAboutDialog(context),
                    ).animate().fadeIn(delay: const Duration(milliseconds: 500))
                      .slideX(begin: 0.3, end: 0),
                    
                    Divider(color: AppTheme.mutedText.withOpacity(0.1)),
                    
                    // Help & Support
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.softBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: AppTheme.softBlue,
                        ),
                      ),
                      title: Text(
                        'Help & Support',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Get help and contact support',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mutedText.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.mutedText.withOpacity(0.5),
                        size: 16,
                      ),
                      onTap: () => _showHelpDialog(context),
                    ).animate().fadeIn(delay: const Duration(milliseconds: 600))
                      .slideX(begin: 0.3, end: 0),
                  ],
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 400))
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),

              const SizedBox(height: 24),

              // Account actions
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.warmBrown.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Logout button
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                      ),
                      title: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Sign out of your account',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mutedText.withOpacity(0.7),
                        ),
                      ),
                      onTap: () => _showLogoutDialog(context),
                    ).animate().fadeIn(delay: const Duration(milliseconds: 700))
                      .slideX(begin: 0.3, end: 0),
                  ],
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 600))
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),

              const SizedBox(height: 40),

              // App footer
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.eco,
                      size: 40,
                      color: AppTheme.sageGreen.withOpacity(0.6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Habit Tracker',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.mutedText.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mutedText.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Made with ❤️ and Studio Ghibli magic',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mutedText.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Habit Tracker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A magical habit tracking app inspired by Studio Ghibli aesthetics.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('• Habit creation and tracking'),
            Text('• Progress visualization'),
            Text('• Motivational quotes'),
            Text('• Light/Dark theme'),
            Text('• User profiles'),
            const SizedBox(height: 16),
            Text(
              'Built with Flutter and Firebase',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help with the app? Here are some tips:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Getting Started:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('1. Create your first habit'),
            Text('2. Set a frequency (daily/weekly)'),
            Text('3. Mark completion each day'),
            Text('4. Track your progress'),
            const SizedBox(height: 16),
            Text(
              'For additional support, please contact our team.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout? You will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
