import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditTraitsScreen extends StatefulWidget {
  const EditTraitsScreen({super.key});

  @override
  State<EditTraitsScreen> createState() => _EditTraitsScreenState();
}

class _EditTraitsScreenState extends State<EditTraitsScreen> {
  bool _loading = true;

  final Map<String, int> _personalTraits = {
    "I enjoy socializing and being around people.": 0,
    "Having a family is a top priority for me.": 0,
    "I like an active lifestyle with lots of physical activity.": 0,
    "I tend to stay calm and steady, even under pressure.": 0,
    "I love trying new things and taking risks.": 0,
  };

  final Map<String, int> _partnerPreferences = {
    "I want someone who is outgoing and talkative.": 0,
    "I'm looking for someone who values building a family.": 0,
    "I'd like a partner who enjoys staying active and fit.": 0,
    "I prefer someone who is emotionally expressive.": 0,
    "I want a partner who is spontaneous and adventurous.": 0,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedTraits();
  }

  Future<void> _loadSavedTraits() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      final data = snapshot.data();

      if (data != null) {
        Map<String, dynamic> savedPersonal = Map<String, dynamic>.from(data['personalTraits'] ?? {});
        Map<String, dynamic> savedPartner = Map<String, dynamic>.from(data['partnerPreferences'] ?? {});

        savedPersonal.forEach((key, value) {
          if (_personalTraits.containsKey(key)) {
            _personalTraits[key] = value;
          }
        });
        savedPartner.forEach((key, value) {
          if (_partnerPreferences.containsKey(key)) {
            _partnerPreferences[key] = value;
          }
        });
      }
    } catch (e) {
      print("Failed to load traits: $e");
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _savePreferences() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        'personalTraits': _personalTraits,
        'partnerPreferences': _partnerPreferences,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences saved successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Failed to save preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save preferences")),
      );
    }
  }

  Widget _buildSlider(String label, Map<String, int> targetMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            const Text("-5"),
            Expanded(
              child: Slider(
                min: -5,
                max: 5,
                divisions: 10,
                value: targetMap[label]!.toDouble(),
                label: targetMap[label].toString(),
                onChanged: (val) {
                  setState(() {
                    targetMap[label] = val.toInt();
                  });
                },
              ),
            ),
            const Text("5"),
          ],
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Compatibility Preferences"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("About You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._personalTraits.keys.map((q) => _buildSlider(q, _personalTraits)),

                    const SizedBox(height: 20),
                    const Text("Your Ideal Partner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._partnerPreferences.keys.map((q) => _buildSlider(q, _partnerPreferences)),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _savePreferences,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C519C)),
                        child: const Text("Save Preferences"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
