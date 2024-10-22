import 'package:flutter/material.dart';
import 'package:resq_ai/screens/blog_screen.dart';
import 'package:resq_ai/screens/contactScreen.dart';
import 'package:resq_ai/screens/home_screen.dart';
import 'package:resq_ai/screens/medicalinfo_screen.dart';
import 'package:resq_ai/screens/onboarding_screen.dart';
import 'package:resq_ai/screens/safe_locations_screen.dart';
import 'package:resq_ai/screens/setting_screen.dart';
import 'package:resq_ai/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQ SOS',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      routes: _buildRoutes(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => const SplashScreen(),
      '/onboarding': (context) => const OnboardingScreen(),
      '/home': (context) => const HomeScreen(),
      '/safe_locations': (context) => const SafeLocationsScreen(),
      '/blog_post': (context) => const BlogScreen(),
      '/medical_info': (context) => const MedicalInfoScreen(),
      '/contacts': (context) => const ContactsScreen(),
      '/settings': (context) => const SettingsScreen(),
    };
  }
}
