import 'package:flutter/material.dart';

// Sample profile
const String name = "Purdue Pete";

class BondScreen extends StatelessWidget {
  const BondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("BBond", style: TextStyle(color: Color(0xFF5E77DF), fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black54),
            onPressed: () {
              _reportProfile(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My bond",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w100,
                  fontSize: 16,
                  color: Color(0xFF454746),
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),

            Container(
                height: 200,
                width: 200,
                child: const Icon(Icons.image, size: 200, color: Color(0xFFCDFCFF)),
            ),
            const SizedBox(height: 10),

            const Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2C519C),
              ),
            ),
            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Implement navigation to view profile
                  },
                  child: const Text(
                    "View more",
                    style: TextStyle(color: Color(0xFF2C519C)),
                  ),
                ),
                const Text("|", style: TextStyle(color: Color(0xFFE7EFEE))),
                TextButton(
                  onPressed: () {
                    // TODO: Implement unbond functionality
                  },
                  child: const Text(
                    "Unbond",
                    style: TextStyle(color: Color(0xFF2C519C)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: OutlinedButton(
                onPressed:() => {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.message, color: Colors.black54),
                    const SizedBox(width: 10),
                    Text("Go to our messages", style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: OutlinedButton(
                onPressed:() => {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.favorite_border, color: Colors.black54),
                    const SizedBox(width: 10),
                    Text("Relationship suggestions", style: const TextStyle(color: Colors.black54, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
                "Report $name's Profile",
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
                    // use this value to store in database
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
                       // implement actions that follow reporting a bonded profile
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
