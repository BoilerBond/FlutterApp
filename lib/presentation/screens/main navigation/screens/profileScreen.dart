import 'dart:io';

import 'package:datingapp/presentation/screens/dashboard/settings/my_profile/edit_profile.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyProfileScreen());

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final RouterDelegate<Object> delegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerDelegate: delegate);
  }
}

class MyRouterDelegate extends RouterDelegate<Object>
    with PopNavigatorRouterDelegateMixin<Object>, ChangeNotifier {
  @override
  Future<void> setNewRoutePath(Object configuration) async =>
      throw UnimplementedError();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static MyRouterDelegate of(BuildContext context) =>
      Router.of(context).routerDelegate as MyRouterDelegate;

  bool get showEditProfilePage => _showEditProfilePage;
  bool _showEditProfilePage = false;
  set showEditProfilePage(bool value) {
    if (_showEditProfilePage == value) {
      return;
    }
    _showEditProfilePage = value;
    notifyListeners();
  }

  // repeat for other subpages

  Future<void> _handlePopDetails(bool didPop, void result) async {
    if (didPop) {
      if (showEditProfilePage) showEditProfilePage = false;
      return;
    }
  }

  List<Page<Object?>> _getPages() {
    return <Page<Object?>>[
      const MaterialPage<void>(
        key: ValueKey<String>('home'),
        child: _MyProfilePage(),
      ),
      if (showEditProfilePage)
        MaterialPage<void>(
          key: const ValueKey<String>('Login'),
          child: const EditProfile(),
          canPop: true,
          onPopInvoked: _handlePopDetails,
        ),
      // REPEAT
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _getPages(),
      onDidRemovePage: (Page<Object?> page) {
        showEditProfilePage = false;
      },
    );
  }
}

class _MyProfilePage extends StatefulWidget {
  const _MyProfilePage();

  @override
  State<_MyProfilePage> createState() => _MyProfilePageState();
}


class _MyProfilePageState extends State<_MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BBond", style: TextStyle(color: Color(0xFF5E77DF), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome back, [username]',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none, 
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                child: const Icon(Icons.image, size: 200, color: Color(0xFFCDFCFF)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      MyRouterDelegate.of(context).showEditProfilePage = true;
                    },
                    child: const Text(
                      'Edit profile',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Color(0xFF2C519C),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const Text('|', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigation to View Profile Screen
                    },
                    child: const Text(
                      'View profile',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Color(0xFF2C519C),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EFEE),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Prompt of the day',
                      style: TextStyle(
                        color: Color(0xFF2C519C),
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.none, 
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '[Personal question]?',
                      style: TextStyle(
                        color: Color(0xFF2C519C),
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.none, 
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'My answer...',
                      style: TextStyle(
                        color: Color(0xFF454746),
                        fontFamily: 'Raleway',
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}