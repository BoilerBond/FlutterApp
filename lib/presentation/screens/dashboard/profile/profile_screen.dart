import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              "Welcome back, [User]!",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            ),
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.2,
              backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
            ),
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: Padding(padding: EdgeInsets.all(16), child: Text("Bio")))),
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
              Padding(padding: EdgeInsets.all(16), child: TextButton(onPressed: () => {}, child: Text("View Profile")))
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
