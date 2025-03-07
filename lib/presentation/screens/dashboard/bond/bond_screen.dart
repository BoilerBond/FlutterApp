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
        title: const Text(
                  "My Bond",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w100,
                    fontSize: 22,
                    color: Color(0xFF454746),
                  ),
                ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black54),
            onPressed: () {
              _reportProfile(context);
            },
          ),
        ],
        toolbarHeight: 40, 
      ),
      body: Padding(
        padding: EdgeInsets.all(16).copyWith(top: 0),
        child: Column(
          children: [
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),
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
                    child: Padding(padding: EdgeInsets.all(16), child: TextButton(onPressed: () => {_confirmUnbondDialog(context)}, child: Text("Unbond"))),
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


  void _confirmUnbondDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Are you sure you want to unbond?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "This action will remove your bond and cannot be undone.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _unbond();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C519C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Yes, Unbond"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _unbond() {
    // Implement the logic to unbond the user
  }

void _reportProfile(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Report [name]'s Profile",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Why do you want to report this profile?',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text("Profile goes against one of my non-negotiables."),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("Profile appears to be fake or catfishing."),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text("Offensive content against community standards."),
                    ),
                  ],
                  onChanged: (value) {
                    
                  },
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                       // implement reporting logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2C519C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Report"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}