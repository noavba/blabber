import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser!;

final user = FirebaseAuth.instance.currentUser!;

class AppDrawer extends StatelessWidget{

<<<<<<< HEAD
  AppDrawer({super.key});

=======
  
>>>>>>> c815e9e437c98ae938979c5e021e6a3c1ef254c0


  //im goignt o fucking scream
    void signUserOut(){
      FirebaseAuth.instance.signOut();

    }

  @override 
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children:[
            DrawerHeader(
<<<<<<< HEAD
              child:Text(user.email!),
=======
              child: Text(user.email!),
>>>>>>> c815e9e437c98ae938979c5e021e6a3c1ef254c0
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
                      Navigator.pop(context);

                      Navigator.pushNamed(context,'/home_page');
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

                      Navigator.pushNamed(context, '/profile_page');
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
                      signUserOut();
                    }
                  ),
                ),



        ],),
    );
  }
}