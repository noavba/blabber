import 'package:blabber/components/my_text_field.dart';
import 'package:blabber/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:blabber/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/components/app_drawer.dart';
import 'package:blabber/components/post_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  Home({super.key});
  void Function()? onTap;
  //firestore access

  final FirestoreDatabase database = FirestoreDatabase();

  TextEditingController newPostController = TextEditingController();

  //post message

  void postMessage(){
    //only post message if there is something there
    if(newPostController.text.isNotEmpty){
        String message = newPostController.text;
        database.addPost(message);
    }
    
    newPostController.clear();

  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(controller: newPostController, hintText: "BLAB!!", obscureText: false)
                  ),
                  PostButton(onTap: postMessage,
                  )
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              //show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              //get all posts
              final posts = snapshot.data!.docs;

              //no data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts to show, Be the first!"),
                  ),
                );
              }

              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    //get indiv post
                    final post = posts[index];
                    //get data for each post
                    String message = post['postMessage'];
                    String userEmail = post['userEmail'];
                    Timestamp timestamp = post['timestamp'];

                    //return as a list tile

                    return ListTile(
                      title: Text(message),
                      subtitle: Text(userEmail),
                    );
                  },
                ),
              );
            },
          )

      ],
      )
    );
  }
}