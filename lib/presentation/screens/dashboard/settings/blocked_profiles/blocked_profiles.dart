import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/entity/app_user.dart';
import 'package:datingapp/presentation/widgets/protected_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlockedProfiles extends StatefulWidget {
  const BlockedProfiles({super.key});

  @override
  _BlockedProfilesState createState() => _BlockedProfilesState();
}

class _BlockedProfilesState extends State<BlockedProfiles> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> blockedUserData = {};
  AppUser? userObject;

  // Fetch blocked user profiles from firestore
  Future<void> fetchBlockedProfiles(String keyword) async {
    Map<String, dynamic> searchedResult = {};

    userObject = await AppUser.getById(currentUser!.uid);

    for (int index = 0; index < userObject!.blockedUserUIDs.length; index++) {
      String uid = userObject!.blockedUserUIDs[index];
      try {
        AppUser blockedUserObject = await AppUser.getById(uid);
        print(keyword);
        if (keyword.isEmpty || blockedUserObject.firstName.contains(keyword) || blockedUserObject.lastName.contains(keyword)) {
          searchedResult[uid] = {
            "successful": true,
            "index": index,
            "firstName": blockedUserObject.firstName,
            "lastName": blockedUserObject.lastName,
            "age": blockedUserObject.age,
            "major": blockedUserObject.major,
          };
        }
      } catch (e) {
        searchedResult[uid] = {
          "successful": false,
          "index": index,
        };
      }
    }
    if (mounted) {
      setState(() {
        blockedUserData = searchedResult;
      });
    }
  }

  // Remove blocked user from the block list
  Future<void> unblockUser(String uid) async {
    userObject!.blockedUserUIDs.removeAt(blockedUserData[uid]["index"]);
    await FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).update({
      "blockedUserUIDs": FieldValue.arrayRemove([uid])
    });

    setState(() {
      blockedUserData.remove(uid);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBlockedProfiles("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Profiles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      await fetchBlockedProfiles(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
            blockedUserData.keys.isEmpty
                ? Text("No blocked users available", style: TextStyle(fontStyle: FontStyle.italic))
                : Column(
                    children: [
                      ...blockedUserData.keys.map(
                        (key) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: blockedUserData[key]["successful"]
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    border: Border.all(color: Color(0xFFE7EFEE), width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          child: ProtectedText(
                                            "${blockedUserData[key]["firstName"]} ${blockedUserData[key]["lastName"]}",
                                            style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(width: 22),
                                        Container(
                                          width: 20,
                                          child: Text(
                                            blockedUserData[key]["age"].toString(),
                                            style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(width: 22),
                                        Container(
                                          width: 50,
                                          child: ProtectedText(
                                            blockedUserData[key]["major"],
                                            style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            unblockUser(key);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.lock_open,
                                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Unblock",
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Text("Profile is not visible"),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
