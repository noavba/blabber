import 'package:flutter/material.dart';
import 'package:blabber/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions:[ElevatedButton(onPressed: signUserOut, child: Text("Sign Out"))],
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Text("Logged in as: " + user.email!,
          style: TextStyle(fontSize: 20)),
        ),
      );
  }
}