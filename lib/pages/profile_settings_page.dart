import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blabber/components/app_drawer.dart';
class ProfileSettingsPage extends StatefulWidget{
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  File ? _selectedImage;
  final User? currentUser = FirebaseAuth.instance.currentUser;


  String imageURL='';
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black)
              ),
              padding: const EdgeInsets.all(25),
              child: const Text("No Profile Picture selected"),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                child: const Text ("View Camera Roll"),
                onPressed: (){
                  _pickImageFromGallery();
                },
              ),
              ),

              Container(
                padding: const EdgeInsets.all(50),
                child: ElevatedButton(
                  child: const Text("Return to Profile"),
                  onPressed: (){
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
                        }
                  } ,
                ),
              ),
          ]


              
          ),



        ),
    );

  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnedImage == null) return;
    setState((){
      _selectedImage = File(returnedImage.path);
    });
    
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child("pfp");

      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
      try{

        await referenceImageToUpload.putFile(File(returnedImage.path));
        imageURL= await referenceImageToUpload.getDownloadURL();
        await FirebaseFirestore.instance.collection('Users').doc(currentUser!.email).update({
          'email': currentUser!.email,
          'pfp': imageURL,
        });




      } catch(e){

      }
  }


  
}
