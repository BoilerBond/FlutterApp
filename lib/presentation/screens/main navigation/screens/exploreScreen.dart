import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  double sliderValue = 0; 
  int profileIndex = 0;

  // Sample profiles to test slider functionality
  final List<Map<String, String>> profiles = [
    {"name": "Alice", "age": "21", "major": "Computer Science", "about": "Loves AI and coding"},
    {"name": "Bob", "age": "24", "major": "Mechanical Engineering", "about": "Passionate about robotics"},
    {"name": "Charlie", "age": "22", "major": "Physics", "about": "Interested in quantum mechanics"},
    {"name": "Diana", "age": "23", "major": "Business", "about": "Aspiring entrepreneur"},
    {"name": "Ethan", "age": "25", "major": "Medicine", "about": "Future doctor"}
  ];

  void _switchToNextProfile() {
  setState(() {
    profileIndex = (profileIndex + 1) % profiles.length;
    // we wrap around profile list length but this should not be necessary
    // in final version
  });
}

  

  void _expandProfileView() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${profiles[profileIndex]['name']}'s Profile"),
        content: Text(profiles[profileIndex]['about']!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

void _reportProfile() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85, // Also attempted to fix to 85% of the display to minimize overflow, did not work
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Report ${profiles[profileIndex]['name']}'s Profile",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // TODO: Fix right overflow issues. 
              //// Attempted to use Instrinsic Width and Flexible, and also Container
              /// Nothing worked so far.
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
                       _switchToNextProfile();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BBond", style: TextStyle(color: Color(0xFF5E77DF), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey(profileIndex),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EFEE),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 5, offset: const Offset(0, 2)),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _expandProfileView,
                      child: Container(
                        height: 200,
                        width: 200,
                        child: const Icon(Icons.image, size: 200, color: Color(0xFFCDFCFF)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profiles[profileIndex]['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 18, 
                            color: Color(0xFF2C519C),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: _reportProfile, 
                          icon: const Icon(Icons.more_horiz, color: Colors.black54)
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profiles[profileIndex]['age']!,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF5E77DF)),
                        ),
                        const SizedBox(width: 10),
                        const Text("|", style: TextStyle(color: Color(0xFF2C519C))),
                        const SizedBox(width: 10),
                        Text(
                          profiles[profileIndex]['major']!,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF5E77DF)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 10.0, 
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: -2,
                        max: 2,
                        divisions: 4,
                        label: sliderValue.toString(),
                        activeColor: const Color(0xFF5E77DF),
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                          });
                          _switchToNextProfile();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey(profileIndex), 
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFCDFCFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About:",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C519C)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profiles[profileIndex]['about']!,
                      style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF454746)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
