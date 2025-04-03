import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/entity/app_user.dart';

class NonNegotiablesFormScreen extends StatefulWidget {
  const NonNegotiablesFormScreen({super.key});

  @override
  _NonNegotiablesFormScreenState createState() =>
      _NonNegotiablesFormScreenState();
}

class _NonNegotiablesFormScreenState extends State<NonNegotiablesFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final Set<String> selectedGenders = {};

  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController maxAgeController = TextEditingController();

  final List<String> availableHobbies = [
    'Animals', 'Music', 'Sports', 'Outdoor activities', 'Dancing', 'Yoga',
    'Health', 'Gym & Fitness', 'Art', 'Gaming', 'Writing', 'Books',
    'Movies', 'Space', 'Science', 'Design', 'Food', 'Camping',
    'Photography', 'Fashion', 'Comedy', 'Politics', 'News',
    'Technology', 'Entertainment', 'Architecture', 'Business'
  ];
  final Set<String> mustHaveHobbies = {};
  final Set<String> mustNotHaveHobbies = {};

  @override
  void initState() {
    super.initState();
    _loadNonNegotiables();
  }

  @override
  void dispose() {
    minAgeController.dispose();
    maxAgeController.dispose();
    super.dispose();
  }

  Future<void> _loadNonNegotiables() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      AppUser userProfile = await AppUser.getById(currentUser.uid);
      final nonNegotiables = userProfile.nonNegotiables;
      if (nonNegotiables.isNotEmpty) {
        if (nonNegotiables.containsKey('genderPreferences')) {
          final genders = nonNegotiables['genderPreferences'] as List<dynamic>;
          setState(() {
            selectedGenders.clear();
            for (var gender in genders) {
              selectedGenders.add(gender.toString());
            }
          });
        }
        if (nonNegotiables.containsKey('ageRange')) {
          final ageRange =
              nonNegotiables['ageRange'] as Map<String, dynamic>;
          if (ageRange.containsKey('min') &&
              ageRange['min'] != null) {
            minAgeController.text = ageRange['min'].toString();
          }
          if (ageRange.containsKey('max') &&
              ageRange['max'] != null) {
            maxAgeController.text = ageRange['max'].toString();
          }
        }
        if (nonNegotiables.containsKey('mustHaveHobbies')) {
          final mustHave = nonNegotiables['mustHaveHobbies'] as List<dynamic>;
          setState(() {
            mustHaveHobbies.clear();
            for (var hobby in mustHave) {
              mustHaveHobbies.add(hobby.toString());
            }
          });
        }
        if (nonNegotiables.containsKey('mustNotHaveHobbies')) {
          final mustNotHave =
              nonNegotiables['mustNotHaveHobbies'] as List<dynamic>;
          setState(() {
            mustNotHaveHobbies.clear();
            for (var hobby in mustNotHave) {
              mustNotHaveHobbies.add(hobby.toString());
            }
          });
        }
      }
    } catch (e) {
      print("Error loading non-negotiables: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading non-negotiables: $e')),
      );
    }
  }

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

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated.')),
      );
      return;
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
      AppUser userProfile = await AppUser.getById(currentUser.uid);
      userProfile.nonNegotiables = nonNegotiablesData;
      await userProfile.save(id: currentUser.uid, merge: true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Non-negotiables updated successfully.')),
      );
      Navigator.of(context).pop(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Gender Preferences:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        CheckboxListTile(
          title: const Text('Man'),
          value: selectedGenders.contains('man'),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedGenders.add('man');
              } else {
                selectedGenders.remove('man');
              }
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Woman'),
          value: selectedGenders.contains('woman'),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedGenders.add('woman');
              } else {
                selectedGenders.remove('woman');
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildAgeRangeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Desired Age Range:',
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
          'Select Must-Have Hobbies:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...availableHobbies.map((hobby) => CheckboxListTile(
              title: Text(hobby),
              value: mustHaveHobbies.contains(hobby),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    mustHaveHobbies.add(hobby);
                  } else {
                    mustHaveHobbies.remove(hobby);
                  }
                });
              },
            )),
        const SizedBox(height: 20),
        const Text(
          'Select Hobbies That Must Not Be Present:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...availableHobbies.map((hobby) => CheckboxListTile(
              title: Text(hobby),
              value: mustNotHaveHobbies.contains(hobby),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    mustNotHaveHobbies.add(hobby);
                  } else {
                    mustNotHaveHobbies.remove(hobby);
                  }
                });
              },
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Non-Negotiables'),
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
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Non-Negotiables'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
