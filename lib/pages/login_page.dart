import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class LoginPage extends StatelessWidget{
  const LoginPage({super.key});
  
  @override Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: Column(children: [
           
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/homePage');
            }, child: Text('Login'))
            //blabber logo
              
          
          
            //username textfield
          
            // pw textfield
          
            //forgot password
          
            //sign in
          
            // sign up
          ],),
        ),
      )
    );
  }
}