import 'package:audioplayers/audioplayers.dart';
import 'package:blabber/components/like_button.dart';
import 'package:blabber/database/firestore.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioFilePath;
  final String postID;
  

  const AudioPlayerWidget({Key? key, required this.audioFilePath, required this.postID}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int likesCount = 0;
  bool isLiked = false;
  final FirestoreDatabase database = FirestoreDatabase();

  @override
  //when loaded run all these functions
  void initState() {
    super.initState();
    fetchLikesCount();
    checkIfPostLiked();
    //slider duration keeping track
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
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
  
  //like post 
  //can only like if its not liked already
  //if liked, then wait a second then grab all liked posts (if it tries to do it all at once then it wont work) (thats what .then(_)) does
  
  void likePost() {
    if(!isLiked){
      database.likePost(widget.postID).then((_){
      fetchLikesCount();
      if(mounted){
        setState((){
          isLiked = true;
        });
      }
      });
    } 
  }
  //uses check method to return if its liked or not. if it is liked then set to liked.
  void checkIfPostLiked() async {
    bool liked = await database.checkIfPostLiked(widget.postID);
    if (mounted) {
      setState(() {
        isLiked = liked;
      });
    }
}
  void fetchLikesCount() async {
  //sets a local variable in the file to the likes count from firebase
  int count = await FirestoreDatabase().getLikesCount(widget.postID);
  if(mounted){
    setState(() {
      likesCount = count;
    });
  }
  }
 
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //center content
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Column(
          children: [
            LikeButton(isLiked: isLiked, onTap: likePost),
            Text(likesCount.toString()), //display like count
          ],
        ),
        Column(children: [
            GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(
                      context, 
                      '/post_view_screen',
                      arguments: widget.postID,
                      
                      );
                      print("Post ID is: " + widget.postID);
                  },
                  child: const Icon(
                    Icons.comment,
                    size:30,
                  ),
                ),
        ],
        ),
        Slider(
          min: 0, 
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(), 
          onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await audioPlayer.seek(position);
            await audioPlayer.resume();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: CircleAvatar(
            radius: 15,
            child: IconButton(
              icon: Icon(
                //if its playing, make the icon a pause, if not then make it an arrow
                isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              iconSize: 10,
              onPressed: () async {
                if (isPlaying) {
                  //pressing the icon changes it to paused if playing
                  audioPlayer.pause();
                } else {
                  //pressing icon sets source to the widget audio path
                  audioPlayer.setSourceUrl(widget.audioFilePath);
                  audioPlayer.resume();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}