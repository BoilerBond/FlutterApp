import 'package:flutter/material.dart';

class _PrivacySettingsPage extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'title': 'Placeholder buttons', 'onPressed': (BuildContext context) {}},
      {'title': 'Placeholder buttons', 'onPressed': (BuildContext context) {}},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
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

class PrivacySettings extends StatefulWidget {
  const PrivacySettings();

  @override
  State<PrivacySettings> createState() => _PrivacySettingsPage();
}
