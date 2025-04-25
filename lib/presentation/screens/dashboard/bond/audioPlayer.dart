import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String uri;
  AudioPlayerWidget({super.key, required this.uri});

  @override State<AudioPlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<AudioPlayerWidget> {
  final player = AudioPlayer();
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  initState() {
    super.initState();
    player.setUrl(widget.uri);

    player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });

    player.durationStream.listen((d) {
      setState(() {
        duration = d!;
      });
    });

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          position = Duration.zero;
        });
        player.pause();
        player.seek(position);
      }
    });
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  void playerReset() {
    if (player.playerState.processingState == ProcessingState.completed) {
      player.seek(Duration.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                onPressed: handlePlayPause
            ),
            Column(
                children: [
                  Text(formatDuration(position), style: TextStyle(color: Colors.white),),
                  Slider(
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: handleSeek,
                    activeColor: Colors.white,
                  )
                ]
            )
          ]
      )
    );
  }
}