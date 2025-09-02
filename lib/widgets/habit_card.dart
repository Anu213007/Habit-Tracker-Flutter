import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/habit_model.dart';
import '../utils/theme.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final VoidCallback onToggle;
  final bool showActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.showActions = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.frequency == HabitFrequency.daily
        ? habit.isCompletedToday()
        : habit.isCompletedThisWeek();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warmBrown.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isCompleted 
              ? AppTheme.sageGreen.withOpacity(0.3)
              : AppTheme.warmBrown.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Category icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(habit.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        habit.categoryIcon,
                        color: _getCategoryColor(habit.category),
                        size: 20,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Category label
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(habit.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getCategoryColor(habit.category).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        habit.categoryDisplayName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getCategoryColor(habit.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Frequency indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.softBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.softBlue.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        habit.frequency == HabitFrequency.daily ? 'Daily' : 'Weekly',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.softBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Habit title
                Text(
                  habit.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isCompleted ? AppTheme.mutedText.withOpacity(0.6) : AppTheme.mutedText,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                if (habit.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    habit.notes!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mutedText.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    // Streak indicator
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: AppTheme.accentOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.currentStreak}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          habit.frequency == HabitFrequency.daily ? 'days' : 'weeks',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mutedText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Completion checkbox
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted ? AppTheme.sageGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCompleted ? AppTheme.sageGreen : AppTheme.warmBrown,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ],
                ),
                
                // Action buttons
                if (showActions) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.warmBrown,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.3, end: 0);
  }

  Color _getCategoryColor(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return AppTheme.sageGreen;
      case HabitCategory.study:
        return AppTheme.softBlue;
      case HabitCategory.fitness:
        return AppTheme.accentOrange;
      case HabitCategory.productivity:
        return AppTheme.warmBrown;
      case HabitCategory.mentalHealth:
        return AppTheme.gentlePink;
      case HabitCategory.others:
        return AppTheme.mutedText;
    }
  }
}
