/*
This database stores the posts (text for right now) have published in their app
It is stored in a collection called 'Posts' in Firebase

Each post contains
- A message (blab)
- Username of the user
- Timestamp
- likes 
- liked by (keeps track of which accounts liked it)

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

  //get a collection for comments
  final CollectionReference comments = 
  FirebaseFirestore.instance.collection('Comments');

  //post a blab
  //passed an audio file
  //
  Future<DocumentReference<Object?>> addPost(String audioFileURL) async {
    // Upload audio file to Firebase Storage
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('audio_files')
        //names the file a unique filename using datatime
        .child('${DateTime.now().millisecondsSinceEpoch}.mp3');
    //firebase upload task 
    UploadTask uploadTask = storageRef.putFile(File(audioFileURL));
    // upload
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    //this redownloads the file for use in the app itself
    String downloadURL = await snapshot.ref.getDownloadURL();
    
    DocumentReference postRef = await posts.add({
      'userEmail': user!.email,
      'timestamp': Timestamp.now(),
      'audioFileURL': downloadURL,
      'likes': 0,
      'postID': 'placeholder',
      'likedBy': [],
      'commentID': 'comment'
    });
    await postRef.update({'postID': postRef.id});
    return postRef;
  }


  //like post
   Future<void> likePost(String postId) async {
    // grabs user id (email) to store to see who liked the post
    var userId = FirebaseAuth.instance.currentUser!.email;
    //creates document datafile of the post passed to it 
    DocumentSnapshot postSnapshot = await posts.doc(postId).get();
    //creates list of people who liked it, and if the person who liked the post didn't isnt in the list,
    //adds it to the likedBy field, also increments the likes field by 1. 
    List<dynamic> likedBy = postSnapshot.get('likedBy') ?? [];
    if (!likedBy.contains(userId)) {
      likedBy.add(userId.toString());
      await posts.doc(postId).update({
        'likes': FieldValue.increment(1),
        'likedBy': likedBy,
      });
    } else {
      print('Post is already liked by the user');
    }
    //getlikescount is just a getter method for reading how many likes are in the post and returning it
    getLikesCount(postId);
}


    //method for checking if post has been liked or not
    //same logic as above but just returns a boolean
    // if liked = true if not = false
    Future<bool> checkIfPostLiked(String postId) async {
    
      var userId = FirebaseAuth.instance.currentUser?.email;
      DocumentSnapshot postSnapshot = await posts.doc(postId).get();
      List<dynamic> likedBy = postSnapshot.get('likedBy') ?? [];
      return likedBy.contains(userId.toString());
      }

  //read posts froma  database
  //used for streambuilder and to collect all posts from the database
  Stream<QuerySnapshot> getPostsStream(){
    final postsStream = FirebaseFirestore.instance.collection('Posts')
      .orderBy('timestamp', descending: true)
      .snapshots();
    return postsStream;
  }
  //self explanatory, makes a snapshot and gets likes for a passed post id
  Future<int> getLikesCount(String postId) async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('Posts').doc(postId).get();
    int likes = postSnapshot.get('likes');
    return likes; 
  }



  //SAME LOGIC FOR ADDING POST
  //NOT FULLY FUNCTIONING
  Future<DocumentReference<Object?>> addComment(
      String audioFileURL, String postId) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('comment_audio_files')
        .child('${DateTime.now().millisecondsSinceEpoch}.mp3');
    UploadTask uploadTask = storageRef.putFile(File(audioFileURL));
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await snapshot.ref.getDownloadURL();

    DocumentReference commentRef = await comments.add({
      'userEmail': user!.email,
      'timestamp': Timestamp.now(),
      'audioFileURL': downloadURL,
      'postId': posts.id,
    });

    return commentRef;
  }

  //SAME LOGIC AS ABOVE
  Stream<QuerySnapshot> getCommentsStream(String postId) {
    final commentsStream = FirebaseFirestore.instance
        .collection('Comments')
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots();
    return commentsStream;
  }
}
