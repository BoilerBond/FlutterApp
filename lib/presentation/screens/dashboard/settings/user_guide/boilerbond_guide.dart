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
          _buildTextBlock("1. Provide a rating using a slider on a [-2,2] scale to switch to the next user card."),
          _buildSliderDemo(),
          _buildTextBlock("2. Tap the profile picture to access the user's profile."),
          _buildPhotoTapDemo(),
          _buildTextBlock("3. Tap ••• to report."),
          _buildReportIconDemo(),

          const SizedBox(height: 30),
          _buildSectionHeader("My Bond: Weekly Match"),
          _buildTextBlock("1. Your match of the week appears on this screen."),
          _buildProfileCardDemo("Sophia", "22", "Psychology"),
          _buildTextBlock("2. Click \"View More\" to access your match's profile."),
          _buildBondButtonsDemo(),
          _buildTextBlock("3. You may click \"Unbond\" to unmatch before the week ends, but this action is irreversible."),
          _buildBondButtonsDemo(),
          _buildTextBlock("4. Click \"Go to messages\" to access your chat with your match."),
          _buildChatDemo(),
          _buildTextBlock("5. Click \"Relationship suggestions\" to access long-term and short-term relationship suggestions."),
          _buildSuggestionDemo(),
          _buildTextBlock("6. Tap ••• to report."),
          _buildReportIconDemo(),

          const SizedBox(height: 30),
          _buildSectionHeader("My Profile: Your Information"),
          _buildTextBlock("1. Your profile information appears on this screen."),
          _buildProfileCardDemo("Jordan Lee", "23", "UX Design"),
          _buildTextBlock("2. Click \"Edit Profile\" to edit your profile information, your displayed interests, onboarding information, height settings, and social media linking."),
          _buildEditViewButtonsDemo(),
          _buildTextBlock("3. You may click \"View Profile\" to view how other users can visualize your profile."),
          _buildEditViewButtonsDemo(),
          _buildTextBlock("4. You can provide additional matchmaking information by adding responses to \"Prompt of the day\"."),
          _buildPromptOfTheDayDemo(),

          const SizedBox(height: 30),
          _buildSectionHeader("Settings: Control & Privacy"),
          _buildTextBlock("1. App settings: Manage notifications."),
          _buildTextBlock("2. Privacy settings: Adapt the visibility of your profile and pictures to other users."),
          _buildTextBlock("3. Legal information: Access Terms & Conditions information regarding BoilerBond usage."),
          _buildTextBlock("4. BoilerBond Guide: This tab."),
          _buildTextBlock("5. Danger Zone: Delete your account."),
          _buildTextBlock("6. Log out: Log out of the current session."),
          _buildSettingsButtonsDemo(),
          _buildPrivacySwitchesDemo(),

          const SizedBox(height: 24),
          _buildTipBox(),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C519C)));
  }

  Widget _buildTextBlock(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF454746))),
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
            backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
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
          child: const Text(
            "Senior in UX Design. I like clean UI and coffee ☕️",
            style: TextStyle(color: Color(0xFF454746)),
          ),
        ),
      ],
    ),
  );
}



  Widget _buildChatDemo() {
    return _buildActionButton(Icons.chat_bubble_outline, "Go to our messages");
  }

  Widget _buildSuggestionDemo() {
    return _buildActionButton(Icons.favorite, "Relationship suggestions");
  }


  Widget _buildEditViewButtonsDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () {}, child: const Text("Edit Profile")),
        TextButton(onPressed: () {}, child: const Text("View Profile")),
      ],
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
          Text("🗣 Prompt of the Day", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("What's your go-to karaoke song?", style: TextStyle(color: Color(0xFF2C519C))),
          SizedBox(height: 8),
          TextField(
            maxLines: 1,
            decoration: InputDecoration(hintText: "My answer...", border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton.icon(
        icon: Icon(icon, color: const Color(0xFF2C519C)),
        label: Text(label, style: const TextStyle(color: Color(0xFF2C519C))),
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE7EFEE)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSettingsButtonsDemo() {
    return Column(
      children: [
        _mockSettingsButton(Icons.desktop_windows, "App Settings"),
        _mockSettingsButton(Icons.no_photography, "Privacy Settings"),
        _mockSettingsButton(Icons.list_alt, "Legal Information"),
        _mockSettingsButton(Icons.help_outline, "BoilerBond Guide"),
        _mockSettingsButton(Icons.warning_amber_rounded, "Danger Zone", isDanger: true),
        _mockSettingsButton(Icons.exit_to_app, "Log Out", isWarning: true),
      ],
    );
  }

  Widget _mockSettingsButton(IconData icon, String label, {bool isDanger = false, bool isWarning = false}) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildTipBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCDFCFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "💡 Tip: Update your profile weekly and answer prompts to improve your match chances!",
        style: TextStyle(fontSize: 14, color: Color(0xFF2C519C)),
      ),
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
}
