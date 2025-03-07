import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditDisplayedInterests extends StatefulWidget {
  const EditDisplayedInterests({Key? key}) : super(key: key);

  @override
  State<EditDisplayedInterests> createState() => _EditDisplayedInterestsState();
}

class _EditDisplayedInterestsState extends State<EditDisplayedInterests> {
  final List<String> allInterests = [
    'Animals', 'Music', 'Sports', 'Outdoor activities', 'Dancing', 'Yoga',
    'Health', 'Gym & Fitness', 'Art', 'Gaming', 'Writing', 'Books', 'Movies',
    'Gardening', 'Cooking', 'Space', 'Science', 'Design', 'Food', 'Camping',
    'Photography', 'Fashion', 'Comedy', 'Politics', 'News', 'Technology',
    'Entertainment', 'Architecture', 'Business'
  ];

  Set<String> selectedInterests = {};
  bool _isSaving = false;
  bool _isLoading = true;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _loadUserInterests();
  }

  Future<void> _loadUserInterests() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        List<String> userInterests =
            List<String>.from(userDoc.get('displayedInterests') ?? []);

        setState(() {
          selectedInterests = userInterests.toSet();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading interests: $e");
      setState(() => _isLoading = false);
    }
  }

  // Firestore
  Future<void> saveChangesToFirebase() async {
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .update({'displayedInterests': selectedInterests.toList()});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interests updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving interests: $e')),
      );
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Displayed Interests")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: allInterests.map((interest) {
                        final isSelected = selectedInterests.contains(interest);
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
                                selectedInterests.add(interest);
                              } else {
                                selectedInterests.remove(interest);
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
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : saveChangesToFirebase,
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : const Text("Save Interests"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
