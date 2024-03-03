import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/pages/login_page.dart';
import 'package:blabber/pages/home_page.dart';


class AuthPage extends StatelessWidget{
  const AuthPage({super.key});
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //if user logged in
          if(snapshot.hasData){
            return Home();
          } else {
            return LoginPage();
          }
          //if not logged in
        }
      ),
    );
  }
}