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

  void _onBlockedProfilesPress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/blocked_profiles");
  }

  void _onLogoutPress(BuildContext context) {
    confirmDialog(context, () async {
      await FirebaseAuth.instance.signOut();
    });
  }

  void _onDangerZonePress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/danger_zone");
  }

  void _onBoilerBondGuidePress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/user_guide");
  }
    void _onLegalInformationPress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/legal_information");
  }

  void _onRedirectToOnboardingPress(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, "/onboarding", (route) => false);
  }

  void _onBugReportingPress(BuildContext context) {
    Navigator.pushNamed(context, "/settings/bug_reporting");
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {'title': 'App Settings', 'type': ButtonType.normal, 'icon': Icons.desktop_windows, 'onPressed': _onAppSettingsPress},
      {'title': 'Privacy Settings', 'type': ButtonType.normal, 'icon': Icons.no_photography, 'onPressed': _onPrivacySettingsPress},
      {'title': 'Blocked Profiles', 'type': ButtonType.normal, 'icon': Icons.block, 'onPressed': _onBlockedProfilesPress},
      {'title': 'Legal Information', 'type': ButtonType.normal, 'icon': Icons.list, 'onPressed': _onLegalInformationPress},
      {'title': 'BoilerBond Guide', 'type': ButtonType.normal, 'icon': Icons.help_outline, 'onPressed': _onBoilerBondGuidePress},
      {'title': 'Back to Onboarding', 'type': ButtonType.normal, 'icon': Icons.arrow_forward, 'onPressed': _onRedirectToOnboardingPress},
      {'title': 'Danger Zone', 'type': ButtonType.danger, 'icon': Icons.warning_amber_rounded, 'onPressed': _onDangerZonePress},
      {'title': 'Log Out', 'type': ButtonType.warning, 'icon': Icons.exit_to_app, 'onPressed': _onLogoutPress},
      {'title': 'Bug Reporting', 'type': ButtonType.normal, 'icon': Icons.bug_report, 'onPressed': _onBugReportingPress},
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
              padding: const EdgeInsets.only(bottom: 8),
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
                      const SizedBox(width: 8),
                      Icon(
                        button['icon'],
                        color: button['type'] == ButtonType.warning
                            ? Colors.orange
                            : button['type'] == ButtonType.danger
                                ? Theme.of(context).colorScheme.error
                                : Color(0xFF2C519C),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        button['title'],
                        style: TextStyle(
                          color: button['type'] == ButtonType.warning
                              ? Colors.orange
                              : button['type'] == ButtonType.danger
                                  ? Theme.of(context).colorScheme.error 
                                  : Color(0xFF2C519C),
                          fontSize: 16,
                          //fontFamily: "Raleway",
                          //fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),

            const Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
