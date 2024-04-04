import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blabber/components/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/components/register_button.dart';
import 'login_page.dart';




class RegisterPage extends StatefulWidget{
  final  Function()? onTap;  
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //login fields controllers
  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordConfirmationController  = TextEditingController();

  //sign user in
  void registerUser() async {

      //creating loading circle
      showDialog(context: context, builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
  );

  try{
    if(passwordController.text == passwordConfirmationController.text){
      //try to create an account if passwords match
      UserCredential? userCredential = 
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      );
      //create user documeent and upload
      createUserDocument(userCredential);



    } else {
      //show error message if not
      showErrorMessage("Passwords do not match");
    }
    //pop loading circle on home page
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home_page');
  } on FirebaseAuthException catch (e) {
      //pop loading bubble
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }
  //this creates the user itself when you create an account
  //it sets the email and username and uploads it to firebase
  //default pfp can be changed here as well.
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if(userCredential != null && userCredential.user != null){
      await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'pfp': 'https://art.pixilart.com/cfcc704b81e7fd9.png',
      });
    }
  }

  void showErrorMessage(String message){

      showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text(message),
          );
      },
      );
    }

  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 44, 46),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const SizedBox(height: 50),
            const Text("B!@6beR", // name of the application is displayed
              style: TextStyle(color: Color.fromARGB(255, 249, 28, 31), fontWeight: FontWeight.w800, fontSize: 30 ),
              ),
              
            const SizedBox(height: 50),
          
            //email textfield
          
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          
            const SizedBox(height: 5),
            // username textfield
            MyTextField(
              controller: usernameController,
              hintText: 'Username',
              obscureText: false,
              ),
          
            const SizedBox(height:5),
          
            // pw textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
          
            // password confirmation
            const SizedBox(height:5),
          
          
            MyTextField(
              controller: passwordConfirmationController,
              hintText: 'Confirm Password',
              obscureText: true,
              ),
          
          
            //create user button
            const SizedBox(height: 25),
          
            RegisterButton(
              onTap: registerUser,
            ),
            
            
            //Sized boxes count as just white space inbetween elements
            const SizedBox(height: 25),
          
            // sign up
          
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Already a member?',
                style: TextStyle(
                  color: Colors.white),
                ),
              SizedBox(width:4),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  ' Sign in',
                  style: TextStyle( // button to switch back to the regular log in page
                    color: const Color.fromARGB(255, 249, 226, 30), fontWeight: FontWeight.bold),
                  ),
              ),
            ],
            ),
          ],
          ),
        ),
      )
    );
  }
}