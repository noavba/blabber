import 'package:audioplayers/audioplayers.dart';
import 'package:blabber/components/audio_player_widget.dart';
import 'package:blabber/components/my_text_field.dart';
import 'package:blabber/database/firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:blabber/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/components/app_drawer.dart';
import 'package:blabber/components/post_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class PostView extends StatefulWidget {
  PostView({super.key, required this.postID});
  final String postID;
  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  void Function()? onTap;
  final audioPlayer = AudioPlayer();
  bool isRecorderReady = false;
  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  //map to hold all the different audio players

  //firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  TextEditingController newPostController = TextEditingController();

  void _setStateIfMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
  

  @override
  void initState() {
    super.initState();
    initRecorder();
    // setAudio();
    // listen to audio player
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
    // listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  //Future setAudio() async {
    //audioPlayer.setReleaseMode(ReleaseMode.loop);

  //}
  @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
  }

  Future initRecorder() async{
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw "error";
    }

  }
  //recording start
    

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .doc(widget.postID) // Use widget.postID to get the specific post
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Text("Post not found"); // Show a message if the post is not found
              }

              // Get the post data
              var post = snapshot.data!.data() as Map<String, dynamic>;
              String audioFilePath = post['audioFileURL'];
              String userEmail = post['userEmail'];
              Timestamp timestamp = post['timestamp'];
              String date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').doc(userEmail).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return CircularProgressIndicator(); // Show a loading indicator while data is loading
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              var imageURL = userData['pfp'];
              var username = userData['username'];
            
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/profile_page',
                          arguments: userEmail, // Pass the relevant user's email as an argument
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          CircleAvatar(
                            backgroundImage: imageURL != null ? NetworkImage(imageURL) : null,
                          ),
                          SizedBox(width: 8), // Add some space between the profile picture and the text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(date, style: TextStyle(color: Colors.grey),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: AudioPlayerWidget(audioFilePath: audioFilePath, postID: widget.postID),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
            },),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ElevatedButton(child: Icon(
                  Icons.mic, size: 40,

                ),
                onPressed: () async {
                  //if(recorder.isRecording){
                    //await stop();
                  //} else {
                    //await record();
                  //}
                  //setState((){});
                },
                ),
                //Expanded(
                  //child: MyTextField(controller: newPostController, hintText: "BLAB!!", obscureText: false)
                  //),
                  //PostButton(onTap: postMessage,
                  //),
                  Slider(min: 0, max: 15,
                  value: position.inSeconds.toDouble(), onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                  },
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: IconButton(icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 20,
                    onPressed: () async {
                      if(isPlaying){
                        await audioPlayer.pause();
                        
                      } else {

                        await audioPlayer.resume();

                      }
                    },
                    ),
                  ),
                  //PostButton(onTap: postBlab),
              ],
              

            ),
          ),
          
      ],),
    );
  }
}