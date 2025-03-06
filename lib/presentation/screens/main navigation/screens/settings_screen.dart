import 'package:flutter/material.dart';
import 'package:datingapp/presentation/navigation/router_delegate.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Color(0xFF5E77DF), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const _SettingsPage(),
    );
  }
}



class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BBond", style: TextStyle(color: Color(0xFF5E77DF), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w100,
                  fontSize: 16,
                  color: Color(0xFF454746),
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.desktop_windows, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("App Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {
                  AppRouterDelegate.of(context).showLoginPage = true;
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.alternate_email, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Login Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {
                  AppRouterDelegate.of(context).showPrivacyPage = true;
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.no_photography, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Privacy Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.key, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Safety Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.list, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Legal Information", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.help_outline, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("BoilerBond Guide", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(flex: 5)
          ]
        ),
      ),
    );
  }
}
