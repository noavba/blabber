import 'package:blabber/pages/auth_page.dart';
import 'package:blabber/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
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
  const MyApp({super.key});
  

  // This widget is the root of your application.
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
        '/profile_page': (context) => Profile(),
        '/auth_page': (context) => AuthPage(),
        

      }
    );
  }
}


