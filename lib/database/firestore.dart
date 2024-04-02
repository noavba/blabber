/*
This database stores the posts (text for right now) have published in their app
It is stored in a collection called 'Posts' in Firebase

Each post contains
- A message (blab)
- Username of the user
- Timestamp

*/
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreDatabase{

  //current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  //get collection fo posts from database
  final CollectionReference posts = 
  FirebaseFirestore.instance.collection('Posts');

  //post a message

  Future<DocumentReference<Object?>> addPost(String audioFileURL) async {
    // Upload audio file to Firebase Storage
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('audio_files')
        .child('${DateTime.now().millisecondsSinceEpoch}.mp3');
    UploadTask uploadTask = storageRef.putFile(File(audioFileURL));
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await snapshot.ref.getDownloadURL();
    
    DocumentReference postRef = await posts.add({
      'userEmail': user!.email,
      'timestamp': Timestamp.now(),
      'audioFileURL': downloadURL,
      'likes': 0,
      'postID': 'placeholder',
    });
    await postRef.update({'postID': postRef.id});
    return postRef;
  }


  //like post
   Future<void> likePost(String postId) async {
      await posts.doc(postId).update({
        'likes': FieldValue.increment(1),
      });
      getLikesCount(postId);
    }

  //read posts froma  database

  Stream<QuerySnapshot> getPostsStream(){
    final postsStream = FirebaseFirestore.instance.collection('Posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
    return postsStream;
  }

  Future<int> getLikesCount(String postId) async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('Posts').doc(postId).get();
    int likes = postSnapshot.get('likes') ?? 0;
    return likes; 
  }
}
