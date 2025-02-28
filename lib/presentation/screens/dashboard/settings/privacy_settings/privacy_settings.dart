import 'package:flutter/material.dart';

class _PrivacySettingsPage extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: Center(
        child: Column(
          children: [
            Divider(),
            VisibilityToggle(),
            PhotoToggle(),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('Placeholder buttons'),
            ),
            Spacer(),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.075), // Button width and height
              ),
              onPressed: () {},
              label: const Text('Placeholder buttons'),
            ),
            Spacer(flex: 10)
          ]
        )
      )
    );
  }
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

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