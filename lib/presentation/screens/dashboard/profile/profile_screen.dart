import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/constants/constants.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/view_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../data/entity/app_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageURL = "";
  String? userName = "";
  String? bio = "";
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> getProfile() async {
    if (currentUser != null) {
      final userSnapshot = await db.collection("users").doc(currentUser?.uid).get();
      final user = AppUser.fromSnapshot(userSnapshot);
      setState(() {
        userName = user.firstName + " " + user.lastName;
        bio = user.bio;
        _imageURL = user.profilePictureURL;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {
        'title': 'Edit Profile',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/edit_profile");
        }
      },
      {'title': 'View Profile', 'onPressed': (BuildContext context) {}}
    ];
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "Welcome back, " + userName! + "!",
              style: TextStyle(height: 2, fontSize: 25),
            ),
            Stack(children: [
              (_imageURL!.isNotEmpty)
                  ? CircleAvatar(radius: MediaQuery.of(context).size.width * 0.2, backgroundImage: NetworkImage(_imageURL!))
                  : CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: NetworkImage(Constants.defaultProfilePictureURL),
                    )
            ]),
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Padding(padding: EdgeInsets.all(16), child: Text(bio!)))),
            IntrinsicHeight(
                child: (Row(mainAxisSize: MainAxisSize.min, children: [
              // edit profile button
              Padding(padding: EdgeInsets.all(16), child: TextButton(onPressed: () => buttons[0]['onPressed'](context), child: Text("Edit Profile"))),
              // vertical separator
              VerticalDivider(
                indent: 16,
                endIndent: 16,
              ),
              // view profile button
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ViewProfileScreen()),
                      )
                    },
                    child: const Text("View Profile"),
                  ),
                ),
              ),
            ]))),
            Divider(
              indent: 16,
              endIndent: 16,
              thickness: 1,
            ),
            // prompt of the day
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Prompt of the day goes in here"),
                          TextField(
                            maxLines: 5,
                            minLines: 1,
                            style: TextStyle(height: 1),
                            decoration: InputDecoration(hintText: "My answer...", border: InputBorder.none),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
