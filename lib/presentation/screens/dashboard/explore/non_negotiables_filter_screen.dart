import 'package:flutter/material.dart';

class NonNegotiablesFilterScreen extends StatefulWidget {
  const NonNegotiablesFilterScreen({super.key});

  @override
  _NonNegotiablesFilterScreenState createState() =>
      _NonNegotiablesFilterScreenState();
}

class _NonNegotiablesFilterScreenState extends State<NonNegotiablesFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  final Set<String> selectedGenders = {};

  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();

  final List<String> allInterests = [
    'Animals', 'Music', 'Sports', 'Outdoor activities', 'Dancing', 'Yoga',
    'Health', 'Gym & Fitness', 'Art', 'Gaming', 'Writing', 'Books', 'Movies',
    'Gardening', 'Cooking', 'Space', 'Science', 'Design', 'Food', 'Camping',
    'Photography', 'Fashion', 'Comedy', 'Politics', 'News', 'Technology',
    'Entertainment', 'Architecture', 'Business'
  ];

  final Set<String> mustHaveHobbies = {};
  final Set<String> mustNotHaveHobbies = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    minAgeController.dispose();
    maxAgeController.dispose();
    super.dispose();
  }

  // ONLY A FILTER, NOT SAVING THESE TO FIREBASE
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() != true) return;

    final int? minAge = int.tryParse(minAgeController.text);
    final int? maxAge = int.tryParse(maxAgeController.text);
    if (minAge != null && maxAge != null) {
      if (minAge > maxAge) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid age range.')),
        );
        return;
      }
    }
    final Map<String, dynamic> nonNegotiablesData = {
      'genderPreferences': selectedGenders.toList(),
      'ageRange': {
        'min': minAge,
        'max': maxAge,
      },
      'mustHaveHobbies': mustHaveHobbies.toList(),
      'mustNotHaveHobbies': mustNotHaveHobbies.toList(),
    };

    try {
      Navigator.of(context).pop();
    } catch (e) {

    }
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender Preferences:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              selected: selectedGenders.contains('Man'),
              label: Text("Man",
                style: TextStyle(
                  color: selectedGenders.contains('Man') ? Color(0xFF2C519C) : Color(0xFF2C519C),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedGenders.add("Man");
                  } else {
                    selectedGenders.remove("Man");
                  }
                });
              },
              selectedColor: Theme.of(context).colorScheme.tertiary,
              backgroundColor: Color(0xFFE7EFEE),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            ChoiceChip(
              selected: selectedGenders.contains('Woman'),
              label: Text("Woman",
                style: TextStyle(
                  color: selectedGenders.contains('Woman') ? Color(0xFF2C519C) : Color(0xFF2C519C),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedGenders.add("Woman");
                  } else {
                    selectedGenders.remove("Woman");
                  }
                });
              },
              selectedColor: Theme.of(context).colorScheme.tertiary,
              backgroundColor: Color(0xFFE7EFEE),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ]
        )
      ],
    );
  }

  Widget _buildAgeRangeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Desired Age Range:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: minAgeController,
          decoration: const InputDecoration(labelText: 'Minimum Age'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (int.tryParse(value) == null) return 'Enter a valid number';
              return null;
            }
            return null;
          },
        ),
        TextFormField(
          controller: maxAgeController,
          decoration: const InputDecoration(labelText: 'Maximum Age'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (int.tryParse(value) == null) return 'Enter a valid number';
              return null;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHobbiesSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hobbies:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: allInterests.map((interest) {
                final isSelected = mustHaveHobbies.contains(interest);
                return ChoiceChip(
                  label: Text(
                    interest,
                    style: TextStyle(
                      color: isSelected ? Color(0xFF2C519C) : Color(0xFF2C519C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        mustHaveHobbies.add(interest);
                      } else {
                        mustHaveHobbies.remove(interest);
                      }
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.tertiary,
                  backgroundColor: Color(0xFFE7EFEE),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
          ),
          const Text(
            'Must not have Hobbies:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: allInterests.map((interest) {
                final isSelected = mustNotHaveHobbies.contains(interest);
                return ChoiceChip(
                  checkmarkColor: Colors.white,
                  label: Text(
                    interest,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF2C519C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        mustNotHaveHobbies.add(interest);
                      } else {
                        mustNotHaveHobbies.remove(interest);
                      }
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.errorContainer,
                  backgroundColor: Color(0xFFE7EFEE),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter by Non-Negotiables'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGenderSelection(),
              const SizedBox(height: 20),
              _buildAgeRangeFields(),
              const SizedBox(height: 20),
              _buildHobbiesSelection(),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Filter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
