import 'package:datingapp/presentation/screens/dashboard/profile/profile_privacy.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/view_profile.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/legal_information/legal_information.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/user_guide/boilerbond_guide.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/blocked_profiles/blocked_profiles.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/utils/middlewares/auth_middleware.dart';
import 'package:datingapp/presentation/screens/dashboard/dashboard.dart';
import 'package:datingapp/presentation/screens/onboarding/onboarding.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/privacy_settings/privacy_settings.dart';
import 'package:datingapp/presentation/screens/dashboard/profile/edit_profile.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/danger_zone/danger_zone.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/app_settings/app_settings.dart';
import 'package:datingapp/presentation/screens/purdue_verification/purdue_verification_screen.dart';
import 'package:datingapp/presentation/screens/app_description/app_description_screen.dart';
import 'package:datingapp/presentation/screens/login/login_screen.dart';
import 'package:datingapp/presentation/screens/register/register_screen.dart';
import 'package:datingapp/presentation/screens/tos/terms_of_service.dart';

class Routes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Map<dynamic, dynamic> arguments = (settings.arguments ?? {}) as Map<dynamic, dynamic>;

    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => AuthMiddleware(child: Dashboard()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 150),
        );
      case '/register':
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case '/settings/app':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: AppSettings()));
      case '/settings/danger_zone':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: DangerZone()));
      case '/settings/privacy':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: PrivacySettings()));
      case '/settings/user_guide':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: BoilerBondGuide()));
      case '/settings/legal_information':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: LegalInformation()));
      case '/settings/blocked_profiles':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: BlockedProfiles()));
      case '/profile/edit_profile':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: EditProfile()));
      case '/profile/view_profile':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: ViewProfileScreen()));
      case '/profile/profile_privacy':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: ProfilePrivacyScreen()));
      case '/onboarding':
        return MaterialPageRoute(builder: (context) => AuthMiddleware(child: OnBoarding()));
      case '/app_description':
        return MaterialPageRoute(builder: (context) => AppDescriptionScreen(arguments: arguments));
      case '/terms_of_service':
        return MaterialPageRoute(builder: (context) => TermsOfServicePage(arguments: arguments));
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
