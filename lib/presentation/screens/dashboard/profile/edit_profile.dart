import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:datingapp/data/constants/constants.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_bio.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_interests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/utils/image_helper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  Uint8List? _image;
  String? _imageURL = "";
  bool isLoading = true;
  AppUser? appUser;

  Future<void> getProfile() async {
    if (currentUser != null) {
      final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
      final user = AppUser.fromSnapshot(userSnapshot);
      setState(() {
        _imageURL = user.profilePictureURL;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchUserData();
    getProfile();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageContainer = TextEditingController();
  // final TextEditingController ageController = TextEditingController();
  // might want to do age through drop down instead later
  final TextEditingController bioController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  int? selectedAge;
  final TextEditingController majorController = TextEditingController();

  void selectImage() async {
    Uint8List? imageBytes = await ImageHelper().selectImage();
    if (imageBytes != null) {
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> _uploadImage(Uint8List image) async {
    String downloadUrl = await ImageHelper().uploadImage(image);

    setState(() {
      _imageURL = downloadUrl;
    });
  }

  Future<void> _handleProfileSubmit(BuildContext context) async {
    if (_image != null) {
      await _uploadImage(_image!);
      _image = null;
    }

    final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
    final user = AppUser.fromSnapshot(userSnapshot);

    if (firstNameController.text.isNotEmpty) {
      user.firstName = firstNameController.text;
    }

    if (lastNameController.text.isNotEmpty) {
      user.lastName = lastNameController.text;
    }

    if (selectedAge != null && selectedAge! > 0 && selectedAge! <= 100) {
      user.age = selectedAge!;
    }

    if (majorController.text.isNotEmpty) {
      user.major = majorController.text;
    }

    if (bioController.text.isNotEmpty) {
      user.bio = bioController.text;
    }

    if (facebookController.text.isNotEmpty) {
      user.facebookLink = facebookController.text;
    }

    if (instagramController.text.isNotEmpty) {
      user.instagramLink = instagramController.text;
    }

    await db.collection("users").doc(user.uid).update(user.toMap());
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        appUser = AppUser.fromSnapshot(docSnapshot);
        firstNameController.text = appUser?.firstName ?? "";
        lastNameController.text = appUser?.lastName ?? "";
        bioController.text = appUser?.bio ?? "";
        majorController.text = appUser?.major ?? "";
        instagramController.text = appUser?.instagramLink ?? "";
        facebookController.text = appUser?.facebookLink ?? "";
        selectedAge =
            (appUser?.age != null && appUser!.age > 0 && appUser!.age <= 100)
                ? appUser!.age
                : 18;
        isLoading = false;
        _imageURL = appUser?.profilePictureURL;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _showSocialMediaDialog(
      {required String title,
      required TextEditingController controller,
      required String firestoreField}) async {
    TextEditingController tempController =
        TextEditingController(text: controller.text);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter $title Link"),
          content: TextField(
            controller: tempController,
            decoration: const InputDecoration(
              hintText: "https://www.website.com/yourprofile",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({firestoreField: tempController.text.trim()});

                setState(() {
                  controller.text = tempController.text.trim();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$title link updated successfully!")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                      Stack(children: [
                        (_image != null || _imageURL!.isNotEmpty)
                            ? CircleAvatar(radius: MediaQuery.of(context).size.width * 0.2, backgroundImage: _image != null ? MemoryImage(_image!) : NetworkImage(_imageURL!))
                            : CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.2,
                                backgroundImage: NetworkImage(Constants.defaultProfilePictureURL),
                              )
                      ]),
                      Padding(padding: EdgeInsets.only(bottom: 16), child: TextButton(onPressed: selectImage, child: Text("Edit Profile Picture"))),
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

                  // display current bio and edit button
                  if (appUser != null)
                    ListTile(
                      title: const Text("Bio"),
                      subtitle: Text(appUser!.bio),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final newBio = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditBioScreen(initialBio: appUser!.bio),
                            ),
                          );

                          if (newBio != null && newBio != appUser!.bio) {
                            setState(() {
                              appUser = AppUser(
                                uid: appUser!.uid,
                                firstName: appUser!.firstName,
                                lastName: appUser!.lastName,
                                bio: newBio,
                                major: appUser!.major,
                                instagramLink: appUser!.instagramLink,
                                facebookLink: appUser!.facebookLink,
                                profilePictureURL: appUser!.profilePictureURL,
                                age: appUser!.age,
                              );
                              bioController.text = newBio;
                            });
                          }
                        },
                      ),
                    ),

                  _buildActionButton("Edit my interests", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditDisplayedInterests()),
                    );
                  }),
                  const SizedBox(height: 10),

                  _buildActionButton("Edit onboarding information", () {}),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButtonWithIcon(
                          Icons.camera_alt,
                          "Link Instagram",
                          () => _showSocialMediaDialog(
                              title: "Instagram",
                              controller: instagramController,
                              firestoreField: "instagramLink"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildActionButtonWithIcon(
                          Icons.facebook,
                          "Link Facebook",
                          () => _showSocialMediaDialog(
                              title: "Facebook",
                              controller: facebookController,
                              firestoreField: "facebookLink"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _handleProfileSubmit(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E77DF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isMultiline = false}) {
    return TextFormField(
      controller: controller,
      maxLines: isMultiline ? 5 : 1,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildActionButtonWithIcon(
      IconData icon, String text, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Theme.of(context).colorScheme.outlineVariant),
      label: Text(text, style: const TextStyle(fontSize: 16)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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