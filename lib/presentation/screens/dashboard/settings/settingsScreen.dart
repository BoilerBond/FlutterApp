import 'package:flutter/material.dart';
import './login_settings/login_settings.dart';
import './privacy_settings/privacy_settings.dart';

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

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _handlePopDetails(bool didPop, void result) async {
    if (didPop) {
      if (showPrivacyPage) showPrivacyPage = false;
      if (showLoginPage) showLoginPage = false;
      return;
    }
    final bool confirmed = await _showConfirmDialog();
    if (confirmed) {
      if (showPrivacyPage) showPrivacyPage = false;
      if (showLoginPage) showLoginPage = false;
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
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          children: [
            Divider(),
            TextButton(style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.08), // Button width and height
              ),
              onPressed: () {},
              child: const Text('App Settings'),
            ),
            Spacer(),
            TextButton(style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.08), // Button width and height
              ),
              onPressed: () {
                MyRouterDelegate.of(context).showLoginPage = true;
              },
              child: const Text('Login Settings'),
            ),
            Spacer(),
            TextButton(style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.08), // Button width and height
              ),
              onPressed: () {
                MyRouterDelegate.of(context).showPrivacyPage = true;
              },
              child: const Text('Privacy Settings'),
            ),
            Spacer(),
            TextButton(style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.08), // Button width and height
              ),
              onPressed: () {},
              child: const Text('Safety Settings'),
            ),
            Spacer(),
            TextButton(style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.08), // Button width and height
              ),
              onPressed: () {},
              child: const Text('Legal Information'),
            ),
            Spacer(),
            TextButton(style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.08), // Button width and height
              ),
              onPressed: () {},
              child: const Text('BoilerBond Guide'),
            ), 
            Spacer(flex: 5)
          ]
        ),
      ),
    );
  }
}
