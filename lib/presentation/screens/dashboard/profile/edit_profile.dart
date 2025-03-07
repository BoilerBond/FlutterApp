import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_interests.dart';
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

  Future<void> getProfile() async {
    if (currentUser != null) {
      final userSnapshot = await db.collection("users")
          .doc(currentUser?.uid)
          .get();
      final user = AppUser.fromSnapshot(userSnapshot);
      setState(() {
        _imageURL = user.profilePictureURL;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getProfile();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  // final TextEditingController ageController = TextEditingController();
  // might want to do age through drop down instead later
  final TextEditingController bioController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile')),
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(children: [
                      Stack(
                          children: [
                            (_image != null || _imageURL!.isNotEmpty) ?
                            CircleAvatar(
                              radius: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.2,
                              backgroundImage: _image != null ? MemoryImage(_image!) : NetworkImage(_imageURL!)
                            ) :
                            CircleAvatar(
                              radius: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.2,
                              backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                            )
                          ]
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: TextButton(onPressed: selectImage,
                              child: Text("Edit Profile Picture"))
                      ),
                      Padding(
                          padding: EdgeInsets.all(MediaQuery
                              .of(context)
                              .size
                              .width * 0.1),
                          child: Row(children: [
                            Expanded(child: Text("First Name: ")),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                child: TextField(
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "current first name")
                                )
                            )
                          ])
                      ),
                      Padding(
                          padding: EdgeInsets.all(MediaQuery
                              .of(context)
                              .size
                              .width * 0.1),
                          child: Row(children: [
                            Expanded(child: Text("Last Name: ")),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                child: TextField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "current last name")
                                )
                            )
                          ])
                      ),
                      Padding(
                          padding: EdgeInsets.all(MediaQuery
                              .of(context)
                              .size
                              .width * 0.1),
                          child: Row(children: [
                            Expanded(child: Text("Age: ")),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                child: TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "current age")
                                )
                            )
                          ])
                      ),
                      Padding(
                          padding: EdgeInsets.all(MediaQuery
                              .of(context)
                              .size
                              .width * 0.1),
                          child: Row(children: [
                            Expanded(child: Text("Bio: ")),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                child: TextField(
                                    controller: bioController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "current bio"
                                    )
                                )
                            )
                          ])
                      )
                    ])
                )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .outlineVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_image != null) {
                      _uploadImage(_image!);
                      _image = null;
                    }
                    Navigator.pushReplacementNamed(context, "/profile");
                    }, // save function
                  child: Text("Save Changes"),
                ),
              ),
            ),
          ],
        )
    );
  }
}