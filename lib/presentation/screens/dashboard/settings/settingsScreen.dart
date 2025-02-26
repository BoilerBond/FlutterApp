import 'package:flutter/material.dart';

void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'title': 'App Settings', 'onPressed': (BuildContext context) {}},
      {
        'title': 'Login Settings',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/settings/login");
        }
      },
      {
        'title': 'Privacy Settings',
        'onPressed': (BuildContext context) {
          Navigator.pushNamed(context, "/settings/privacy");
        }
      },
      {'title': 'Safety Settings', 'onPressed': (BuildContext context) {}},
      {'title': 'Legal Information', 'onPressed': (BuildContext context) {}},
      {'title': 'BoilerBond Guide', 'onPressed': (BuildContext context) {}},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: buttons
              .map((button) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0).copyWith(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => button['onPressed'](context),
                        child: Text(button['title']),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
