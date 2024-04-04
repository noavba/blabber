import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/pages/home_page.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override 

  //all this file does is determine whether a user is logged in or not,
  //user never "sees" this page.

  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //if user logged in
          if(snapshot.hasData){
            return Home();
          } else {
            //if not logged in then go here
            return const LoginOrRegisterPage();
          }
        }
      ),
    );
  }
}