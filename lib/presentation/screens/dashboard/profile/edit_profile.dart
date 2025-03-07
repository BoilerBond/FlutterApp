import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:datingapp/utils/image_picker.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_interests.dart';
import 'package:datingapp/data/entity/app_user.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  int? selectedAge;

  bool isLoading = true;
  AppUser? appUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // To get appUser for currentUser in firestore
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (docSnapshot.exists) {
      setState(() {
        appUser = AppUser.fromSnapshot(docSnapshot);
        firstNameController.text = appUser?.firstName ?? "";
        lastNameController.text = appUser?.lastName ?? "";
        bioController.text = appUser?.bio ?? "";
        majorController.text = appUser?.major ?? "";
              selectedAge = (appUser?.age != null && appUser!.age > 0 && appUser!.age <= 100)
          ? appUser!.age
          : 18; // Default
        isLoading = false;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  
  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'bio': bioController.text.trim(),
        'major': majorController.text.trim(),
        'age': selectedAge,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }

  
  void selectImage() async {
    XFile img = await pickImage(ImageSource.gallery);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: img.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: Theme.of(context).colorScheme.primaryContainer,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Crop your image'),
      ],
    );

    Uint8List? cf = await croppedFile?.readAsBytes();

    setState(() {
      _image = cf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: selectImage,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : NetworkImage(appUser?.profilePictureURL ??
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png") as ImageProvider,
                      backgroundColor: const Color(0xFFCDFCFF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: selectImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.edit, color: Color(0xFF5E77DF)),
                  ),
                  const SizedBox(height: 20),

                  
                  _buildTextField("First Name", firstNameController),
                  const SizedBox(height: 10),
                  _buildTextField("Last Name", lastNameController),
                  const SizedBox(height: 10),

                  
                  DropdownButtonFormField<int>(
                    value: selectedAge ?? 18,
                    decoration: _inputDecoration("Age"),
                    items: List.generate(100, (index) => index + 1)
                        .map((age) => DropdownMenuItem<int>(
                              value: age,
                              child: Text(age.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAge = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  _buildTextField("Major", majorController),
                  const SizedBox(height: 10),

                  _buildTextField("Biography", bioController, isMultiline: true),
                  const SizedBox(height: 20),

                  _buildActionButton("Edit my interests", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditDisplayedInterests()),
                    );
                  }),
                  const SizedBox(height: 10),

                  _buildActionButton("Edit onboarding information", () {
                    // TODO: Navigate to onboarding edit screen
                  }),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E77DF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isMultiline = false}) {
    return TextFormField(
      controller: controller,
      maxLines: isMultiline ? 5 : 1,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0XFFE7EFEE)),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
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
                      onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
