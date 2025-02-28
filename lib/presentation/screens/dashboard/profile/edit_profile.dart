import 'dart:typed_data';
import 'package:datingapp/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  // final TextEditingController ageController = TextEditingController();
  // might want to do age through drop down instead later
  final TextEditingController bioController = TextEditingController();

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
                      _image != null ? 
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundImage: MemoryImage(_image!),
                        ) : 
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                        ),
                      Positioned(
                        bottom: 0,
                        left: MediaQuery.of(context).size.width * 0.27,
                        child: IconButton(
                          iconSize: MediaQuery.of(context).size.width * 0.08,
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo)
                      ),
                      )
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                    child: Row(children: [
                      Expanded(child: Text("First Name: ")),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
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
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                      child: Row(children: [
                      Expanded(child: Text("Last Name: ")),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
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
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                      child: Row(children: [
                        Expanded(child: Text("Age: ")),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            hintText: "current age")
                          )
                        )
                      ])
                  ),
                  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                      child: Row(children: [
                        Expanded(child: Text("Bio: ")),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
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
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => {}, // save function
                  child: Text("Save Changes"),
                ),
              ),
            ),
          ],
        )
    );
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
}