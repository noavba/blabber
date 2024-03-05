import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser!;

class AppDrawer extends StatelessWidget{

  AppDrawer({super.key});



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
              child:Text(user.email!),
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