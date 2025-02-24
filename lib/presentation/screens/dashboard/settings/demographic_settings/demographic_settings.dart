import 'package:flutter/material.dart';

class _DemographicSettingsPage extends State<DemographicSettings> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  // Dropdown for gender
  String _selectedGender = 'Other';
  String _selectedPronouns = '';

  void _handleSubmit() {
    if (_nameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
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
            // Name (Required)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your first name... *',
                hintText: 'What is your first name?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
              
            // Name (Required)
            TextField(
              controller: _nameController,
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

            // Age (Required)
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter your major... *',
                hintText: 'Enter your major',
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

            DropdownButtonFormField<String>(
              value: _selectedGender.isEmpty ? null : _selectedGender,
              hint: const Text('Select your pronouns'),
              decoration: const InputDecoration(
                labelText: 'Pronouns *',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'He/Him', child: Text('He/Him')),
                DropdownMenuItem(value: 'She/Her', child: Text('She/Her')),
                DropdownMenuItem(value: 'They/Them', child: Text('They/Them')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue ?? '';
                });
              },
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

class DemographicSettings extends StatefulWidget {
  const DemographicSettings({Key? key}) : super(key: key);

  @override
  State<DemographicSettings> createState() => _DemographicSettingsPage();
}
