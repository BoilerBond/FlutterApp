import "package:flutter/material.dart";
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:datingapp/utils/image_helper.dart';
import 'package:datingapp/data/constants/majors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController spotifyController = TextEditingController();
  final SuggestionsController<Map<String, String>> _suggestionsController =
      SuggestionsController<Map<String, String>>();

  String? _selectedGender;
  String? _selectedMajor;
  String? _selectedCollege;
  Map<String, String> _errors = {};
  bool _formSubmitted = false;

  void saveProfile() async {
    setState(() {
      _formSubmitted = true;
      _errors = {};
    });

    // Validate all fields
    if (firstNameController.text.trim().isEmpty) {
      _errors['firstName'] = 'First name is required';
    }
    if (lastNameController.text.trim().isEmpty) {
      _errors['lastName'] = 'Last name is required';
    }
    if (ageController.text.trim().isEmpty) {
      _errors['age'] = 'Age is required';
    } else {
      try {
        int age = int.parse(ageController.text.trim());
        if (age < 18 || age > 100) {
          _errors['age'] = 'Enter a valid age (18-100)';
        }
      } catch (e) {
        _errors['age'] = 'Enter a valid number';
      }
    }
    if (_selectedMajor == null || _selectedMajor!.isEmpty) {
      _errors['major'] = 'Major is required';
    }
    if (_selectedCollege == null || _selectedCollege!.isEmpty) {
      _errors['college'] = 'College is required';
    }
    if (_selectedGender == null) {
      _errors['gender'] = 'Gender is required';
    }

    // Check if there are any errors
    if (_errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'age': int.parse(ageController.text),
      'major': _selectedMajor,
      'college': _selectedCollege,
      'gender': _selectedGender,
      'spotifyUsername': spotifyController.text.trim(),
    }, SetOptions(merge: true));

    Navigator.of(context).push(_createRoute(Step2()));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('BBond')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Onboarding", style: TextStyle(fontSize: 30)),
            const Divider(),
            const SizedBox(height: 20),
            // First Name
            Row(
              children: [
                const Expanded(child: Text("First Name:")),
                SizedBox(
                  width: width * 0.4,
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your first name",
                      errorText:
                          _formSubmitted && _errors.containsKey('firstName')
                              ? _errors['firstName']
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Last Name
            Row(
              children: [
                const Expanded(child: Text("Last Name:")),
                SizedBox(
                  width: width * 0.4,
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your last name",
                      errorText:
                          _formSubmitted && _errors.containsKey('lastName')
                              ? _errors['lastName']
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Age
            Row(
              children: [
                const Expanded(child: Text("Age:")),
                SizedBox(
                  width: width * 0.4,
                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your age",
                      errorText: _formSubmitted && _errors.containsKey('age')
                          ? _errors['age']
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Major
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text("Major:")),
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
                            autofocus: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Search for your major",
                              errorText:
                                  _formSubmitted && _errors.containsKey('major')
                                      ? _errors['major']
                                      : null,
                            ),
                          );
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion['major']!),
                            subtitle: Text(suggestion['college']!),
                          );
                        },
                        onSelected: (suggestion) {
                          setState(() {
                            _selectedMajor = suggestion['major'];
                            _selectedCollege = suggestion['college'];
                            majorController
                                .clear(); 
                          });
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
                // display major and college
                if (_selectedMajor != null && _selectedCollege != null)
                  Container(
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
                                'Selected Major:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(_selectedMajor!),
                              const SizedBox(height: 4),
                              Text(
                                'College:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(_selectedCollege!),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedMajor = null;
                              _selectedCollege = null;
                            });
                          },
                          tooltip: 'Clear selection',
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 20),
            // Gender Dropdown
            Row(
              children: [
                const Expanded(child: Text("Gender:")),
                SizedBox(
                  width: width * 0.4,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      errorText: _formSubmitted && _errors.containsKey('gender')
                          ? _errors['gender']
                          : null,
                    ),
                    items: ['Man', 'Woman', 'Other'].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Spotify Username
            Row(
              children: [
                const Expanded(child: Text("Spotify Username:")),
                SizedBox(
                  width: width * 0.4,
                  child: TextField(
                    controller: spotifyController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your Spotify username",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Save Changes Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: saveProfile,
                child: const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final TextEditingController _bioController = TextEditingController();
  bool _saving = false;
  Future<void> _saveBioAndContinue() async {
    setState(() {
      _saving = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to continue.")),
      );
      setState(() {
        _saving = false;
      });
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "bio": _bioController.text.trim(),
      });

      print("bio updated for ${user.uid}");

      Navigator.of(context).push(_createRoute(Step3()));
    } catch (e) {
      print("firestore error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save bio. Try again.")),
      );
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('BBond')),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Text("Onboarding", style: TextStyle(fontSize: 30))),
          Divider(
              indent: MediaQuery.of(context).size.width * 0.04,
              endIndent: MediaQuery.of(context).size.width * 0.04),
          Expanded(
              child: Center(
                  child: Column(children: [
            Text("2. Tell us about yourself!", style: TextStyle(fontSize: 20)),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _bioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your bio...",
                ),
                maxLength: 150,
                maxLines: 3,
              ),
            ),
          ]))),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.1,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffCDFCFF),
                      side: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _saving
                        ? null
                        : _saveBioAndContinue, // Disable button while saving
                    child: _saving
                        ? CircularProgressIndicator()
                        : Icon(Icons.arrow_forward)),
              ),
            ),
          ),
        ]));
  }
}

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final TextEditingController _cmController = TextEditingController();
  final TextEditingController _ftController = TextEditingController();
  final TextEditingController _inController = TextEditingController();
  bool _saving = false;
  bool _showHeight = false;
  bool _useCm = true;

  Future<void> _saveHeightAndContinue() async {
    setState(() {
      _saving = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to continue.")),
      );
      setState(() {
        _saving = false;
      });
      return;
    }

    try {
      double heightValue;
      if (_useCm) {
        heightValue = double.tryParse(_cmController.text.trim()) ?? -1;
        if (heightValue < 50 || heightValue > 300) {
          throw Exception(
              "Invalid height. Please enter a value between 50cm and 300cm.");
        }
      } else {
        double feet = double.tryParse(_ftController.text.trim()) ?? -1;
        double inches = double.tryParse(_inController.text.trim()) ?? -1;
        if (feet < 1 || feet > 8 || inches < 0 || inches >= 12) {
          throw Exception("Invalid height. Please review the entered value.");
        }
        heightValue = (feet * 30.48) + (inches * 2.54);
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "showHeight": _showHeight,
        "heightUnit": _useCm ? "cm" : "ft",
        "heightValue": heightValue,
      });

      print("Height updated for ${user.uid}");
      Navigator.of(context).push(_createRoute(Step4()));
    } catch (e) {
      print("Firestore error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BBond')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Text("Onboarding", style: TextStyle(fontSize: 30)),
            ),
            Divider(
              indent: MediaQuery.of(context).size.width * 0.04,
              endIndent: MediaQuery.of(context).size.width * 0.04,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "3. Would you like to attach your height to your profile?",
                      style: TextStyle(fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Adding a height to your profile is optional. You can opt in or out from displaying your height in your profile at any moment after completing onboarding.",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  SwitchListTile(
                    title: Text("Display height on profile"),
                    value: _showHeight,
                    onChanged: (bool value) {
                      setState(() {
                        _showHeight = value;
                      });
                    },
                  ),
                  if (_showHeight) ...[
                    if (_useCm)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                          controller: _cmController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Height (cm)",
                            suffixText: "cm",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _ftController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "ft",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 16),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _inController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "in",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    Text("Select measurement unit:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("cm"),
                        Switch(
                          value: _useCm,
                          onChanged: (bool value) {
                            setState(() {
                              _useCm = value;
                            });
                          },
                        ),
                        Text("ft/in"),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffCDFCFF),
                      side: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _saving ? null : _saveHeightAndContinue,
                    child: _saving
                        ? CircularProgressIndicator()
                        : Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Step4 extends StatefulWidget {
  const Step4({super.key});

  @override
  State<Step4> createState() => _Step4State();
}

class _Step4State extends State<Step4> {
  final List<String> _allInterests = [
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

  final Set<String> _selectedInterests = {};

  void _onInterestSelected(bool selected, String interest) {
    setState(() {
      if (selected) {
        _selectedInterests.add(interest);
      } else {
        _selectedInterests.remove(interest);
      }
    });
  }

  Future<void> saveInterests() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        'displayedInterests': _selectedInterests.toList(),
      });
      Navigator.of(context).push(_createRoute(Step5()));
    } catch (e) {
      print("Failed to save interests: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save interests")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('BBond')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header
          Padding(
            padding: EdgeInsets.only(left: width * 0.05, top: 16),
            child: const Text(
              "Onboarding",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Divider(
            indent: width * 0.04,
            endIndent: width * 0.04,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "4. Your interests",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Select your interests",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _allInterests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: isSelected,
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xffCDFCFF),
                        checkmarkColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (selected) =>
                            _onInterestSelected(selected, interest),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Next Button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: width * 0.3,
                height: width * 0.1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xffCDFCFF),
                    side: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: saveInterests,
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Step5 extends StatefulWidget {
  const Step5({super.key});

  @override
  State<Step5> createState() => _Step5State();
}

class _Step5State extends State<Step5> {
  final TextEditingController studySpotController = TextEditingController();
  String? _selectedDiningCourt;
  final TextEditingController petPeeveController = TextEditingController();
  final TextEditingController bestMemoryController = TextEditingController();

  Map<String, String> _errors = {};
  bool _formSubmitted = false;
  bool _isSaving = false;

  Future<void> _savePurdueInfo() async {
    setState(() {
      _formSubmitted = true;
      _errors = {};
    });

    if (studySpotController.text.trim().isEmpty) {
      _errors['studySpot'] = 'Study spot is required';
    }
    if (_selectedDiningCourt == null) {
      _errors['diningCourt'] = 'Please select a dining court';
    }

    if (_errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix the errors in the form")),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        'favoriteStudySpot': studySpotController.text.trim(),
        'favoriteDiningCourt': _selectedDiningCourt,
        'purduePetPeeve': petPeeveController.text.trim(),
        'bestPurdueMemory': bestMemoryController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Purdue information saved successfully")),
      );
      Navigator.of(context).push(_createRoute(Step6()));
    } catch (e) {
      print("Error saving Purdue info: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save Purdue info: $e")),
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
    return Scaffold(
      appBar: AppBar(title: const Text("Step 5: Purdue Info")),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("4. Purdue-Specific Questions",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Favorite Study Spot
                  Row(
                    children: [
                      const Expanded(child: Text("Favorite Study Spot:")),
                      SizedBox(
                        width: width * 0.4,
                        child: TextField(
                          controller: studySpotController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "e.g., WALC, HSSE",
                            errorText: _formSubmitted &&
                                    _errors.containsKey('studySpot')
                                ? _errors['studySpot']
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Favorite Dining Court
                  Row(
                    children: [
                      const Expanded(child: Text("Best Dining Court:")),
                      SizedBox(
                        width: width * 0.4,
                        child: DropdownButtonFormField<String>(
                          value: _selectedDiningCourt,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            errorText: _formSubmitted &&
                                    _errors.containsKey('diningCourt')
                                ? _errors['diningCourt']
                                : null,
                          ),
                          hint: Text("Select dining court"),
                          isExpanded: true,
                          items: [
                            'Wiley',
                            'Earhart',
                            'Windsor',
                            'Ford',
                            'Hillenbrand'
                          ].map((court) {
                            return DropdownMenuItem(
                              value: court,
                              child: Text(court),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDiningCourt = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Biggest Purdue Pet Peeve
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Biggest Purdue Pet Peeve (optional):"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: petPeeveController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "What annoys you at Purdue?",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Best Purdue Memory
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Best Purdue Memory (optional):"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: bestMemoryController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Your favorite Purdue moment",
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Save Changes
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _savePurdueInfo,
                      child: const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class Step6 extends StatefulWidget {
  const Step6({super.key});

  @override
  State<Step6> createState() => _Step6State();
}

class _Step6State extends State<Step6> {
  Uint8List? _image;
  void selectImage() async {
    Uint8List? imageBytes = await ImageHelper().selectImage();
    if (imageBytes != null) {
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> _uploadImage(Uint8List image) async {
    await ImageHelper().uploadImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('BBond')),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Text("Onboarding", style: TextStyle(fontSize: 30))),
          Divider(
              indent: MediaQuery.of(context).size.width * 0.04,
              endIndent: MediaQuery.of(context).size.width * 0.04),
          Expanded(
              child: Center(
                  child: Column(children: [
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width * 0.03),
                child: Text("6. Upload Profile Picture",
                    style: TextStyle(fontSize: 24))),
            // upload profile picture section
            Stack(children: [
              _image != null
                  ? CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.3,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.3,
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    )
            ]),
            Padding(
                padding: EdgeInsets.all(16),
                child: TextButton(
                    onPressed: selectImage,
                    child: Text("Upload Profile Picture"))),
            Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffE7EFEE),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            "Your profile picture will be visible to every user on this app. + Terms of service warning")))),
          ]))),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.1,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffCDFCFF),
                      side: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (_image != null) {
                        await _uploadImage(_image!);
                      }
                      Navigator.of(context).push(_createRoute(Step7()));
                    },
                    child: Text("Next")),
              ),
            ),
          ),
        ]));
  }
}

