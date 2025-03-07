import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditDisplayedInterests extends StatefulWidget {
  const EditDisplayedInterests({Key? key}) : super(key: key);

  @override
  State<EditDisplayedInterests> createState() => _EditDisplayedInterestsState();
}

class _EditDisplayedInterestsState extends State<EditDisplayedInterests> {
  final List<String> _allInterests = [
    'Animals', 'Music', 'Sports', 'Outdoor activities', 'Dancing', 'Yoga',
    'Health', 'Gym & Fitness', 'Art', 'Gaming', 'Writing', 'Books',
    'Movies', 'Space', 'Science', 'Design', 'Food', 'Camping',
    'Photography', 'Fashion', 'Comedy', 'Politics', 'News',
    'Technology', 'Entertainment', 'Architecture', 'Business'
  ];

  Map<String, bool> selectedMap = {};
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    for (var interest in _allInterests) {
      selectedMap[interest] = false;
    }
    _loadInterestsFromFirestore();
  }

  Future<void> _loadInterestsFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        if (doc.exists && doc.data() != null && doc.get("interests") != null) {
          List<dynamic> interests = doc.get("interests");
          setState(() {
            // Mark the previously saved interests as selected.
            for (var interest in interests) {
              if (selectedMap.containsKey(interest)) {
                selectedMap[interest] = true;
              }
            }
          });
        }
      } catch (e) {
        print("Error loading interests: $e");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onInterestSelected(bool selected, String interest) {
    setState(() {
      selectedMap[interest] = selected;
    });
  }

  Future<void> saveChangesToFirebase() async {
    setState(() {
      _isSaving = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      List<String> selectedInterests = selectedMap.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({'interests': selectedInterests});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interests updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to save interests: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving interests: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Displayed Interests")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Displayed Interests"),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _allInterests.length,
                    itemBuilder: (context, index) {
                      final interest = _allInterests[index];
                      final isSelected = selectedMap[interest] ?? false;
                      return CheckboxListTile(
                        title: Text(interest),
                        value: isSelected,
                        onChanged: (bool? value) {
                          _onInterestSelected(value ?? false, interest);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveChangesToFirebase,
                      child: const Text("Modify"),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
