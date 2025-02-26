import 'package:flutter/material.dart';
import 'package:datingapp/utils/middlewares/auth_middleware.dart';
import 'package:datingapp/presentation/screens/dashboard/dashboard.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/login_settings/login_settings.dart';
import 'package:datingapp/presentation/screens/dashboard/settings/privacy_settings/privacy_settings.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => AuthMiddleware(child: Dashboard()),
      '/settings/login': (context) => AuthMiddleware(child: LoginSettings()),
      '/settings/privacy': (context) => AuthMiddleware(child: PrivacySettings()),
    };
  }
}
