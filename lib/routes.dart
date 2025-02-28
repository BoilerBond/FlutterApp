import 'package:flutter/material.dart';
import 'package:datingapp/utils/middlewares/auth_middleware.dart';
import 'package:datingapp/presentation/screens/dashboard/dashboard.dart';
import 'package:datingapp/presentation/screens/onboarding/onboarding.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/privacy_settings/privacy_settings.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_profile.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/danger_zone/danger_zone.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => AuthMiddleware(child: Dashboard()),
      '/settings/danger_zone': (context) => AuthMiddleware(child: DangerZone()),
      '/settings/privacy': (context) => AuthMiddleware(child: PrivacySettings()),
      '/profile/edit_profile': (context) => AuthMiddleware(child: EditProfile()),
      '/onboarding': (context) => AuthMiddleware(child: OnBoarding())
    };
  }
}
