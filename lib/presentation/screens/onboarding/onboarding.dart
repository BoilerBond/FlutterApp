import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:datingapp/utils/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String? _selectedGender;
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
    if (majorController.text.trim().isEmpty) {
      _errors['major'] = 'Major is required';
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
      'major': majorController.text,
      'gender': _selectedGender,
    });

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
                      errorText: _formSubmitted && _errors.containsKey('firstName')
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
                      errorText: _formSubmitted && _errors.containsKey('lastName')
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
            Row(
              children: [
                const Expanded(child: Text("Major:")),
                SizedBox(
                  width: width * 0.4,
                  child: TextField(
                    controller: majorController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your major",
                      errorText: _formSubmitted && _errors.containsKey('major')
                          ? _errors['major']
                          : null,
                    ),
                  ),
                ),
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
                    items: ['Male', 'Female', 'Other'].map((gender) {
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
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
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
                    onPressed: _saving ? null : _saveBioAndContinue, // Disable button while saving
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
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final List<String> _allInterests = [
    'Animals', 'Music', 'Sports', 'Outdoor activities', 'Dancing', 'Yoga',
    'Health', 'Gym & Fitness', 'Art', 'Gaming', 'Writing', 'Books',
    'Movies', 'Space', 'Science', 'Design', 'Food', 'Camping',
    'Photography', 'Fashion', 'Comedy', 'Politics', 'News',
    'Technology', 'Entertainment', 'Architecture', 'Business'
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
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
        'interests': _selectedInterests.toList(),
      });
      Navigator.of(context).push(_createRoute(Step6()));

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
                    "3. Your interests",
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
                            color: isSelected ? Colors.transparent : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (selected) => _onInterestSelected(selected, interest),
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


class Step6 extends StatefulWidget {
  const Step6({super.key});

  @override
  State<Step6> createState() => _Step6State();
}

class _Step6State extends State<Step6> {
  Uint8List? _image;
  bool _uploading = false;
  String? _imageURL;

  void selectImage() async {
    XFile img = await pickImage(ImageSource.gallery);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: img.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: const Color.fromARGB(255, 34, 122, 255),
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(
          title: 'Crop your image',
        ),
      ],
    );
    if (croppedFile == null) return; // User canceled cropping

    Uint8List imageBytes = await croppedFile.readAsBytes();
    setState(() {
      _image = imageBytes;
    });
    await _uploadImage(_image!);
  }

  Future<void> _uploadImage(Uint8List image) async {
    setState(() {
      _uploading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User is not logged in");
        return;
      }
      print("Uploading image for user ${user.uid}");

      // get firebase storage reference with user id
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("profile_pictures")
          .child("${user.uid}.jpg");

      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageURL = downloadUrl;
        _uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile picture uploaded successfully!")),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        'profilePicture': downloadUrl,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image")),
      );
    } finally {
      setState(() {
        _uploading = false;
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
                    onPressed: () =>
                        {Navigator.pushReplacementNamed(context, "/")},
                    child: Text("Finish")),
              ),
            ),
          ),
        ]));
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
