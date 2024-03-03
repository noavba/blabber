import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:blabber/components/MyTextField.dart';
import 'package:blabber/components/LoginButton.dart';


class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  //login fields controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  //sign user in
  void signUserIn(){
  
  }
  
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 44, 46),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 50),
          const Text("Temporary Login Screen",
            style:TextStyle(color: Colors.white),
            ),
          
          const SizedBox(height: 50),

          //username textfield

          MyTextField(
            controller: usernameController,
            hintText: 'Username',
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
                  'Forgot Password?',
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
          
          
          
          const SizedBox(height: 25),


         ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/homePage');
          }, child: const Text('Temporary Scene Switcher')),


          // sign up

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Not a member?',
              style: TextStyle(
                color: Colors.white),
              ),
            SizedBox(width:4),
            Text(
              'Register Now!',
              style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
              ),
          ],
          ),
        ],
        ),
      )
    );
  }
}