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
                          backgroundImage: NetworkImage("https://media.discordapp.net/attachments/1024471419544944680/1344451681085296782/d33mwsf-0dd81126-6d91-4b0d-905c-886a1a41566c.png?ex=67c0f5b3&is=67bfa433&hm=19ab02c04066a2cdbae52a1a74d4d2ce5624b4d76fa8f906bca593ce0e8db499&=&format=webp&quality=lossless"),
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
                        child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))
                      )
                    ])
                  ),
                  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                      child: Row(children: [
                      Expanded(child: Text("Last Name: ")),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))
                        )
                      ])
                  ),
                  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                      child: Row(children: [
                        Expanded(child: Text("Age: ")),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))
                        )
                      ])
                  ),
                  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                      child: Row(children: [
                        Expanded(child: Text("Placeholder: ")),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))
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