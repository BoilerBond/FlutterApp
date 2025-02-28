import 'package:flutter/material.dart';
import 'package:datingapp/presentation/screens/login/login_screen.dart';
import 'package:datingapp/presentation/screens/dashboard/dashboard.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/login_settings/login_settings.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/privacy_settings/privacy_settings.dart';
import 'package:datingapp/presentation/screens/purdue_verification/purdue_verification_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // TODO: modify the home route to go to the home screen
      '/': (context) => const LoginScreen(),
      '/login': (context) => const LoginScreen(),
      '/dashboard': (context) => const Dashboard(),
      '/dashboard/settings/login': (context) => const LoginSettings(),
      '/dashboard/settings/privacy': (context) => const PrivacySettings(),
      '/purdue_verification': (context) => const PurdueVerificationScreen(),
    };
  }
}
