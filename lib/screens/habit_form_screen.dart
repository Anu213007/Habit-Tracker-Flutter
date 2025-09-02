import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/habit_model.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../utils/theme.dart';

class HabitFormScreen extends StatefulWidget {
  final HabitModel? habit;

  const HabitFormScreen({super.key, this.habit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  HabitCategory _selectedCategory = HabitCategory.health;
  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  DateTime? _selectedStartDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit?.title ?? '');
    _notesController = TextEditingController(text: widget.habit?.notes ?? '');
    _selectedCategory = widget.habit?.category ?? HabitCategory.health;
    _selectedFrequency = widget.habit?.frequency ?? HabitFrequency.daily;
    _selectedStartDate = widget.habit?.startDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppTheme.warmBrown,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedStartDate = picked);
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);

    bool success;
    if (widget.habit != null) {
      success = await habitProvider.updateHabit(
        habitId: widget.habit!.id,
        title: _titleController.text.trim(),
        category: _selectedCategory,
        frequency: _selectedFrequency,
        startDate: _selectedStartDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
    } else {
      success = await habitProvider.createHabit(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        frequency: _selectedFrequency,
        startDate: _selectedStartDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Habit' : 'Create Habit'),
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
            colors: [AppTheme.parchmentBackground, AppTheme.cardBackground],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit Your Habit ✨' : 'Create a New Habit 🌟',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.warmBrown,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    isEditing ? 'Make changes to your habit tracking journey' : 'Start building positive habits for a better tomorrow',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.mutedText, fontStyle: FontStyle.italic),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 32),

                  _buildFormContainer(),
                  const SizedBox(height: 40),
                  _buildTipsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.warmBrown.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          _buildTitleField(),
          const SizedBox(height: 20),
          _buildCategoryDropdown(),
          const SizedBox(height: 20),
          _buildFrequencyDropdown(),
          const SizedBox(height: 20),
          _buildStartDatePicker(),
          const SizedBox(height: 20),
          _buildNotesField(),
          const SizedBox(height: 32),
          _buildSaveButton(),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 400)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }

  Widget _buildTitleField() => TextFormField(
    controller: _titleController,
    decoration: const InputDecoration(labelText: 'Habit Title *', hintText: 'e.g., Drink 8 glasses of water', prefixIcon: Icon(Icons.edit)),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Please enter a habit title';
      if (value.length < 3) return 'Title must be at least 3 characters';
      return null;
    },
  ).animate().fadeIn(delay: const Duration(milliseconds: 600)).slideX(begin: 0.3, end: 0);

  Widget _buildCategoryDropdown() => DropdownButtonFormField<HabitCategory>(
    value: _selectedCategory,
    decoration: const InputDecoration(labelText: 'Category *', prefixIcon: Icon(Icons.category)),
    items: HabitCategory.values
        .map((c) => DropdownMenuItem<HabitCategory>(
      value: c,
      child: Row(children: [Icon(_getCategoryIcon(c), color: _getCategoryColor(c), size: 20), const SizedBox(width: 8), Text(_getCategoryDisplayName(c))]),
    ))
        .toList(),
    onChanged: (c) => setState(() => _selectedCategory = c!),
  ).animate().fadeIn(delay: const Duration(milliseconds: 700)).slideX(begin: 0.3, end: 0);

  Widget _buildFrequencyDropdown() => DropdownButtonFormField<HabitFrequency>(
    value: _selectedFrequency,
    decoration: const InputDecoration(labelText: 'Frequency *', prefixIcon: Icon(Icons.repeat)),
    items: HabitFrequency.values.map((f) => DropdownMenuItem(value: f, child: Text(f == HabitFrequency.daily ? 'Daily' : 'Weekly'))).toList(),
    onChanged: (f) => setState(() => _selectedFrequency = f!),
  ).animate().fadeIn(delay: const Duration(milliseconds: 800)).slideX(begin: 0.3, end: 0);

  Widget _buildStartDatePicker() => InkWell(
    onTap: _selectStartDate,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(border: Border.all(color: AppTheme.warmBrown.withOpacity(0.5)), borderRadius: BorderRadius.circular(12), color: Theme.of(context).cardColor),
      child: Row(children: [Icon(Icons.calendar_today, color: AppTheme.mutedText), const SizedBox(width: 16), Text(_selectedStartDate != null ? 'Start Date: ${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}' : 'Start Date (Optional)', style: TextStyle(color: _selectedStartDate != null ? AppTheme.mutedText : AppTheme.mutedText.withOpacity(0.6)))]),
    ),
  ).animate().fadeIn(delay: const Duration(milliseconds: 900)).slideX(begin: 0.3, end: 0);

  Widget _buildNotesField() => TextFormField(
    controller: _notesController,
    maxLines: 3,
    decoration: const InputDecoration(labelText: 'Notes (Optional)', hintText: 'Add any additional details or motivation...', prefixIcon: Icon(Icons.note), alignLabelWithHint: true),
  ).animate().fadeIn(delay: const Duration(milliseconds: 1000)).slideX(begin: 0.3, end: 0);

  Widget _buildSaveButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _saveHabit,
      child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : Text(widget.habit != null ? 'Update Habit' : 'Create Habit', style: const TextStyle(fontSize: 18)),
    ),
  ).animate().fadeIn(delay: const Duration(milliseconds: 1100)).slideY(begin: 0.3, end: 0);

  Widget _buildTipsSection() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppTheme.sageGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.sageGreen.withOpacity(0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.lightbulb_outline, color: AppTheme.sageGreen, size: 24), const SizedBox(width: 8), Text('Pro Tips 🌟', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.sageGreen, fontWeight: FontWeight.bold))]),
      const SizedBox(height: 12),
      ...['• Start with small, achievable habits', '• Be consistent rather than perfect', '• Track your progress to stay motivated'].map((tip) => Text(tip, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText))),
    ]),
  ).animate().fadeIn(delay: const Duration(milliseconds: 1200)).slideY(begin: 0.3, end: 0);

  IconData _getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.study:
        return Icons.school;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.productivity:
        return Icons.work;
      case HabitCategory.mentalHealth:
        return Icons.psychology;
      case HabitCategory.others:
        return Icons.more_horiz;
    }
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

  String _getCategoryDisplayName(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.study:
        return 'Study';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.mentalHealth:
        return 'Mental Health';
      case HabitCategory.others:
        return 'Others';
    }
  }
}
