import 'package:flutter/material.dart';

class BoilerBondGuide extends StatefulWidget {
  const BoilerBondGuide({super.key});

  @override
  State<BoilerBondGuide> createState() => _BoilerBondGuideState();
}

class _BoilerBondGuideState extends State<BoilerBondGuide> {
  double _demoSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BoilerBond Guide")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Explore: Rate & Report Profiles"),
          _buildTextBlock(
              "1. Provide a rating using a slider on a [-2,2] scale to switch to the next user card."),
          _buildSliderDemo(),
          _buildTextBlock(
              "2. Tap the profile picture to access the user's profile."),
          _buildPhotoTapDemo(),
          _buildTextBlock("3. Tap ••• to report."),
          _buildReportIconDemo(),
          _buildTextBlock(
              "4. Click the info icon (ℹ️) to see why the profile was suggested to you."),
          _buildInfoIconDemo(),
          _buildTextBlock(
              "5. Click the gear icon to edit your non-negotiables."),
          _buildGearIconDemo(),
          _buildTextBlock(
              "6. Use the toggle to filter profiles based on your non-negotiables."),
          _buildToggleFilterDemo(),

          const SizedBox(height: 30),
          _buildSectionHeader("My Bond: Weekly Match"),
          _buildTextBlock("1. Your match of the week appears here."),
          _buildProfileCardDemo("Sophia", "22", "Psychology"),
          _buildTextBlock(
              "2. Click \"View More\" to view your match’s full profile."),
          _buildBondButtonsDemo(),
          _buildTextBlock(
              "3. Click the info icon (ℹ️) to see why you were matched."),
          _buildInfoIconDemo(),
          _buildTextBlock(
              "4. Click \"View Match Introduction\" to revisit the onboarding summary of your match."),
          _buildMatchIntroButtonDemo(),
          _buildTextBlock(
              "5. Tap the Spotify button to visit their linked account (if available)."),
          _buildSpotifyButtonDemo(),
          _buildTextBlock(
              "6. Use the toggle to keep this match for next week."),
          _buildKeepMatchToggleDemo(),
          _buildTextBlock("7. Click \"Unbond\" to unmatch (irreversible)."),
          _buildBondButtonsDemo(), // reused from step 2
          _buildTextBlock(
              "8. Use the Block button to prevent future contact or matches."),
          _buildBlockButtonDemo(),
          _buildTextBlock("9. Tap ••• to report."),
          _buildReportIconDemo(),

          const SizedBox(height: 30),
          _buildSectionHeader("My Profile: Your Information"),
          _buildTextBlock(
              "1. Your profile information appears on this screen."),
          _buildProfileCardDemo("Jordan Lee", "23", "UX Design"),
          _buildTextBlock(
              "2. Click \"Edit Profile\" to update your details, interests, onboarding answers, and social media."),
          _buildEditViewButtonsDemo(),
          _buildTextBlock(
              "3. Click \"View Profile\" to preview how others see you."),
          _buildEditViewButtonsDemo(),
          _buildTextBlock(
              "4. Click \"Profile Privacy\" to customize which sections are visible to matches or others."),
          _buildEditViewButtonsDemo(),
          _buildTextBlock(
              "5. Click \"Edit Long Form Questions\" to set a deeper Q&A that others can view."),
          _buildEditLongFormDemo(),

          const SizedBox(height: 30),
          _buildSectionHeader("Settings: Control & Privacy"),
          _buildTextBlock("1. App Settings: Manage preferences."),
          _buildTextBlock(
              "2. Privacy Settings: Customize who can see your content."),
          _buildTextBlock("3. Blocked Profiles: Manage users you've blocked."),
          _buildTextBlock("4. Legal Information: View BoilerBond terms."),
          _buildTextBlock("5. BoilerBond Guide: This tab."),
          _buildTextBlock("6. Back to Onboarding: Restart onboarding flow."),
          _buildTextBlock("7. Bug Reporting: Let us know if something breaks."),
          _buildTextBlock("8. Danger Zone: Permanently delete your account."),
          _buildTextBlock("9. Log out: Sign out of the app."),
          _buildSettingsButtonsDemo(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C519C)));
  }

  Widget _buildTextBlock(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 16, color: Color(0xFF454746))),
    );
  }

  Widget _buildSliderDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Column(
        children: [
          Slider(
            value: _demoSliderValue,
            min: -2,
            max: 2,
            divisions: 4,
            label: _demoSliderValue.toString(),
            activeColor: const Color(0xFF5E77DF),
            onChanged: (value) {
              setState(() {
                _demoSliderValue = value;
              });
            },
          ),
          const Text("Move the slider to give a rating (-2 to 2).")
        ],
      ),
    );
  }

  Widget _buildPhotoTapDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Column(
        children: const [
          Text("Tap the profile picture to view a full profile:"),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
          ),
          SizedBox(height: 10),
          Text("Jamie, 21", style: TextStyle(color: Color(0xFF2C519C))),
        ],
      ),
    );
  }

  Widget _buildReportIconDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.more_horiz),
          SizedBox(width: 8),
          Text("Tap here to report profile")
        ],
      ),
    );
  }

  Widget _buildProfileCardDemo(String name, String age, String major) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              "$name, $age | $major",
              style: const TextStyle(color: Color(0xFF454746)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditViewButtonsDemo() {
    final List<Map<String, dynamic>> buttons = [
      {
        'title': 'Edit Profile',
        'onPressed': () {},
      },
      {
        'title': 'View Profile',
        'onPressed': () {},
      },
      {
        'title': 'Profile Privacy',
        'onPressed': () {},
      },
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: buttons.map((btn) {
        return TextButton(
          onPressed: btn['onPressed'],
          child: Text(btn['title']),
        );
      }).toList(),
    );
  }

  Widget _buildEditLongFormDemo() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: () {},
        child: const Text('Edit Long Form Questions'),
      ),
    );
  }

  Widget _buildBondButtonsDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () {}, child: const Text("View More")),
        TextButton(onPressed: () {}, child: const Text("Unbond")),
      ],
    );
  }

  Widget _buildPromptOfTheDayDemo() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("🗣 Prompt of the Day",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("What's your go-to karaoke song?",
              style: TextStyle(color: Color(0xFF2C519C))),
          SizedBox(height: 8),
          TextField(
            maxLines: 1,
            decoration: InputDecoration(
                hintText: "My answer...", border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButtonsDemo() {
    return Column(
      children: [
        _mockSettingsButton(Icons.desktop_windows, "App Settings"),
        _mockSettingsButton(Icons.no_photography, "Privacy Settings"),
        _mockSettingsButton(Icons.block, "Blocked Profiles"),
        _mockSettingsButton(Icons.list, "Legal Information"),
        _mockSettingsButton(Icons.help_outline, "BoilerBond Guide"),
        _mockSettingsButton(Icons.arrow_forward, "Back to Onboarding"),
        _mockSettingsButton(Icons.bug_report, "Bug Reporting"),
        _mockSettingsButton(Icons.warning_amber_rounded, "Danger Zone",
            isDanger: true),
        _mockSettingsButton(Icons.exit_to_app, "Log Out", isWarning: true),
      ],
    );
  }

  Widget _mockSettingsButton(IconData icon, String label,
      {bool isDanger = false, bool isWarning = false}) {
    Color color = isDanger
        ? Colors.red
        : isWarning
            ? Colors.orange
            : const Color(0xFF2C519C);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoIconDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.info_outline),
          SizedBox(width: 8),
          Text("Click info icon to see why this profile was suggested"),
        ],
      ),
    );
  }

  Widget _buildGearIconDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.settings),
          SizedBox(width: 8),
          Text("Edit your non-negotiables"),
        ],
      ),
    );
  }

  Widget _buildToggleFilterDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Only show profiles matching non-negotiables"),
          Switch(value: true, onChanged: (_) {}),
        ],
      ),
    );
  }

  Widget _buildSpotifyButtonDemo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.music_note, color: Colors.blueAccent),
        label: const Text("Spotify",
            style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 1, color: Colors.blueAccent),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildMatchIntroButtonDemo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 1, color: Color(0xFF2C519C)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.info_outline, color: Color(0xFF2C519C)),
              SizedBox(width: 8),
              Text("View Match Introduction",
                  style: TextStyle(fontSize: 16, color: Color(0xFF2C519C))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeepMatchToggleDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Keep match for next week"),
          Switch(value: true, onChanged: null),
        ],
      ),
    );
  }

  Widget _buildBlockButtonDemo() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.block, color: Colors.white),
      label: const Text("Block User", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildPrivacySwitchesDemo() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Profile Visibility"),
          subtitle: const Text("Turn off to hide from Explore & matchmaking."),
          value: true,
          onChanged: (_) {},
          activeTrackColor: Theme.of(context).colorScheme.primary,
          secondary: const Icon(Icons.visibility),
        ),
        SwitchListTile(
          title: const Text("Photo Visibility"),
          subtitle: const Text("Visible only to your match if turned off."),
          value: true,
          onChanged: (_) {},
          activeTrackColor: Theme.of(context).colorScheme.primary,
          secondary: const Icon(Icons.photo_library),
        ),
      ],
    );
  }

  BoxDecoration _demoBoxDecoration({Color? color}) {
    return BoxDecoration(
      color: color ?? const Color(0xFFE7EFEE),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 2)),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _demoBoxDecoration(),
      child: OutlinedButton.icon(
        icon: Icon(icon, color: const Color(0xFF2C519C)),
        label: Text(label, style: const TextStyle(color: Color(0xFF2C519C))),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2C519C)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
