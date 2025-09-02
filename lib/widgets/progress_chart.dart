import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit_model.dart';
import '../utils/theme.dart';

class ProgressChart extends StatelessWidget {
  final List<HabitModel> habits;

  const ProgressChart({
    super.key,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 40,
              color: AppTheme.mutedText.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No data to display',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mutedText.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    final chartData = _generateChartData();

    return Column(
      children: [
        Text(
          'Last 7 Days Progress',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(
                enabled: true,
                // SIMPLIFIED: Remove problematic tooltip parameters for now
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()}%',
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      if (value >= 0 && value < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: AppTheme.mutedText.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == 0 || value == 25 || value == 50 || value == 75 || value == 100) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(
                            color: AppTheme.mutedText.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: AppTheme.warmBrown.withOpacity(0.2),
                  width: 1,
                ),
              ),
              barGroups: chartData.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: _getBarColor(value),
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 25,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.warmBrown.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<double> _generateChartData() {
    final now = DateTime.now();
    final List<double> dailyProgress = [];

    // Generate data for the last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      int completedHabits = 0;
      int totalHabits = 0;

      for (final habit in habits) {
        if (habit.frequency == HabitFrequency.daily) {
          totalHabits++;
          if (habit.completionHistory.any((completionDate) {
            final completion = DateTime(
              completionDate.year,
              completionDate.month,
              completionDate.day,
            );
            return completion.isAtSameMomentAs(dayStart);
          })) {
            completedHabits++;
          }
        } else if (habit.frequency == HabitFrequency.weekly) {
          // For weekly habits, check if this week is completed
          final weekStart = date.subtract(Duration(days: date.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));

          if (dayStart.isAfter(weekStart.subtract(const Duration(days: 1))) &&
              dayStart.isBefore(weekEnd.add(const Duration(days: 1)))) {
            totalHabits++;
            if (habit.completionHistory.any((completionDate) {
              return completionDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                  completionDate.isBefore(weekEnd.add(const Duration(days: 1)));
            })) {
              completedHabits++;
            }
          }
        }
      }

      final progress = totalHabits > 0 ? (completedHabits / totalHabits) * 100 : 0.0;
      dailyProgress.add(progress);
    }

    return dailyProgress;
  }

  Color _getBarColor(double value) {
    if (value >= 80) return AppTheme.sageGreen;
    if (value >= 60) return AppTheme.softBlue;
    if (value >= 40) return AppTheme.accentOrange;
    if (value >= 20) return AppTheme.softYellow;
    return AppTheme.gentlePink;
  }
}