class Step7 extends StatefulWidget {
  const Step7({super.key});

  @override
  State<Step7> createState() => _Step7State();
}

class _Step7State extends State<Step7> {
  // Personal traits ratings (-5 to 5)
  final Map<String, int> _personalTraits = {
    "I enjoy socializing and being around people.": 0,
    "Having a family is a top priority for me.": 0,
    "I like an active lifestyle with lots of physical activity.": 0,
    "I tend to stay calm and steady, even under pressure.": 0,
    "I love trying new things and taking risks.": 0,
  };

  // Partner preferences ratings (-5 to 5)
  final Map<String, int> _partnerPreferences = {
    "I want someone who is outgoing and talkative.": 0,
    "I'm looking for someone who values building a family.": 0,
    "I'd like a partner who enjoys staying active and fit.": 0,
    "I prefer someone who is emotionally expressive.": 0,
    "I want a partner who is spontaneous and adventurous.": 0,
  };

  Future<void> _savePreferencesAndFinish() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        'personalTraits': _personalTraits,
        'partnerPreferences': _partnerPreferences,
      });

      // Navigate to the dashboard or finish onboarding
      Navigator.pushReplacementNamed(context, "/");
    } catch (e) {
      print("Failed to save preferences: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save preferences")),
      );
    }
  }

  Widget _buildSlider(String question, Map<String, int> targetMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("-5", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Slider(
                min: -5,
                max: 5,
                divisions: 10,
                value: targetMap[question]!.toDouble(),
                label: targetMap[question].toString(),
                onChanged: (double value) {
                  setState(() {
                    targetMap[question] = value.toInt();
                  });
                },
              ),
            ),
            Text("5", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('BBond')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(left: width * 0.05, top: 16),
            child: const Text(
              "Onboarding",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Divider(
            indent: width * 0.04,
            endIndent: width * 0.04,
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tell us about yourself and what you're looking for",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),

                  const Text(
                    "About You",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Personal traits sliders
                  ..._personalTraits.keys.map(
                      (question) => _buildSlider(question, _personalTraits)),

                  SizedBox(height: 24),

                  const Text(
                    "What You're Looking For",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Partner preference sliders
                  ..._partnerPreferences.keys.map((question) =>
                      _buildSlider(question, _partnerPreferences)),
                ],
              ),
            ),
          ),

          // Finish Button
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: width * 0.3,
                height: width * 0.1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xffCDFCFF),
                    side: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _savePreferencesAndFinish,
                  child: const Text("Finish"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(StatefulWidget next) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => next,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      });
}
