import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../data/entity/app_user.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<AppUser>? users;

  void getVisibleUsers() {
    List<AppUser> result = <AppUser>[];
    final db = FirebaseFirestore.instance;
    final usersRef = db.collection("users");

    // Create a query against the collection.
    try {
      usersRef.where("profileVisible", isEqualTo: true).get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          AppUser user = AppUser.fromSnapshot(docSnapshot);
          result.add(user);
        }

        setState(() {
          users = result;
        });
      });
    } catch (e) {
      print("failed to get visible users");
    }
  }

  @override
  void initState() {
    getVisibleUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: (users != null ? users! : [])
              .map(
                (user) => Column(
                  children: [
                    Text(user.firstName + " " + user.lastName),
                    Text(user.bio),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.1,
                      backgroundImage: user.profilePictureURL.isNotEmpty
                          ? NetworkImage(user.profilePictureURL)
                          : NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
