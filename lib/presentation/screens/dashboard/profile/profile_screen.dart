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
      {'title': 'Edit Profile',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/profile/edit_profile");
        }
      },
      {'title': 'View Profile', 'onPressed': (BuildContext context) {}}
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: false,),
      body: Center(
        child: Column(
            children: [
              Text(
                "Welcome back, [User]!",
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.3,
                backgroundImage: NetworkImage("https://media.discordapp.net/attachments/1024471419544944680/1344451681085296782/d33mwsf-0dd81126-6d91-4b0d-905c-886a1a41566c.png?ex=67c0f5b3&is=67bfa433&hm=19ab02c04066a2cdbae52a1a74d4d2ce5624b4d76fa8f906bca593ce0e8db499&=&format=webp&quality=lossless"),
              ),
              IntrinsicHeight(
                child: (
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // edit profile button
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: TextButton(onPressed: () => buttons[0]['onPressed'](context), child: Text("Edit Profile"))),
                        // vertical separator
                        VerticalDivider(
                          indent: 16,
                          endIndent: 16,
                        ),
                        // view profile button
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: TextButton(onPressed: () => {}, child: Text("View Profile")))
                      ]
                  )
                )
              ),
              Divider(
                indent: 16,
                endIndent: 16,
                thickness: 1,
              ),
              // prompt of the day
              Expanded(
                child:
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.050),
                    child: Container(
                      width : double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffE7EFEE),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Prompt of the day goes in here")
                      )
                    )
                  )
              )
            ]
        )
      )
    );
  }
}