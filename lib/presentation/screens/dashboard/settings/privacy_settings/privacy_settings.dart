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

class VisibilityToggle extends StatefulWidget {
  const VisibilityToggle({super.key});

  @override
  State<VisibilityToggle> createState() => _VisibilityToggleState();
}

class _VisibilityToggleState extends State<VisibilityToggle> {
  bool _lights = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Visibility of my profile'),
      subtitle: const Text('By default, your profile is visible to everyone. By turning this off, you are opting out of matchmaking.'),
      value: _lights,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
        });
      },
      secondary: const Icon(Icons.visibility),
    );
  }
}

class PhotoToggle extends StatefulWidget {
  const PhotoToggle({super.key});

  @override
  State<PhotoToggle> createState() => _PhotoToggleState();
}

class _PhotoToggleState extends State<PhotoToggle> {
  bool _lights = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Visibility of my photos'),
      subtitle: const Text('By default, your photos are visible to everyone. By turning this off, your photos are only visible to your match of the week.'),
      value: _lights,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
        });
      },
      secondary: const Icon(Icons.photo_library),
    );
  }
}