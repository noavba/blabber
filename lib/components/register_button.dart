import 'package:flutter/material.dart';
import 'package:blabber/pages/signup_page.dart';

class RegisterButton extends StatelessWidget{

  
  final Function()? onTap;

  const RegisterButton({super.key, required this.onTap});

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
              "Create Account",
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