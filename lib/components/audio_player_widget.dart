import 'package:audioplayers/audioplayers.dart';
import 'package:blabber/components/like_button.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioFilePath;

  const AudioPlayerWidget({Key? key, required this.audioFilePath}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
          Column(
            children: [
              LikeButton(isLiked: true, onTap: (){}),
                Text("1"),
            ],
          ),
              Slider(min: 0, max: duration.inSeconds.toDouble(),
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
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 10,
                    onPressed: () async {
                      if (isPlaying) {
                        audioPlayer.pause();
                      } else {
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