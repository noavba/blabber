import 'package:audioplayers/audioplayers.dart';
import 'package:blabber/components/audio_player_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blabber/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blabber/components/app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blabber/database/firestore.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  final String userEmail;

  const Profile({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDetailsFuture; // Define _userDetailsFuture
    final FirestoreDatabase database = FirestoreDatabase();

      get postCounter => postCounter;
      final audioPlayer = AudioPlayer();
       bool isPlaying = false;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    void showErrorMessage(String message, context){
      showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text(message),
          );
      },
      );
    }
    void _setStateIfMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    // Get user details using the email passed as an argument
    _userDetailsFuture = getUserDetails(widget.userEmail);
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

  super.dispose();
  }




    Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails(String userEmail) async {
      return await FirebaseFirestore.instance.collection("Users").doc(userEmail).get();
    }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

    ),
    drawer: AppDrawer(),
    body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _userDetailsFuture,
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } 
        //error
        else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } 
        //data received
        else if (snapshot.hasData) {
          Map<String, dynamic>? user = snapshot.data!.data();
          var userEmail = user!['email'];
          var userUsername = user['username'];

          return Column(
            children: [
              Expanded(flex: 2, child: _TopPortion(userEmail: userEmail)),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        userUsername,
                        style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile_settings_page');
                            },
                            heroTag: 'edit',
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 230, 230, 230),
                            label: const Text("Settings", style: TextStyle(color: Colors.black)),
                            icon: const Icon(Icons.settings, color: Colors.black),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'follow',
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 249, 28, 31),
                            label: const Text("Follow", style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.alternate_email, color: Colors.white),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'friend',
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 249, 226, 30),
                            label: const Text("Friend", style: TextStyle(color: Colors.black)),
                            icon: const Icon(Icons.group_add, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _ProfileInfoRow(),
                      
                    Container(
                    child: StreamBuilder(
                      stream: database.getPostsStream(),
                      builder: (context, snapshot) {
                        // Show loading circle
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // Get posts for specified email, userEmail is in the Firestore database
                        final posts = snapshot.data!.docs.where((post) => post['userEmail'] == userEmail).toList();

                        // No data?
                        if (snapshot.data == null || posts.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Text("No posts! It's pretty quiet in here..."),
                            ),
                          );
                        }

                        // Return as a list
                        return Expanded(
                          child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              // Get individual post
                              final post = posts[index];
                              // Get data for each post
                              String audioFilePath = post['audioFileURL'];
                              String userEmail = post['userEmail'];
                              // Convert timestamp to string
                              Timestamp timestamp = post['timestamp'];
                              String date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());

                              // Return as a list tile
                        return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              children: [ // Add some space between the profile picture and the text
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(date, style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                Expanded(
                                  child: AudioPlayerWidget(audioFilePath: audioFilePath),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text("No data");
        }
      },
    ),

  );
}
}


class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);



  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("B!@6beRs", 0),
    ProfileInfoItem("Followers", 0),
    ProfileInfoItem("Friends", 0),
  ];

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
final String userEmail;

  const _TopPortion({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover,
              image: NetworkImage('https://www.onlygfx.com/wp-content/uploads/2022/03/colorful-sound-wave-equalizer-2.png')),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
                children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('Users').doc(userEmail).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator(); // Show a loading indicator while data is loading
                          }

                          var userData = snapshot.data!.data() as Map<String, dynamic>;
                          var imageURL = userData['pfp'];

                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageURL)),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                
                  ),
                ),
               );
             },
          ) 

              ],
            ),
          ),
        )
      ],
 
    );
  }
}