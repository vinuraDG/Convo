import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'screens/phone_number_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthWrapper(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/phone': (context) => const PhoneNumberScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  Future<bool> isUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isRegistered') ?? false;
  }

  Future<void> setUserRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder<bool>(
      future: authService.hasSeenOnboarding(),
      builder: (context, onboardingSnapshot) {
        if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // First time user - show onboarding
        if (onboardingSnapshot.data == false) {
          return const OnboardingScreen();
        }

        // Check if user is registered
        return FutureBuilder<bool>(
          future: authService.isUserRegistered(),
          builder: (context, registerSnapshot) {
            if (registerSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // User has seen onboarding but not registered
            if (registerSnapshot.data == false) {
              return const PhoneNumberScreen();
            }

            // User is registered - check Firebase auth state
            return StreamBuilder<User?>(
              stream: authService.authStateChanges,
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (authSnapshot.hasData) {
                  return const HomeScreen();
                }

                // User was registered but logged out - go to phone screen
                return const PhoneNumberScreen();
              },
            );
          },
        );
      },
    );
  }
}