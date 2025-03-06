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
      '/profile/edit_profile': (context) => AuthMiddleware(child: EditProfile()),
      '/onboarding': (context) => AuthMiddleware(child: OnBoarding()),
      '/purdue_verification': (context) => const PurdueVerificationScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: Dashboard()));
      case '/settings/app':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: AppSettings()));
      case '/settings/danger_zone':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: DangerZone()));
      case '/settings/privacy':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: PrivacySettings()));
      case '/profile/edit_profile':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: EditProfile()));
      case '/onboarding':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: OnBoarding()));
      case '/purdue_verification':
        return MaterialPageRoute(builder: (context) => const PurdueVerificationScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("404 - Page Not Found")),
          ),
        );
    }
  }
}
