import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:datingapp/data/constants/majors.dart';

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
    final currentUser = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }
    AppUser userProfile = await AppUser.getById(currentUser.uid);

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
      print(nonNegotiablesData["genderPreferences"]);
      print(nonNegotiablesData["ageRange"]);
      print(nonNegotiablesData["mustHaveHobbies"]);
      final newData = {"nonNegotiablesFilter": nonNegotiablesData};
      await db
          .collection("users")
          .doc(userProfile.uid)
          .set(newData, SetOptions(merge: true));
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      return;
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ChoiceChip(
            selected: selectedGenders.contains('Man'),
            label: Text(
              "Man",
              style: TextStyle(
                color: selectedGenders.contains('Man')
                    ? Color(0xFF2C519C)
                    : Color(0xFF2C519C),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ChoiceChip(
            selected: selectedGenders.contains("Woman"),
            label: Text(
              "Woman",
              style: TextStyle(
                color: selectedGenders.contains("Woman")
                    ? Color(0xFF2C519C)
                    : Color(0xFF2C519C),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ])
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
              const SizedBox(height: 20),
              _buildMajorSelection(),
              const SizedBox(height: 20),
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
}
