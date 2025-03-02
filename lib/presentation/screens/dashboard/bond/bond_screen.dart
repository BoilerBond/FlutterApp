import 'dart:typed_data';

import 'package:flutter/material.dart';

class BondScreen extends StatefulWidget {
  const BondScreen({super.key});

  @override
  State<BondScreen> createState() => _BondScreenState();
}

class _BondScreenState extends State<BondScreen> {
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bond'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16).copyWith(top: 0),
        child: Column(
          children: [
            Divider(),
            SizedBox(height: 16),
            Stack(children: [
              _image != null
                  ? CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    )
            ]),
            SizedBox(height: 8),
            Text("[Name]", style: Theme.of(context).textTheme.headlineMedium),
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(padding: EdgeInsets.all(16), child: TextButton(onPressed: () => {}, child: Text("View More"))),
                  ),
                  VerticalDivider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(padding: EdgeInsets.all(16), child: TextButton(onPressed: () => {}, child: Text("Unbond"))),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text("Go to our messages"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text("Relationship suggestions"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
