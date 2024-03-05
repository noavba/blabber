import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:blabber/components/my_text_field.dart';
import 'package:blabber/components/login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginPage extends StatefulWidget{
  final  Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //login fields controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign user in
  void signUserIn() async {

    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );

    });

      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        
      );
      //popping loading screen
      Navigator.pop(context);
      
      Navigator.pushReplacementNamed(context, '/home_page');
      
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        //show error message
        showErrorMessage();

      }    
    }

      //error popup
    void showErrorMessage(){

      showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text("Invalid Email/Password"),
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
            const Text("Blabber",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30 ),
              ),
              const SizedBox(height: 20),
          
            const Text("Temporary Login Screen",
              style:TextStyle(color: Colors.white),
              ),
            
            const SizedBox(height: 50),
          
            //username textfield
          
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          
            const SizedBox(height: 5),
          
            // pw textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
          
            //forgot password
          
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'place holder - Forgot Password?',
                    style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
          
          
            //sign in
            const SizedBox(height: 25),
          
            LoginButton(
              onTap: signUserIn,
            ),
            
            
            //Sized boxes count as just white space inbetween elements
            const SizedBox(height: 25),
          
            // sign up
          
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Not a member?',
                style: TextStyle(
                  color: Colors.white),
                ),
              SizedBox(width:4),
              GestureDetector(
                onTap: widget.onTap,
                  child: const Text(
                  ' Place holder - Register Now!',
                  style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
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