import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //print("MyProfileScreen Loaded");
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFFE7EFEE),
        backgroundColor: Color(0xFF5E77DF),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
      appBar: AppBar(title: Text('My Profile')),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'BBond',
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5E77DF)),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome back, [username]',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(height: 200, width: 200, child: Icon(Icons.image, size: 200, color: Color(0xFFCDFCFF))),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Edit profile', style: TextStyle(fontFamily: 'Raleway', color: Color(0xFF2C519C))),
                    ),
                    Text('|', style: TextStyle(fontFamily: 'Raleway', color: Color(0xFFE7EFEE))),
                    TextButton(
                      onPressed: () {},
                      child: Text('View profile', style: TextStyle(fontFamily: 'Raleway', color: Color(0xFF2C519C))),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Color(0xFFE7EFEE), borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Text(
                        'Prompt of the day',
                        style: TextStyle(color: Color(0xFF2C519C), fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '[Personal question]?',
                        style: TextStyle(color: Color(0xFF2C519C), fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'My answer...',
                        style: TextStyle(color: Color(0xFF454746), fontFamily: 'Raleway', fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
