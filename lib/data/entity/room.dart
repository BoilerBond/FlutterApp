import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class Room {
  String roomID;
  List<String> users;
  List<Map<String, dynamic>> messages;

  Room({
    required this.roomID,
    required this.users,
    this.messages = const []
  });

  factory Room.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    return Room(
      roomID: snapshot.id,
      users: List<String>.from(data['users'] ?? []),
      messages: List<Map<String, dynamic>>.from(data['messages'] ?? [])
    );
  }

  static Future<Room> getById(String id) async {
    final snapshot = await FirebaseFirestore.instance.collection("rooms").doc(id).get();
    return Room.fromSnapshot(snapshot);
  }

  static Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection("rooms").doc(id).delete();
  }

  Future<void> save({String id = "", bool merge = false}) async {
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(id)
        .set(toMap(), SetOptions(merge: merge));
  }

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'users': users,
      'messages': messages,
    };
  }

  Map<String, dynamic> convertToMap(types.Message msg) {
    Map<String, dynamic> newmsg = {};
    switch (msg.type) {
      case types.MessageType.audio:
        types.AudioMessage vmsg = types.AudioMessage.fromJson(msg.toJson());
        newmsg = {
          'type': "audio",
          'author': msg.author.id,
          'createdAt': msg.createdAt,
          'id': msg.id,
          'duration': vmsg.duration.inMilliseconds.toString(),
          'name': vmsg.name,
          'size': vmsg.size,
          'uri': vmsg.uri
        };
        break;
      case types.MessageType.image:
        types.ImageMessage imsg = types.ImageMessage.fromJson(msg.toJson());
        newmsg = {
          'type': "image",
          'author': msg.author.id,
          'createdAt': msg.createdAt,
          'height': imsg.height,
          'width': imsg.width,
          'size': imsg.size,
          'name': imsg.name,
          'id': msg.id,
          'uri': imsg.uri,
        };
        break;
      case types.MessageType.file:
        types.FileMessage fmsg = types.FileMessage.fromJson(msg.toJson());
        newmsg = {
          'type': "file",
          'author': msg.author.id,
          'createdAt': msg.createdAt,
          'size': fmsg.size,
          'name': fmsg.name,
          'id': msg.id,
          'uri': fmsg.uri,
        };
        break;
      case types.MessageType.custom:
        final cust = msg as types.CustomMessage;
        final meta = cust.metadata != null
            ? Map<String, dynamic>.from(cust.metadata!)
            : <String, dynamic>{};
        newmsg = {
          'type': meta['customType'] ?? 'custom',
          'author': cust.author.id,
          'createdAt': cust.createdAt,
          'id': cust.id,
        };
        newmsg.addAll(meta);
        break;
      default:
        newmsg = {
          'type': "text",
          'author': msg.author.id,
          'createdAt': msg.createdAt,
          'id': msg.id,
          'text': (msg as types.TextMessage).text,
        };
        break;
    }
    return newmsg;
  }

  void sendMessage(types.Message msg) async {
    messages.insert(0, convertToMap(msg));
    // save to firebase
    await FirebaseFirestore.instance.collection("rooms").doc(roomID).update({"messages": messages});
  }

  void deleteMessage(types.Message msg) async {
    messages.removeWhere((e) => e['id'] == msg.id);
    await FirebaseFirestore.instance.collection("rooms").doc(roomID).update({"messages": messages});
  }

  Future<void> sendDateIdea(Map<String, dynamic> idea, types.User author) async {
    final msg = types.CustomMessage(
      id: const Uuid().v4(),
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      metadata: {
        'customType': 'dateIdea',
        'status': 'pending',
        'acceptedBy': <String>[],
        'deniedBy': <String>[],
        'dateIdea': idea,
      },
    );
    sendMessage(msg);
  }

  Future<void> sendDailyPrompt(String promptText, types.User author) async {
    final msg = types.CustomMessage(
      id: const Uuid().v4(),
      author: author,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      metadata: {
        'customType': 'dailyPrompt',
        'prompt': promptText,
      },
    );
    sendMessage(msg);
  }

  Future<void> updateMessage(String messageId, Map<String, dynamic> updates) async {
    final idx = messages.indexWhere((m) => m['id'] == messageId);
    if (idx == -1) return;
    messages[idx].addAll(updates);
    await FirebaseFirestore.instance
        .collection("rooms")
        .doc(roomID)
        .update({'messages': messages});
  }
}