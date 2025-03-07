import 'package:flutter/material.dart';
import 'more_profile.dart'; // Import the new profile screen

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  double sliderValue = 0; 
  int profileIndex = 0;

  final List<Map<String, dynamic>> profiles = [
  {
    "name": "Alice",
    "age": "21",
    "major": "Computer Science",
    "bio": "AI enthusiast, coder, and cat lover.",
    "displayedInterests": ["Machine Learning", "Cybersecurity", "Hackathons"],
    "about": "Enjoys technology"
  },
  {
    "name": "Bob",
    "age": "24",
    "major": "Mechanical Engineering",
    "bio": "Building the future of robotics, one design at a time.",
    "displayedInterests": ["3D Printing", "Automotive Engineering", "Space Exploration"],
    "about": "Engineering interests"
  },
  {
    "name": "Charlie",
    "age": "22",
    "major": "Physics",
    "bio": "Exploring the wonders of the universe through quantum mechanics.",
    "displayedInterests": ["Quantum Computing", "Astrophysics", "Math Puzzles"],
    "about": "Logic-oriented"
  },
  {
    "name": "Diana",
    "age": "23",
    "major": "Business",
    "bio": "Entrepreneurial mindset with a passion for startups and finance.",
    "displayedInterests": ["Investing", "Networking", "Leadership"],
    "about": "Business mentality"
  },
  {
    "name": "Ethan",
    "age": "25",
    "major": "Medicine",
    "bio": "Future doctor with a focus on cardiology and research.",
    "displayedInterests": ["Medical Research", "Fitness", "Public Health"],
    "about": "Interest in human biology"
  }
];


  void _switchToNextProfile() {
    setState(() {
      profileIndex = (profileIndex + 1) % profiles.length;
    });
  }

void _navigateToMoreProfile() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MoreProfileScreen(
        name: profiles[profileIndex]['name']!,
        age: profiles[profileIndex]['age']!,
        major: profiles[profileIndex]['major']!,
        bio: profiles[profileIndex]['bio']!,
        displayedInterests: List<String>.from(profiles[profileIndex]['displayedInterests']),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explore",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w100,
            fontSize: 22,
            color: Color(0xFF454746),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 40, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),
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
                      onTap: _navigateToMoreProfile,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.2,
                        backgroundImage: const NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                        ),
                        backgroundColor: const Color(0xFFCDFCFF),
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

                    Slider(
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFCDFCFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
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
}
