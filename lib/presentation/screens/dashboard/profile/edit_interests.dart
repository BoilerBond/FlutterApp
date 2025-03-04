import 'package:flutter/material.dart';

class EditDisplayedInterests extends StatefulWidget {
  const EditDisplayedInterests({Key? key}) : super(key: key);

  @override
  State<EditDisplayedInterests> createState() => _EditDisplayedInterestsState();
}

class _EditDisplayedInterestsState extends State<EditDisplayedInterests> {
  final List<String> allInterests = [
    'Hiking',
    'Reading',
    'Gaming',
    'Cooking',
    'Music',
    'Movies',
  ];

  Map<String, bool> selectedMap = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // TODO: Load the user’s interests from Firestore once we have storage working
    // and update the selectedMap
    // selectedMap = loadInterestsFromFirebase();
    for (var interest in allInterests) {
      selectedMap[interest] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    itemCount: allInterests.length,
                    itemBuilder: (context, index) {
                      final interest = allInterests[index];
                      final isSelected = selectedMap[interest] ?? false;
                      return CheckboxListTile(
                        title: Text(interest),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedMap[interest] = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    // 3) The "Modify" (Save) button
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

  // TODO: Save the user’s interests to Firestore
  Future<void> saveChangesToFirebase() async {
    setState(() {
      _isSaving = true;
    });

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interests updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving interests: $e')),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }
}
