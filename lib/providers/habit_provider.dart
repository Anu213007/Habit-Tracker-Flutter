import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit_model.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> _habits = [];
  bool _isLoading = false;
  String? _selectedCategory;

  List<HabitModel> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  List<HabitModel> get filteredHabits {
    if (_selectedCategory == null) return _habits;
    return _habits
        .where((habit) => habit.categoryDisplayName == _selectedCategory)
        .toList();
  }

  List<HabitModel> get todaysHabits {
    return _habits.where((habit) {
      if (habit.frequency == HabitFrequency.daily) {
        return !habit.isCompletedToday();
      } else {
        return !habit.isCompletedThisWeek();
      }
    }).toList();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? habitsJson = prefs.getString('habits');
      if (habitsJson != null) {
        final List<dynamic> decoded = jsonDecode(habitsJson);
        _habits = decoded
            .map((e) => HabitModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      print('✅ Loaded ${_habits.length} habits');
    } catch (e) {
      print('❌ Error loading habits: $e');
      Fluttertoast.showToast(
        msg: 'Failed to load habits',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_habits.map((h) => h.toMap()).toList());
    await prefs.setString('habits', encoded);
  }

  Future<bool> createHabit({
    required String title,
    required HabitCategory category,
    required HabitFrequency frequency,
    DateTime? startDate,
    String? notes,
  }) async {
    try {
      final habit = HabitModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        category: category,
        frequency: frequency,
        startDate: startDate,
        notes: notes,
        createdAt: DateTime.now(),
      );

      _habits.insert(0, habit);
      await _saveHabits();

      Fluttertoast.showToast(
        msg: 'Habit created successfully! ✨',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error creating habit: $e');
      Fluttertoast.showToast(
        msg: 'Failed to create habit',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> updateHabit({
    required String habitId,
    String? title,
    HabitCategory? category,
    HabitFrequency? frequency,
    DateTime? startDate,
    String? notes,
  }) async {
    try {
      final index = _habits.indexWhere((h) => h.id == habitId);
      if (index == -1) return false;

      _habits[index] = _habits[index].copyWith(
        title: title,
        category: category,
        frequency: frequency,
        startDate: startDate,
        notes: notes,
      );

      await _saveHabits();

      Fluttertoast.showToast(
        msg: 'Habit updated successfully! ✨',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error updating habit: $e');
      Fluttertoast.showToast(
        msg: 'Failed to update habit',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> deleteHabit(String habitId) async {
    try {
      _habits.removeWhere((h) => h.id == habitId);
      await _saveHabits();

      Fluttertoast.showToast(
        msg: 'Habit deleted successfully! ✨',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error deleting habit: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete habit',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<bool> toggleHabitCompletion(String habitId) async {
    try {
      final index = _habits.indexWhere((h) => h.id == habitId);
      if (index == -1) return false;

      final habit = _habits[index];
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      List<DateTime> newCompletionHistory = List.from(habit.completionHistory);
      bool isCompleted = false;

      if (habit.frequency == HabitFrequency.daily) {
        if (habit.isCompletedToday()) {
          newCompletionHistory.removeWhere((date) {
            final d = DateTime(date.year, date.month, date.day);
            return d.isAtSameMomentAs(todayDate);
          });
          isCompleted = false;
        } else {
          newCompletionHistory.add(todayDate);
          isCompleted = true;
        }
      } else {
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        if (habit.isCompletedThisWeek()) {
          newCompletionHistory.removeWhere((date) {
            return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                date.isBefore(endOfWeek.add(const Duration(days: 1)));
          });
          isCompleted = false;
        } else {
          newCompletionHistory.add(todayDate);
          isCompleted = true;
        }
      }

      int newStreak = _calculateStreak(newCompletionHistory, habit.frequency);

      _habits[index] = habit.copyWith(
        completionHistory: newCompletionHistory,
        currentStreak: newStreak,
      );

      await _saveHabits();

      final message = isCompleted ? 'Great job! Keep it up! 🌟' : 'Habit unchecked';
      if (isCompleted) {
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error toggling habit completion: $e');
      Fluttertoast.showToast(
        msg: 'Failed to update habit',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  int _calculateStreak(List<DateTime> completionHistory, HabitFrequency frequency) {
    if (completionHistory.isEmpty) return 0;

    final sortedDates = completionHistory.toList()..sort((a, b) => b.compareTo(a));
    int streak = 0;
    final now = DateTime.now();

    if (frequency == HabitFrequency.daily) {
      DateTime currentDate = DateTime(now.year, now.month, now.day);
      for (int i = 0; i < sortedDates.length; i++) {
        final completionDate = DateTime(
            sortedDates[i].year, sortedDates[i].month, sortedDates[i].day);
        if (i == 0) {
          final daysDiff = currentDate.difference(completionDate).inDays;
          if (daysDiff <= 1) {
            streak = 1;
            currentDate = completionDate.subtract(const Duration(days: 1));
          } else {
            break;
          }
        } else {
          final expectedDate = currentDate;
          if (completionDate.isAtSameMomentAs(expectedDate)) {
            streak++;
            currentDate = currentDate.subtract(const Duration(days: 1));
          } else {
            break;
          }
        }
      }
    } else {
      final startOfCurrentWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfCurrentWeek = startOfCurrentWeek.add(const Duration(days: 6));
      bool currentWeekCompleted = sortedDates.any((date) {
        return date.isAfter(startOfCurrentWeek.subtract(const Duration(days: 1))) &&
            date.isBefore(endOfCurrentWeek.add(const Duration(days: 1)));
      });

      if (currentWeekCompleted) {
        streak = 1;
        DateTime currentWeekStart = startOfCurrentWeek.subtract(const Duration(days: 7));

        for (int i = 0; i < sortedDates.length; i++) {
          final completionDate = sortedDates[i];
          final weekStart = completionDate.subtract(Duration(days: completionDate.weekday - 1));
          if (weekStart.isAtSameMomentAs(currentWeekStart)) {
            streak++;
            currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));
          } else if (weekStart.isBefore(currentWeekStart)) {
            break;
          }
        }
      }
    }

    return streak;
  }

  List<HabitModel> getHabitsByCategory(HabitCategory category) {
    return _habits.where((habit) => habit.category == category).toList();
  }

  double getCompletionRate() {
    if (_habits.isEmpty) return 0.0;

    int totalCompletions = 0;
    int totalPossible = 0;

    for (final habit in _habits) {
      if (habit.frequency == HabitFrequency.daily) {
        totalPossible += 7;
        totalCompletions += habit.completionHistory
            .where((date) => date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
            .length;
      } else {
        totalPossible += 1;
        if (habit.isCompletedThisWeek()) totalCompletions += 1;
      }
    }

    return totalPossible > 0 ? totalCompletions / totalPossible : 0.0;
  }
}
