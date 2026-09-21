import 'package:flutter/material.dart';
import '../presentation/screens/main_navigation.dart';
import '../view/logo_screen.dart';
import '../view/no_internet_screen.dart';
import '../view/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Route<dynamic>? generateRoute(RouteSettings settings) {
  debugPrint('Navigating to: ${settings.name}');
  switch (settings.name) {
    case NoInternet.path:
      return MaterialPageRoute(builder: (_) => const NoInternet());
    case SplashScreen.path:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case LogoScreen.path:
      return MaterialPageRoute(builder: (_) => const LogoScreen());
    case MainNavigationScreen.path:
      return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
    default:
      return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
  }
}
