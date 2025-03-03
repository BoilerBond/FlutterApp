import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfile> {
  // Sample profile information
  String name = "Purdue Pete";
  int age = 21;
  String major = "Computer Science";
  String biography = "Computer Scientist by day, Purdue Pete by night.";

  // Temporary values for editing
  late String tempName;
  late int tempAge;
  late String tempMajor;
  late String tempBiography;

  @override
  void initState() {
    super.initState();
    tempName = name;
    tempAge = age;
    tempMajor = major;
    tempBiography = biography;
  }

  void _saveProfile() {
    setState(() {
      name = tempName;
      age = tempAge;
      major = tempMajor;
      biography = tempBiography;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFF5E77DF))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5E77DF)),
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: () {
                  // TODO: Implement profile picture update
                },
                child: Container(
                  height: 200,
                  width: 200,
                  child: const Icon(Icons.image, size: 200, color: Color(0xFFCDFCFF)),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.edit, color: Color(0xFF5E77DF)),
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: tempName,
                decoration: InputDecoration(
                  labelText: 'Name:',
                  filled: false,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0XFFE7EFEE))),
                ),
                onChanged: (value) => tempName = value,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<int>(
                value: tempAge,
                decoration: InputDecoration(
                  labelText: 'Age:',
                  filled: false,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0XFFE7EFEE))),
                ),
                items: List.generate(100, (index) => index + 1)
                    .map((age) => DropdownMenuItem<int>(
                          value: age,
                          child: Text(age.toString()),
                        ))
                    .toList(),
                onChanged: (value) => tempAge = value!,
              ),
              const SizedBox(height: 10),

              TextFormField(
                initialValue: tempMajor,
                decoration: InputDecoration(
                  labelText: 'Major:',
                  filled: false,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0XFFE7EFEE))),
                ),
                onChanged: (value) => tempMajor = value,
              ),
              const SizedBox(height: 10),

              TextFormField(
                initialValue: tempBiography,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Biography:',
                  filled: false,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Color(0XFFE7EFEE))),
                ),
                onChanged: (value) => tempBiography = value,
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement navigation to interests editing screen
                  },
                  child: const Text('Edit my interests', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5E77DF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement navigation to interests editing screen
                  },
                  child: const Text('Edit onboarding information', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5E77DF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: OutlinedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save', style: TextStyle(fontSize: 16, color: Color(0XFF2C519C))),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0XFFE7EFEE)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
