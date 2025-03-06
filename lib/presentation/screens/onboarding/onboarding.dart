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
            Text("1. Build your profile"),
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
                        {Navigator.of(context).push(_createRoute(Step2()))},
                    child: Icon(Icons.arrow_forward)),
              ),
            ),
          ),
        ]));
  }
}

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
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
            Text("2. placeholder"),
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
                        {Navigator.of(context).push(_createRoute(Step6()))},
                    child: Icon(Icons.arrow_forward)),
              ),
            ),
          ),
        ]));
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

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
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
