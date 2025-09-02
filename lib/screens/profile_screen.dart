import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _heightController;
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isEditing = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.user.displayName);
    _heightController = TextEditingController(text: widget.user.height ?? '');
    _selectedGender = widget.user.gender;
    if (widget.user.dateOfBirth != null) {
      _selectedDate = DateTime.parse(widget.user.dateOfBirth!);
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)),
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

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _displayNameController.text = widget.user.displayName;
        _heightController.text = widget.user.height ?? '';
        _selectedGender = widget.user.gender;
        if (widget.user.dateOfBirth != null) {
          _selectedDate = DateTime.parse(widget.user.dateOfBirth!);
        }
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.updateProfile(
        displayName: _displayNameController.text.trim(),
        gender: _selectedGender,
        dateOfBirth: _selectedDate?.toIso8601String(),
        height: _heightController.text.trim().isEmpty ? null : _heightController.text.trim(),
      );

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.warmBrown,
                    child: Text(
                      widget.user.displayName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.displayName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.warmBrown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                    icon: Icon(
                      Icons.settings,
                      color: AppTheme.warmBrown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFormField(
                      label: 'Display Name',
                      controller: _displayNameController,
                      icon: Icons.person_outline,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your display name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildFormField(
                      label: 'Email',
                      controller: TextEditingController(text: widget.user.email),
                      icon: Icons.email_outlined,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    if (_isEditing)
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
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
                      )
                    else
                      _buildFormField(
                        label: 'Gender',
                        controller: TextEditingController(text: widget.user.gender ?? 'Not specified'),
                        icon: Icons.person_outline,
                        enabled: false,
                      ),
                    const SizedBox(height: 20),
                    if (_isEditing)
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.warmBrown.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppTheme.mutedText),
                              const SizedBox(width: 16),
                              Text(
                                _selectedDate != null
                                    ? 'Date of Birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                    : 'Date of Birth (Optional)',
                                style: TextStyle(
                                  color: _selectedDate != null ? AppTheme.mutedText : AppTheme.mutedText.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      _buildFormField(
                        label: 'Date of Birth',
                        controller: TextEditingController(
                          text: widget.user.dateOfBirth != null
                              ? _formatDate(DateTime.parse(widget.user.dateOfBirth!))
                              : 'Not specified',
                        ),
                        icon: Icons.calendar_today,
                        enabled: false,
                      ),
                    const SizedBox(height: 20),
                    _buildFormField(
                      label: 'Height',
                      controller: _heightController,
                      icon: Icons.height,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        if (_isEditing) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _toggleEditing,
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              child: const Text('Save Changes'),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _toggleEditing,
                              child: const Text('Edit Profile'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
