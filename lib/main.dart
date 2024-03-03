import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';


void main() async {


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //when creating a new page; use '/route name' and then the context is the class name that is created
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/homePage': (context) => Home(),
      }
    );
  }
}


