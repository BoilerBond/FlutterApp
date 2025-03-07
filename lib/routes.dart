import 'package:datingapp/presentation/screens/dashboard/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/utils/middlewares/auth_middleware.dart';
import 'package:datingapp/presentation/screens/dashboard/dashboard.dart';
import 'package:datingapp/presentation/screens/onboarding/onboarding.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/privacy_settings/privacy_settings.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_profile.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/danger_zone/danger_zone.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/app_settings/app_settings.dart';
import 'package:datingapp/presentation/screens/purdue_verification/purdue_verification_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => AuthMiddleware(child: Dashboard()),
      '/settings/app': (context) => AuthMiddleware(child: AppSettings()),
      '/settings/danger_zone': (context) => AuthMiddleware(child: DangerZone()),
      '/settings/privacy': (context) => AuthMiddleware(child: PrivacySettings()),
      '/profile': (context) => AuthMiddleware(child: ProfileScreen()),
      '/profile/edit_profile': (context) => AuthMiddleware(child: EditProfile()),
      '/onboarding': (context) => AuthMiddleware(child: OnBoarding()),
      '/purdue_verification': (context) => const PurdueVerificationScreen(),
    };
  }
}
