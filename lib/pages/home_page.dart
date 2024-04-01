import 'package:audioplayers/audioplayers.dart';
import 'package:blabber/components/my_text_field.dart';
import 'package:blabber/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:blabber/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/components/app_drawer.dart';
import 'package:blabber/components/post_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';


class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void Function()? onTap;
  final recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();
  bool isRecorderReady = false;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
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
    setAudio();
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

  Future setAudio() async {
    audioPlayer.setSourceUrl("https://audio.jukehost.co.uk/mcKzeq26vX12fLheAkLamTmbrkVDlBYX");
  }
  @override
  void dispose(){
    audioPlayer.dispose();
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async{
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
      throw "error";
    }
    await recorder.openRecorder();
    isRecorderReady = true;

  }

  //recording start
  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }
  //recording end
  Future stop() async {
    if(!isRecorderReady) return;
    await recorder.stopRecorder();
  }

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

      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ElevatedButton(child: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic, size: 40,

                ),
                onPressed: () async {
                  if(recorder.isRecording){
                    await stop();
                  } else {
                    await record();
                  }
                  setState((){});
                },
                ),
                //Expanded(
                  //child: MyTextField(controller: newPostController, hintText: "BLAB!!", obscureText: false)
                  //),
                  //PostButton(onTap: postMessage,
                  //),
                  Slider(min: 0, max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(), onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                  },
                  ),
                  CircleAvatar(
                    radius: 15,
                    child: IconButton(icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 10,
                    onPressed: () async {
                      if(isPlaying){
                        await audioPlayer.pause();
                        
                      } else {

                        await audioPlayer.resume();

                      }
                    },
                    ),
                  ),
                  PostButton(onTap: postMessage),
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
                child: Container(
        
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
                  
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(message),
                          subtitle: Text(userEmail),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )

      ],
      )
    );
  }
}