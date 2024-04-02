import 'package:blabber/pages/auth_page.dart';
import 'package:blabber/pages/profile_page.dart';
import 'package:blabber/pages/profile_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/login_or_register_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 249, 227, 30),
        ),
      ),
      home: const AuthPage(),
      routes: {
        '/login_or_register': (context) => const LoginOrRegisterPage(),
        '/home_page': (context) => Home(),
        '/profile_page': (context) {
          // Retrieve the userEmail from the arguments passed during navigation
          final String userEmail = ModalRoute.of(context)!.settings.arguments as String;

          // Return Profile widget with userEmail passed as an argument
          return Profile(userEmail: userEmail);
        },
        '/auth_page': (context) => AuthPage(),
        '/profile_settings_page': (context) => const ProfileSettingsPage(),
      },
    );
  }
}


