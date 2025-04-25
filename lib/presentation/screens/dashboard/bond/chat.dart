import 'dart:io';
import 'dart:math';

import 'package:audio_duration/audio_duration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/constants/icebreakers.dart';
import 'package:datingapp/presentation/screens/dashboard/bond/audioPlayer.dart';
import 'package:datingapp/presentation/screens/dashboard/bond/recorder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:datingapp/services/gemini_service.dart';
import 'package:datingapp/data/constants/dates.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/entity/app_user.dart';
import '../../../../data/entity/room.dart';

class ChatScreen extends StatefulWidget {
  final AppUser user;
  final AppUser match;
  final String roomID;
  ChatScreen(
      {super.key,
      required this.user,
      required this.match,
      required this.roomID});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? _currentPrompt;
  String? _matchAnswer;
  String? _userAnswer;
  bool _hasAnswered = false;
  bool _isAttachmentUploading = false;
  bool _isRecording = false;
  late final AudioRecorder _audioRecorder;
  String? _audioPath;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.match.firstName),
        ),
        body:
            Column(
            children: [
              if (_currentPrompt != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prompt: $_currentPrompt"),
                      if (!_hasAnswered)
                        TextField(onChanged: (val) => _userAnswer = val),
                      if (!_hasAnswered)
                        ElevatedButton(
                          onPressed: () => _submitDailyPromptAnswer(
                              _userAnswer ?? '',
                              "${widget.user.uid}_${widget.match.uid}_${DateTime.now().millisecondsSinceEpoch}"),
                          child: Text("Submit Answer"),
                        ),
                      if (_hasAnswered && _matchAnswer != null)
                        Text("Match's Answer: $_matchAnswer"),
                    ],
                  ),
                ),
              Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("rooms")
                          .doc(widget.roomID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>> msgsMap =
                            List<Map<String, dynamic>>.from(
                                snapshot.data?['messages'] ?? []);
                        List<types.Message> messages = parseMsgs(msgsMap);
                        return Chat(
                          isAttachmentUploading: _isAttachmentUploading,
                          messages: messages,
                          onAttachmentPressed: _handleAttachmentPressed,
                          onMessageTap: _handleMessageTap,
                          onMessageLongPress: _showDeletePrompt,
                          //onPreviewDataFetched: _handlePreviewDataFetched,
                          onSendPressed: _handleSendPressed,
                          customMessageBuilder: _customMessageBuilder,
                          audioMessageBuilder: _buildVoiceMessage,
                          showUserAvatars: true,
                          user: types.User(
                            id: widget.user.uid,
                          ),
                        );
                      })),
              ],)
      );

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 4,
          child: GridView.count(
              crossAxisCount: 3,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleImageSelection();
                      },
                      icon: Icon(Icons.photo),
                    ),
                    Text("Photo")
                  ]
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleFileSelection();
                        },
                        icon: Icon(Icons.file_copy)
                    ),
                    Text("File")
                  ]
                ),
                Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleVoiceRecording();
                        },
                        icon: Icon(Icons.mic),
                      ),
                      Text("Voice Message")
                    ]
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _sendDailyPrompt();
                        },
                        icon: Icon(Icons.date_range)
                    ),
                    Text("Daily Prompt"),
                  ]
                ),
                Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _iceBreaker();
                          },
                          icon: Icon(Icons.chat_bubble_outline)
                      ),
                      Text("Icebreaker"),
                    ]
                ),
                Column(
                  children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _openDateFilterDialog();
                    },
                    icon: Icon(Icons.lightbulb)
                  ),
                  Text("Date Idea")
                  ]
                )
              ]
        ),
      ),
    );
  }

  void _openDateFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String budgetLevel = 'medium'; // default
        return AlertDialog(
          title: Text('Filter Your Date Idea'),
          content: DropdownButtonFormField<String>(
            value: budgetLevel,
            onChanged: (val) => budgetLevel = val!,
            items: [
              DropdownMenuItem(value: 'low', child: Text('Low Budget')),
              DropdownMenuItem(value: 'medium', child: Text('Medium Budget')),
              DropdownMenuItem(value: 'high', child: Text('High Budget')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _generateAndSendDateIdea(budgetLevel);
              },
              child: Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  void _generateAndSendDateIdea(String budgetLevel) async {
    final filtered = dateIdeas.entries.where((entry) {
      final desc = entry.value.toLowerCase();
      if (budgetLevel == 'low') {
        return desc.contains('\$0') ||
            desc.contains('\$1') ||
            desc.contains('\$5') ||
            desc.contains('\$10');
      }
      if (budgetLevel == 'medium') {
        return desc.contains('\$20') ||
            desc.contains('\$25') ||
            desc.contains('\$30') ||
            desc.contains('\$35');
      }
      return desc.contains('\$45') ||
          desc.contains('\$60') ||
          desc.contains('\$75');
    }).toList();

    if (filtered.isEmpty) return;

    final selected = filtered[Random().nextInt(filtered.length)];

    // Build the idea payload expected by Room.sendDateIdea
    final idea = <String, dynamic>{
      'activity': selected.key,
      'description': selected.value,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final room = await Room.getById(widget.roomID);
    await room.sendDateIdea(idea, types.User(id: widget.user.uid));
  }

  void _iceBreaker() async {
    final selected = icebreakers[Random().nextInt(30)];
    types.TextMessage msg = types.TextMessage(
      author: types.User(id: widget.user.uid),
      text: selected,
      id: const Uuid().v6(),
    );
    final room = await Room.getById(widget.roomID);
    room.sendMessage(msg);
  }

  void _sendDailyPrompt() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (widget.user.lastDailyPromptTime == null) {
      widget.user.lastDailyPromptTime = 0;
    }
    if (now - widget.user.lastDailyPromptTime < 86400000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Daily prompt already sent today.")),
      );
      return;
    }

    _currentPrompt = await GeminiService().generateDailyPrompt();
    final promptId = "${widget.user.uid}_${widget.match.uid}_${now}";

    await FirebaseFirestore.instance
        .collection('daily_prompts')
        .doc(promptId)
        .set({
      'prompt': _currentPrompt,
      'timestamp': now,
      'users': [widget.user.uid, widget.match.uid],
    });

    String mid = widget.user.uid + now.toString() + "dp";
    final promptMessage = types.TextMessage(
      author: types.User(id: widget.user.uid),
      createdAt: now,
      id: mid,
      text: "Daily Prompt: $_currentPrompt",
    );

    _addMessage(promptMessage);

    // update user's Firestore record
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    await userRef.update({'lastDailyPromptTime': now});

    setState(() {
      widget.user.lastDailyPromptTime = now;
    });
  }

  Future<void> _submitDailyPromptAnswer(String answer, String promptId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final promptRef =
        FirebaseFirestore.instance.collection('daily_prompts').doc(promptId);
    await promptRef.set({
      'promptId': promptId,
      'timestamp': now,
      'prompt': _currentPrompt,
      'answers': {
        widget.user.uid: {
          'answer': answer,
          'answeredAt': now,
        }
      }
    }, SetOptions(merge: true));

    setState(() {
      _userAnswer = answer;
      _hasAnswered = true;
    });

    final promptDoc = await promptRef.get();
    final data = promptDoc.data();
    if (data != null && data['answers']?[widget.match.uid] != null) {
      _matchAnswer = data['answers'][widget.match.uid]['answer'];
    }

    final room = await Room.getById(widget.roomID);
    final answerMsg = types.CustomMessage(
      id: const Uuid().v4(),
      author: types.User(id: widget.user.uid),
      createdAt: now,
      metadata: {
        'customType': 'promptAnswer',
        'promptId': promptId,
        'answeredBy': widget.user.uid,
        'answer': answer,
      },
    );
    room.sendMessage(answerMsg);
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref("userFiles/" + name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.FileMessage(
          author: types.User(id: widget.user.uid),
          id: const Uuid().v4(),
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );
        Room room = await Room.getById(widget.roomID);
        room.sendMessage(message);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _showDeletePrompt(BuildContext context, types.Message msg) {
    if (msg.author.id == widget.user.uid) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete message?'),
            content: const Text('This action is irreversible'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async => {
                  _deleteMessage(msg),
                  Navigator.pop(context, 'OK'),
                },
                child: const Text('OK'),
              ),
            ],
          )
      );
    }
  }

  void _deleteMessage(types.Message msg) async {
    Room room = await Room.getById(widget.roomID);
    room.deleteMessage(msg);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref("images/"+name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.ImageMessage(
          author: types.User(id: widget.user.uid),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );
        Room room = await Room.getById(widget.roomID);
        room.sendMessage(message);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${const Uuid().v1()}.wav');

      await _audioRecorder.start(
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
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!;
      });
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (_isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          _isRecording = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
      }
    } else {
      await _stopRecording();

      setState(() {
        _isRecording = false;
      });
    }
  }

  void _sendAudio() async {
    if (_audioPath != null) {
      _setAttachmentUploading(true);
      final name = widget.user.uid + const Uuid().v4();
      final file = File(_audioPath!);
      int? durationInMilliSeconds = await AudioDuration.getAudioDuration(_audioPath!);

      try {
        final reference = FirebaseStorage.instance.ref("voice_messages/" + name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.AudioMessage(
          author: types.User(id: widget.user.uid),
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
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleVoiceRecording() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) return;

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: false,
        builder: (BuildContext context) => Container(
          height: MediaQuery.of(context).size.height / 4,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            IconButton(
              onPressed: () async => await _audioRecorder.dispose(),
              icon: Icon(Icons.cancel),
              iconSize: 30,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_isRecording) const CustomRecordingWaveWidget(),
                  const SizedBox(height: 16),
                  CustomRecordingButton(
                    isRecording: _isRecording,
                    onPressed: () => _record(),
                  ),
            ]),
            IconButton(
              onPressed: _sendAudio,
              icon: Icon(Icons.send),
              iconSize: 30,
            ),
          ])
        )
    );
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          // TODO: update the message
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          // TODO: update the message
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    String msgid = DateTime.now().millisecondsSinceEpoch.toString();
    msgid += widget.user.uid;
    final textMessage = types.TextMessage(
      author: types.User(id: widget.user.uid),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: msgid,
      text: message.text,
    );
    Room room = await Room.getById(widget.roomID);
    room.sendMessage(textMessage);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _addMessage(types.Message msg) async {
    Room room = await Room.getById(widget.roomID);
    room.sendMessage(msg);
  }

  Widget _customMessageBuilder(types.CustomMessage msg,
      {int messageWidth = 250}) {
    final meta = msg.metadata ?? {};
    switch (meta['customType']) {
      case 'dateIdea':
        return _buildDateIdea(msg, meta, messageWidth);
      case 'promptAnswer':
        return _buildPromptAnswer(meta, messageWidth);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildVoiceMessage(types.AudioMessage msg, {required int messageWidth}) {
    bool isMine = (msg.author.id == widget.user.uid);

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: isMine ? Color.from(alpha: 0, red: 111, green: 96, blue: 232): Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AudioPlayerWidget(uri: msg.uri)
    );
  }

  Widget _buildPromptAnswer(Map meta, int width) {
    final answer = meta['answer'] ?? '';
    final answeredBy = meta['answeredBy'];

    // Show partner’s answer only after I answered
    final shouldShow = answeredBy == widget.user.uid || _hasAnswered;

    if (!shouldShow) return const SizedBox.shrink();

    final isMine = answeredBy == widget.user.uid;
    return Container(
      width: width.toDouble(),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMine ? Colors.blue.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('${isMine ? "Your" : "Partner"} answer: $answer'),
    );
  }

  Widget _buildDateIdea(types.CustomMessage msg, Map meta, int width) {
    final idea = meta['dateIdea'] as Map?;
    final accepted = List<String>.from(meta['acceptedBy'] ?? []);
    final denied = List<String>.from(meta['deniedBy'] ?? []);
    final hasVoted =
        accepted.contains(widget.user.uid) || denied.contains(widget.user.uid);

    return Container(
      width: width.toDouble(),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Date Idea: ${idea?['activity']}'),
          if (idea?['location'] != null) Text('Location: ${idea?['location']}'),
          if (idea?['description'] != null) Text(idea?['description']),
          if (idea?['dateTime'] != null)
            Text(DateFormat('EEE, MMM d • h:mm a')
                .format(DateTime.parse(idea!['dateTime']))),
          const SizedBox(height: 6),
          if (!hasVoted)
            Row(
              children: [
                TextButton(
                  onPressed: () => _respondToDateIdea(msg, true),
                  child: const Text('Accept'),
                ),
                TextButton(
                  onPressed: () => _respondToDateIdea(msg, false),
                  child: const Text('Deny'),
                ),
              ],
            )
          else
            Text(
              accepted.contains(widget.user.uid)
                  ? 'You accepted'
                  : 'You denied',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }

  Future<void> _respondToDateIdea(
      types.CustomMessage message, bool accept) async {
    final room = await Room.getById(widget.roomID);
    final meta = Map<String, dynamic>.from(message.metadata ?? {});
    final acceptedBy = List<String>.from(meta['acceptedBy'] ?? []);
    final deniedBy = List<String>.from(meta['deniedBy'] ?? []);

    if (accept) {
      if (!acceptedBy.contains(widget.user.uid))
        acceptedBy.add(widget.user.uid);
      meta['acceptedBy'] = acceptedBy;
      meta['status'] = 'accepted';
    } else {
      if (!deniedBy.contains(widget.user.uid)) deniedBy.add(widget.user.uid);
      meta['deniedBy'] = deniedBy;
      meta['status'] = 'denied';
    }

    await room.updateMessage(message.id, {
      'acceptedBy': meta['acceptedBy'],
      'deniedBy': meta['deniedBy'],
      'status': meta['status'],
    });

    // summary text
    final summary = types.TextMessage(
      id: const Uuid().v4(),
      author: types.User(id: widget.user.uid),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: accept
          ? '${widget.user.firstName} accepted the date idea.'
          : '${widget.user.firstName} denied the date idea.',
    );
    room.sendMessage(summary);
  }

  List<types.Message> parseMsgs(List<Map<String, dynamic>> maps) {
    List<types.Message> result = [];
    for (Map<String, dynamic> e in maps) {
      switch (e['type']) {
        case 'audio':
          types.AudioMessage vmsg = types.AudioMessage(
              author: types.User(id: e['author']),
              createdAt: e['createdAt'],
              id: e['id'],
              duration: Duration(milliseconds: int.parse(e['duration'])),
              name: e['name'],
              size: e['size'],
              uri: e['uri']
          );
          result.add(vmsg);
          break;
        case 'image':
          types.ImageMessage imsg = types.ImageMessage(
            author: types.User(id: e['author']),
            createdAt: e['createdAt'],
            id: e['id'],
            name: e['name'],
            size: e['size'],
            uri: e['uri']
          );
          result.add(imsg);
          break;
        case 'file':
          types.FileMessage fmsg = types.FileMessage(
              author: types.User(id: e['author']),
              createdAt: e['createdAt'],
              id: e['id'],
              name: e['name'],
              size: e['size'],
              uri: e['uri']
          );
          result.add(fmsg);
          break;
        case 'dateIdea':
          types.CustomMessage msg = types.CustomMessage(
            author: types.User(id: e['author']),
            createdAt: e['createdAt'],
            id: e['id'],
            metadata: {
              'customType': 'dateIdea',
              'dateIdea': e['dateIdea'],
              'acceptedBy': e['acceptedBy'] ?? <String>[],
              'deniedBy': e['deniedBy'] ?? <String>[],
              'status': e['status'] ?? 'pending',
            },
          );
          result.add(msg);
          break;
        case 'promptAnswer':
          types.CustomMessage pmsg = types.CustomMessage(
            author: types.User(id: e['author']),
            createdAt: e['createdAt'],
            id: e['id'],
            metadata: {
              'customType': 'promptAnswer',
              'promptId': e['promptId'],
              'answeredBy': e['answeredBy'],
              'answer': e['answer'],
            },
          );
          result.add(pmsg);
          break;
        default:
          types.TextMessage msg = types.TextMessage(
              author: types.User(id: e['author']),
              createdAt: e['createdAt'],
              id: e['id'],
              text: e['text']);
          result.add(msg);
          break;
      }
    }
    return result;
  }
}
