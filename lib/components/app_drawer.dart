import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/pages/home_page.dart';
import 'package:blabber/pages/profile_page.dart';




class AppDrawer extends StatelessWidget{


  
  AppDrawer({super.key});

  

    // THIS IS REALLY GROSS NAVIGATION WE ARE GOING TO SWAP IT LATER
    //I CBA TO DEAL WIHT THIS ANY TIME SOON DISGUSTING ANDROIDS

  //im goignt o fucking scream
    void signUserOut(context) async {
      await FirebaseAuth.instance.signOut();
      Navigator.popAndPushNamed(context, '/login_or_register'); // Example route to navigate to after signout
    }

  @override 
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children:[
            DrawerHeader(
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
                  title: Text("Home Page"),
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
                  title: Text("Your Profile"),
                  onTap: (){
                      Navigator.pop(context); // Close the drawer
                      Navigator.pushReplacementNamed(context, '/profile_page'); // Close the current page and push profile page
                  }
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
                  title: Text("Settings"),
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
                    title: Text("Log Out"),
                    onTap: (){
                      signUserOut(context);
                    }
                  ),
                ),



        ],),
    );
  }
}