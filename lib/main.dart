import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/service_locator.dart';
import 'service/navigation_services.dart';
import 'theme/color_scheme.dart';
import 'theme/typograpghy.dart';
import 'view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const NetflixClone());
}

class NetflixClone extends StatelessWidget {
  const NetflixClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Movie Discovery',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: darkColorScheme.surface,
        colorScheme: darkColorScheme,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          foregroundColor: darkColorScheme.onSurface,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: darkColorScheme.primary,
        ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: generateRoute,
      navigatorKey: navigatorKey,
    );
  }
}
