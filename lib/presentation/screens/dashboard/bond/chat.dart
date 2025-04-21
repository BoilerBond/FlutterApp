import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:datingapp/services/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/constants/dates.dart';

import '../../../../data/entity/app_user.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatScreen extends StatefulWidget {
  final AppUser user;
  final AppUser match;
  const ChatScreen({super.key, required this.user, required this.match});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final List<types.Message> _messages = [
    types.TextMessage(
      author: types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac'),
      id: '1',
      text: 'ajdfklasjflksadfklsda test string1',
    ),
    types.TextMessage(
      author: types.User(id: '8adfadsfasdfsade2232312'),
      id: '2',
      text: 'test string2',
    ),
    types.TextMessage(
      author: types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac'),
      id: '3',
      text: 'test string3',
    ),
  ];

  String? _currentPrompt;
  String? _matchAnswer;
  String? _userAnswer;
  bool _hasAnswered = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.match.firstName),
    ),
    body: Column(
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
                    onPressed: () => _submitDailyPromptAnswer(_userAnswer ?? '', "${widget.user.uid}_${widget.match.uid}_${DateTime.now().millisecondsSinceEpoch}"),
                    child: Text("Submit Answer"),
                  ),
                if (_hasAnswered && _matchAnswer != null)
                  Text("Match's Answer: $_matchAnswer"),
              ],
            ),
          ),
        Expanded(
          child: Chat(
            messages: _messages,
            user: _user,
            onSendPressed: _handleSendPressed,
            onMessageTap: _handleMessageTap,
            onAttachmentPressed: _handleAttachmentPressed,
            onPreviewDataFetched: _handlePreviewDataFetched,
          ),
        ),
      ],
    ),
  );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _sendDailyPrompt();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Daily Prompt'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _openDateFilterDialog();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Generate Date Idea'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
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

  void _generateAndSendDateIdea(String budgetLevel) {
    final filtered = dateIdeas.entries.where((entry) {
      final desc = entry.value.toLowerCase();
      if (budgetLevel == 'low') return desc.contains('\$0') || desc.contains('\$1') || desc.contains('\$5') || desc.contains('\$10');
      if (budgetLevel == 'medium') return desc.contains('\$20') || desc.contains('\$25') || desc.contains('\$30') || desc.contains('\$35');
      return desc.contains('\$45') || desc.contains('\$60') || desc.contains('\$75');
    }).toList();

    if (filtered.isEmpty) return;

    final selected = filtered[Random().nextInt(filtered.length)];

    final dateMsg = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: "Date Idea: ${selected.key}\n${selected.value}",
    );

    _addMessage(dateMsg);
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

    await FirebaseFirestore.instance.collection('daily_prompts').doc(promptId).set({
      'prompt': _currentPrompt,
      'timestamp': now,
      'users': [widget.user.uid, widget.match.uid],
    });

    final promptMessage = types.TextMessage(
      author: _user,
      createdAt: now,
      id: randomString(),
      text: "Daily Prompt: $_currentPrompt",
    );

    _addMessage(promptMessage);

    // update user's Firestore record
    final userRef = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    await userRef.update({'lastDailyPromptTime': now});

    setState(() {
      widget.user.lastDailyPromptTime = now;
    });
  }

  Future<void> _submitDailyPromptAnswer(String answer, String promptId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final promptRef = FirebaseFirestore.instance.collection('daily_prompts').doc(promptId);
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
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

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
          final index =
          _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
          (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

}