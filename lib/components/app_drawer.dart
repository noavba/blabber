import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget{


  
  AppDrawer({super.key});

  

  //this handles all navigation through the app bar    
  //im going to  scream
    void signUserOut(context) async {
      await FirebaseAuth.instance.signOut();
      Navigator.popAndPushNamed(context, '/login_or_register'); 
    }

  @override 
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children:[
            const DrawerHeader(
              child: Image(image: AssetImage('lib/assets/blabber.png')),
              ),

              //home page

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,

                  ),
                  title: const Text("Home Page"),
                  onTap: (){
                    
                      Navigator.pop(context); // Close the drawer
                      Navigator.pushReplacementNamed(context, '/home_page'); // Close the current page and push home page
                  }
                  ),
                ),



                //profile
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: const Text("Your Profile"),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      User? user = FirebaseAuth.instance.currentUser;
                        // Check if the user is signed in
                        if (user != null) {
                          // Get the current user's email
                          String currentUserEmail = user.email!;
                      Navigator.pushReplacementNamed(
                        context,
                        '/profile_page',
                        arguments: currentUserEmail, // Pass the relevant user's email as an argument
                      );
                    };
                    },
                  ),
                ),


                //settings
                
                Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.inversePrimary,

                  ),
                  title: const Text("Settings"),
                  onTap: (){
                  }
                  ),
                ),

                //log out
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.inversePrimary,

                    ),
                    title: const Text("Log Out"),
                    onTap: (){
                      signUserOut(context);
                    }
                  ),
                ),



        ],),
    );
  }
}