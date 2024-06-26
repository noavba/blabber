import 'package:audioplayers/audioplayers.dart';
import 'package:blabber/components/audio_player_widget.dart';
import 'package:blabber/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:blabber/components/app_drawer.dart';
import 'package:blabber/components/post_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void Function()? onTap;
  //initalize recorder and audio player
  final recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();
  bool isRecorderReady = false;
  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  //firestore access
  final FirestoreDatabase database = FirestoreDatabase();


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
      //creates temporary directory to store the recorded audio in
      String path = await getTemporaryDirectory().then((dir) => dir.path);
      String filePath = '$path/audio.aac';
    await recorder.startRecorder(toFile: filePath);
  }
  //recording end
  Future stop() async {
    if(!isRecorderReady) return;
    await recorder.stopRecorder();
      String path = await getTemporaryDirectory().then((dir) => dir.path);
      String filePath = '$path/audio.aac';
      audioPlayer.setSourceDeviceFile(filePath);
      return filePath;
  }

  //post message
  void postBlab() async {
    //only post message if there is something there
        String filePath = await stop();
          if (filePath.isNotEmpty) {
            database.addPost(filePath);
          }
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
                  //slider to show audio duration (UI)
                  Slider(min: 0, max: 15,
                  value: position.inSeconds.toDouble(), onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioPlayer.seek(position);

                    await audioPlayer.resume();
                  },
                  ),
                  //shows the buttons
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
                  PostButton(onTap: postBlab),
              ],
              

            ),
          ),
          //building all the posts from the getstreams method
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              //show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                 child: Text("WAITING ON CONNECTION!"),
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
                      String audioFilePath = post['audioFileURL'];
                      String userEmail = post['userEmail'];
                      Timestamp timestamp = post['timestamp'];
                      int likes = post['likes'] ?? 0;
                      String postID = post['postID'];
                      String date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
                      

                      //return as a list tile
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance.collection('Users').doc(userEmail).snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.data == null) {
                                  return const CircularProgressIndicator(); // Show a loading indicator while data is loading
                            }
                            var userData = snapshot.data!.data() as Map<String, dynamic>;
                            var imageURL = userData['pfp'];
                            var username = userData['username'];

                      // return a card for each post that holds the data for each post
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
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
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundImage: imageURL != null ? NetworkImage(imageURL) : null,
                                  ),
                                  const SizedBox(width: 8), // Add some space between the profile picture and the text
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(username),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(date, style: const TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AudioPlayerWidget(audioFilePath: audioFilePath, postID: postID,),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
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