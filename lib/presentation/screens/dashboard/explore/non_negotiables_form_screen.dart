import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../data/constants/majors.dart';

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
  final TextEditingController majorController = TextEditingController();

  final List<String> allInterests = [
    'Animals',
    'Music',
    'Sports',
    'Outdoor activities',
    'Dancing',
    'Yoga',
    'Health',
    'Gym & Fitness',
    'Art',
    'Gaming',
    'Writing',
    'Books',
    'Movies',
    'Gardening',
    'Cooking',
    'Space',
    'Science',
    'Design',
    'Food',
    'Camping',
    'Photography',
    'Fashion',
    'Comedy',
    'Politics',
    'News',
    'Technology',
    'Entertainment',
    'Architecture',
    'Business'
  ];

  final Set<String> mustHaveHobbies = {};
  final Set<String> mustNotHaveHobbies = {};
  final List<Map<String, String>> selectedMajors = [];

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
        if (nonNegotiables.containsKey('majors')) {
          final ms = nonNegotiables['majors'] as List<dynamic>;
          setState(() {
            selectedMajors.clear();
            for (Map<String, dynamic> m in ms) {
              Map<String, String> temp = {};
              temp["major"] = m["major"].toString();
              temp["college"] = m["college"].toString();
              selectedMajors.add(temp);
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
    final db = FirebaseFirestore.instance;
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
      'majors': selectedMajors,
    };

    try {
      AppUser userProfile = await AppUser.getById(currentUser.uid);
      userProfile.nonNegotiables = nonNegotiablesData;
      final newData = {"nonNegotiables": nonNegotiablesData};
      await db.collection("users").doc(userProfile.uid).set(newData, SetOptions(merge: true));

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
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  bool _isMajorSelected(Map<String, String> major) {
    return selectedMajors.any((element) =>
    element['major'] == major['major'] &&
        element['college'] == major['college']);
  }

  void _removeMajor(Map<String, String> major) {
    setState(() {
      selectedMajors.removeWhere((element) =>
      element['major'] == major['major'] &&
          element['college'] == major['college']);
    });
  }

  Widget _buildMajorSelection() {
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Major Preferences:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(child: Text("Add Major:")),
            SizedBox(
              width: width * 0.4,
              child: TypeAheadField<Map<String, String>>(
                suggestionsCallback: (pattern) {
                  // filter major list
                  return majorsList
                      .where((major) =>
                  major['major']!
                      .toLowerCase()
                      .contains(pattern.toLowerCase()) ||
                      major['college']!
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList();
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Search for major",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          focusNode.unfocus();
                        },
                      ),
                    ),
                  );
                },
                itemBuilder: (context, suggestion) {
                  final bool isAlreadySelected = _isMajorSelected(suggestion);
                  return ListTile(
                    title: Text(suggestion['major']!),
                    subtitle: Text(suggestion['college']!),
                    trailing: isAlreadySelected
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  );
                },
                onSelected: (suggestion) {
                  // If not already selected, add it
                  if (!_isMajorSelected(suggestion)) {
                    setState(() {
                      selectedMajors.add({
                        'major': suggestion['major']!,
                        'college': suggestion['college']!
                      });
                      majorController.clear();
                    });
                  }
                },
                emptyBuilder: (context) {
                  return const ListTile(
                    title: Text("No majors found"),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Display selected majors
        if (selectedMajors.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Majors:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 5),
              ...selectedMajors
                  .map((majorInfo) => Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            majorInfo['major']!,
                            style:
                            TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            majorInfo['college']!,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => _removeMajor(majorInfo),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Remove major',
                    ),
                  ],
                ),
              ))
                  .toList(),
            ],
          ),
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
              const SizedBox(height: 20),
              _buildMajorSelection(),
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
