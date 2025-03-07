import "package:flutter/material.dart";
import 'dart:typed_data';
import 'package:datingapp/utils/image_helper.dart';


class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('BBond'),
            automaticallyImplyLeading: false,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                child:
                  Text(
                      "Onboarding",
                      style: TextStyle(
                          fontSize: 30
                      )
                  )
              ),
              Divider(
                indent: MediaQuery.of(context).size.width * 0.04,
                endIndent: MediaQuery.of(context).size.width * 0.04
              ),
              Expanded(
                  child: Center(
                      child: Column(
                          children: [
                            Text("1. Build your profile"),
                          ]
                      )
                  )
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
                        onPressed: () => {
                          Navigator.of(context).push(_createRoute(Step2()))},
                        child: Icon(Icons.arrow_forward)
                    ),
                  ),
                ),
              ),
            ]
        )
    );
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
        appBar: AppBar(
            title: const Text('BBond'),
            automaticallyImplyLeading: false,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                  child:
                  Text(
                      "Onboarding",
                      style: TextStyle(
                          fontSize: 30
                      )
                  )
              ),
              Divider(
                  indent: MediaQuery.of(context).size.width * 0.04,
                  endIndent: MediaQuery.of(context).size.width * 0.04
              ),
              Expanded(
                  child: Center(
                      child: Column(
                          children: [
                            Text("2. placeholder"),
                          ]
                      )
                  )
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
                        onPressed: () => {
                          Navigator.of(context).push(_createRoute(Step6()))},
                        child: Icon(Icons.arrow_forward)
                    ),
                  ),
                ),
              ),
            ]
        )
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
        appBar: AppBar(
            title: const Text('BBond'),
            automaticallyImplyLeading: false,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                  child:
                  Text(
                      "Onboarding",
                      style: TextStyle(
                          fontSize: 30
                      )
                  )
              ),
              Divider(
                  indent: MediaQuery.of(context).size.width * 0.04,
                  endIndent: MediaQuery.of(context).size.width * 0.04
              ),
              Expanded(
                  child: Center(
                      child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.03),
                              child: Text(
                                  "6. Upload Profile Picture",
                                  style: TextStyle(
                                      fontSize: 24
                                  ))
                            ),
                            // upload profile picture section
                            Stack(
                                children: [
                                  _image != null ?
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.3,
                                    backgroundImage: MemoryImage(_image!)
                                  ) :
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.3,
                                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                  )
                                ]
                            ),
                            Padding(
                                padding: EdgeInsets.all(16),
                                child: TextButton(onPressed: selectImage, child: Text("Upload Profile Picture"))
                            ),
                            Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                                child: Container(
                                    width : double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffE7EFEE),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text("Your profile picture will be visible to every user on this app. + Terms of service warning")
                                    )
                                )
                            ),
                          ]
                      )
                  )
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
                        onPressed: () async => {
                          _uploadImage(_image!),
                          Navigator.pushReplacementNamed(context, "/")
                        },
                        child: Text("Finish")
                    ),
                  ),
                ),
              ),
            ]
        )
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

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      }
  );
}