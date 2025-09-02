import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/providers/theme_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/quote_provider.dart';
import 'package:habit_tracker/screens/splash_screen.dart';
import 'package:habit_tracker/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No Firebase initialization needed

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => QuoteProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Habit Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
