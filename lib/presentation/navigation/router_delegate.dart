import 'package:flutter/material.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/my_profile/edit_profile.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/login_settings/login_settings.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/privacy_settings/privacy_settings.dart';

class AppRouterDelegate extends RouterDelegate<Object>
    with PopNavigatorRouterDelegateMixin<Object>, ChangeNotifier {
  @override
  Future<void> setNewRoutePath(Object configuration) async =>
      throw UnimplementedError();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static AppRouterDelegate of(BuildContext context) =>
      Router.of(context).routerDelegate as AppRouterDelegate;

  bool get showEditProfilePage => _showEditProfilePage;
  bool _showEditProfilePage = false;
  set showEditProfilePage(bool value) {
    if (_showEditProfilePage == value) return;
    _showEditProfilePage = value;
    notifyListeners();
  }

  bool get showLoginPage => _showLoginPage;
  bool _showLoginPage = false;
  set showLoginPage(bool value) {
    if (_showLoginPage == value) return;
    _showLoginPage = value;
    notifyListeners();
  }

  bool get showPrivacyPage => _showPrivacyPage;
  bool _showPrivacyPage = false;
  set showPrivacyPage(bool value) {
    if (_showPrivacyPage == value) return;
    _showPrivacyPage = value;
    notifyListeners();
  }

  Future<void> _handlePopDetails(bool didPop, void result) async {
    if (didPop) {
      if (showEditProfilePage) showEditProfilePage = false;
      if (showLoginPage) showLoginPage = false;
      if (showPrivacyPage) showPrivacyPage = false;
    }
  }

  List<Page<Object?>> _getPages(Widget home) {
    return <Page<Object?>>[
      MaterialPage<void>(
        key: const ValueKey<String>('home'),
        child: home,
      ),
      if (showEditProfilePage)
        MaterialPage<void>(
          key: const ValueKey<String>('EditProfile'),
          child: const EditProfile(),
          canPop: true,
          onPopInvoked: _handlePopDetails,
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
      pages: _getPages(const SizedBox()),
      onDidRemovePage: (Page<Object?> page) {

        if (showEditProfilePage) showEditProfilePage = false;
        if (showLoginPage) showLoginPage = false;
        if (showPrivacyPage) showPrivacyPage = false;

      },
    );
  }
}
