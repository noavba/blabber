import 'package:flutter/material.dart';
import 'package:blabber/pages/login_page.dart';

class LoginButton extends StatelessWidget{

  
  final Function()? onTap;

  const LoginButton({super.key, required this.onTap});

  @override 
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 35),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Sign In",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        ),
      ),
    );
  }
}