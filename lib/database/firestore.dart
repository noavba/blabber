/*
This database stores the posts (text for right now) have published in their app
It is stored in a collection called 'Posts' in Firebase

Each post contains
- A message (blab)
- Username of the user
- Timestamp

*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase{

  //current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  //get collection fo posts from database
  final CollectionReference posts = 
  FirebaseFirestore.instance.collection('Posts');

  //post a message

  Future<void> addPost(String message){
    return posts.add({
      'userEmail': user!.email,
      'postMessage': message,
      'timestamp': Timestamp.now(),
    });
  }

  //read posts froma  database

  Stream<QuerySnapshot> getPostsStream(){
    final postsStream = FirebaseFirestore.instance.collection('Posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
    return postsStream;
  }
}
