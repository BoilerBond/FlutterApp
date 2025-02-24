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

  void _handleSubmit() {
    if (_nameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty ||
        _selectedGender.isEmpty ||
        _cityController.text.trim().isEmpty) {
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
                labelText: 'Name *',
                hintText: 'Enter your full name',
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

            // Phone (Optional)
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your phone number (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // City (Required)
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City *',
                hintText: 'Enter your city',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // State (Optional)
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'State',
                hintText: 'Enter your state (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Submit'),
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
