import 'package:flutter/material.dart';
import '../../dashboard/settings/login_settings/login_settings.dart';
import '../../dashboard/settings/privacy_settings/privacy_settings.dart';

void main() => runApp(const SettingsScreen());

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final RouterDelegate<Object> delegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerDelegate: delegate);
  }
}

class MyRouterDelegate extends RouterDelegate<Object>
    with PopNavigatorRouterDelegateMixin<Object>, ChangeNotifier {
  // This example doesn't use RouteInformationProvider.
  @override
  Future<void> setNewRoutePath(Object configuration) async =>
      throw UnimplementedError();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static MyRouterDelegate of(BuildContext context) =>
      Router.of(context).routerDelegate as MyRouterDelegate;

  bool get showLoginPage => _showLoginPage;
  bool _showLoginPage = false;
  set showLoginPage(bool value) {
    if (_showLoginPage == value) {
      return;
    }
    _showLoginPage = value;
    notifyListeners();
  }

  bool get showPrivacyPage => _showPrivacyPage;
  bool _showPrivacyPage = false;
  set showPrivacyPage(bool value) {
    if (_showPrivacyPage == value) {
      return;
    }
    _showPrivacyPage = value;
    notifyListeners();
  }

  Future<void> _handlePopDetails(bool didPop, void result) async {
    if (didPop) {
      if (showPrivacyPage) showPrivacyPage = false;
      if (showLoginPage) showLoginPage = false;
      return;
    }
  }

  List<Page<Object?>> _getPages() {
    return <Page<Object?>>[
      const MaterialPage<void>(
        key: ValueKey<String>('home'),
        child: _SettingsPage(),
      ),
      if (showLoginPage)
        MaterialPage<void>(
          key: const ValueKey<String>('Login'),
          child: const LoginSettings(),
          canPop: true,
          onPopInvoked: _handlePopDetails,
        ),
      if (showPrivacyPage)
        MaterialPage<void>(
          key: const ValueKey<String>('Privacy'),
          child: const PrivacySettings(),
          canPop: true,
          onPopInvoked: _handlePopDetails,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _getPages(),
      onDidRemovePage: (Page<Object?> page) {
        showLoginPage = false;
        showPrivacyPage = false;
      },
    );
  }
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BBond", style: TextStyle(color: Color(0xFF5E77DF), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w100,
                  fontSize: 16,
                  color: Color(0xFF454746),
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE7EFEE)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.desktop_windows, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("App Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {
                  MyRouterDelegate.of(context).showLoginPage = true;
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.alternate_email, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Login Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {
                  MyRouterDelegate.of(context).showPrivacyPage = true;
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.no_photography, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Privacy Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.key, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Safety Settings", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.list, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("Legal Information", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: OutlinedButton(
                onPressed:() {}, // Implement functionality
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE7EFEE)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(Icons.help_outline, color: Color(0xFF2C519C)),
                    const SizedBox(width: 10),
                    Text("BoilerBond Guide", style: const TextStyle(color: Color(0xFF2C519C), fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
            ),
            Spacer(flex: 5)
          ]
        ),
      ),
    );
  }
}
