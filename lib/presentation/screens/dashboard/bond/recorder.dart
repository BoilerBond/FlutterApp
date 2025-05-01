import 'dart:async';
import 'dart:io';
import 'package:audio_duration/audio_duration.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';

import '../../../../data/entity/room.dart';

class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
  Timer? _timer;

  @override
  void initState() {
    _startAnimating();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimating() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // This is a simple way to rotate the list, creating a wave effect.
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: MediaQuery.sizeOf(context).height * height,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomRecordingButton extends StatefulWidget {
  const CustomRecordingButton({super.key,
    required this.audioRecorder,
    required this.uid,
    required this.roomID});

  final AudioRecorder audioRecorder;
  final String uid;
  final String roomID;
  @override
  State<StatefulWidget> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<CustomRecordingButton> {
  bool isRecording = false;
  String _audioPath = "";


  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${const Uuid().v1()}.wav');

      await widget.audioRecorder.start(
        const RecordConfig(
          // specify the codec to be `.wav`
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await widget.audioRecorder.stop();

      setState(() {
        _audioPath = path!;
      });
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
      }
    } else {
      await _stopRecording();

      setState(() {
        isRecording = false;
      });
    }
  }

  void _sendAudio() async {
    if (_audioPath != null) {
      final name = widget.uid + const Uuid().v4();
      final file = File(_audioPath!);
      int? durationInMilliSeconds = await AudioDuration.getAudioDuration(_audioPath!);

      try {
        final reference = FirebaseStorage.instance.ref("voice_messages/" + name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.AudioMessage(
          author: types.User(id: widget.uid),
          id: const Uuid().v4(),
          mimeType: lookupMimeType(_audioPath!),
          name: name,
          size: file.readAsBytesSync().lengthInBytes,
          duration: Duration(
              milliseconds: durationInMilliSeconds ?? 0
          ),
          uri: uri,
        );
        Room room = await Room.getById(widget.roomID);
        room.sendMessage(message);
      }
      catch (e) {
        print("Error sending audio file, " + e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async => await widget.audioRecorder.dispose(),
            icon: Icon(Icons.cancel),
            iconSize: 30,
          ),
          AnimatedContainer(
            height: 100,
            width: 100,
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(
              isRecording ? 25 : 15,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
                width: isRecording ? 8 : 3,
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
              ),
              child: MaterialButton(
                onPressed: _record,
                shape: const CircleBorder(),
                child: const SizedBox.shrink(),
              ),
            ),
          ),
          IconButton(
            onPressed: _sendAudio,
            icon: Icon(Icons.send),
            iconSize: 30,
          ),
        ]
    );
  }

}