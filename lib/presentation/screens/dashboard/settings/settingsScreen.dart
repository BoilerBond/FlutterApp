import 'package:datingapp/presentation/widgets/confirm_dialog.dart';
import 'package:datingapp/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum ButtonType { normal, warning, danger }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void _onAppSettingsPress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/app");
  }

  void _onPrivacySettingsPress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/privacy");
  }

  void _onLogoutPress(BuildContext context) {
    confirmDialog(context, () async {
      await FirebaseAuth.instance.signOut();
    });
  }

  void _onDangerZonePress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/danger_zone");
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'title': 'App Settings', 'type': ButtonType.normal, 'onPressed': _onAppSettingsPress},
      {'title': 'Privacy Settings', 'type': ButtonType.normal, 'onPressed': _onPrivacySettingsPress},
      {'title': 'Legal Information', 'type': ButtonType.normal, 'onPressed': (BuildContext context) {}},
      {'title': 'BoilerBond Guide', 'type': ButtonType.normal, 'onPressed': (BuildContext context) {}},
      {'title': 'Danger Zone', 'type': ButtonType.danger, 'onPressed': _onDangerZonePress},
      {'title': 'Log Out', 'type': ButtonType.warning, 'onPressed': _onLogoutPress},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: buttons
              .map(
                (button) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0).copyWith(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
                        foregroundColor: button['type'] == ButtonType.normal
                            ? Theme.of(context).colorScheme.primary
                            : button['type'] == ButtonType.warning
                                ? MaterialTheme.warning
                                : Theme.of(context).colorScheme.error,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => button['onPressed'](context),
                      child: Text(button['title']),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
