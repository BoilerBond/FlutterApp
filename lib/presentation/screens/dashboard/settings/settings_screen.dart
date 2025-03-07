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
      {'title': 'App Settings', 'type': ButtonType.normal, 'icon': Icons.desktop_windows, 'onPressed': _onAppSettingsPress},
      {'title': 'Privacy Settings', 'type': ButtonType.normal, 'icon': Icons.no_photography, 'onPressed': _onPrivacySettingsPress},
      {'title': 'Legal Information', 'type': ButtonType.normal, 'icon': Icons.list, 'onPressed': (BuildContext context) {}},
      {'title': 'BoilerBond Guide', 'type': ButtonType.normal, 'icon': Icons.help_outline, 'onPressed': (BuildContext context) {}},
      {'title': 'Danger Zone', 'type': ButtonType.danger, 'icon': Icons.warning_amber_rounded, 'onPressed': _onDangerZonePress},
      {'title': 'Log Out', 'type': ButtonType.warning, 'icon': Icons.exit_to_app, 'onPressed': _onLogoutPress},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
                  "Settings",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w100,
                    fontSize: 22,
                    color: Color(0xFF454746),
                  ),
                ),
        automaticallyImplyLeading: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 40, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),

            ...buttons.map((button) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE7EFEE)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => button['onPressed'](context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        button['icon'],
                        color: button['type'] == ButtonType.warning
                            ? Colors.orange
                            : button['type'] == ButtonType.danger
                                ? Theme.of(context).colorScheme.error
                                : Color(0xFF2C519C),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        button['title'],
                        style: TextStyle(
                          color: button['type'] == ButtonType.warning
                              ? Colors.orange
                              : button['type'] == ButtonType.danger
                                  ? Theme.of(context).colorScheme.error 
                                  : Color(0xFF2C519C),
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),

            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
