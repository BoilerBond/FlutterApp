import 'package:flutter/material.dart';

class _PrivacySettingsState extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: Center(
        child: Column(
          children: [
            ProfileVisibilityToggle(),
            PhotoVisibilityToggle(),
          ],
        )
      ),
    );
  }
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings();

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class ProfileVisibilityToggle extends StatefulWidget {
  const ProfileVisibilityToggle({super.key});

  @override
  State<ProfileVisibilityToggle> createState() => _ProfileVisibilityToggleState();
}

class _ProfileVisibilityToggleState extends State<ProfileVisibilityToggle> {
  bool _lights = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Visibility of my profile'),
      subtitle: const Text('By default, your profile is visible to everyone. By turning this off, you are opting out of matchmaking.'),
      value: _lights,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
        });
      },
      secondary: const Icon(Icons.visibility),
    );
  }
}

class PhotoVisibilityToggle extends StatefulWidget {
  const PhotoVisibilityToggle({super.key});

  @override
  State<PhotoVisibilityToggle> createState() => _PhotoVisibilityToggleState();
}

class _PhotoVisibilityToggleState extends State<PhotoVisibilityToggle> {
  bool _lights = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Visibility of my photos'),
      subtitle: const Text('By default, your photos are visible to everyone. By turning this off, your photos are only visible to your match of the week.'),
      value: _lights,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      onChanged: (bool value) {
        setState(() {
          _lights = value;
        });
      },
      secondary: const Icon(Icons.photo_library),
    );
  }
}