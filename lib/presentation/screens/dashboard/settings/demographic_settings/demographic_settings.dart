import 'package:flutter/material.dart';

class DemographicSettings extends StatefulWidget {
  const DemographicSettings({Key? key}) : super(key: key);

  @override
  State<DemographicSettings> createState() => _DemographicSettingsPage();
}

class _DemographicSettingsPage extends State<DemographicSettings> {
  // Separate controllers for first name, last name, age, major, city
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Dropdown values
  String _selectedGender = 'Other';  // Default to 'Other'
  String _selectedPronouns = '';     // Empty means not selected

  // Handle form submission
  void _handleSubmit() {
    // Basic validation: check if required fields are empty
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _majorController.text.trim().isEmpty ||
        _selectedGender.isEmpty ||
        _selectedPronouns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required (*) fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // If all required fields are filled, show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form submitted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demographic Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            // First Name (Required)
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Enter your first name... *',
                hintText: 'What is your first name?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name (Required)
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Enter your last name... *',
                hintText: 'What is your last name?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Age (Required)
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age *',
                hintText: 'Enter your age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Gender Dropdown (Required)
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender *',
                border: OutlineInputBorder(),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue ?? 'Other';
                });
              },
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
            ),
            const SizedBox(height: 16),

            // Major (Required)
            TextField(
              controller: _majorController,
              decoration: const InputDecoration(
                labelText: 'Enter your major... *',
                hintText: 'What is your major?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // City (Optional)
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                hintText: 'Enter your city',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Pronouns (Required)
            DropdownButtonFormField<String>(
              value: _selectedPronouns.isEmpty ? null : _selectedPronouns,
              hint: const Text('Select your pronouns'),
              decoration: const InputDecoration(
                labelText: 'Pronouns *',
                border: OutlineInputBorder(),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPronouns = newValue ?? '';
                });
              },
              items: const [
                DropdownMenuItem(value: 'He/Him', child: Text('He/Him')),
                DropdownMenuItem(value: 'She/Her', child: Text('She/Her')),
                DropdownMenuItem(value: 'They/Them', child: Text('They/Them')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
            ),
            const SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
