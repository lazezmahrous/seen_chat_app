import 'package:cloud_firestore/cloud_firestore.dart';

enum StorieType { Text, Image }

class Storie {
  String? senderID;
  String? content;
  StorieType? messageType;
  Timestamp? sentAt;
  int? index;
  String? chatId;
  String? rplayed;

  List<String> viewers = [];

  Storie({
    required this.senderID,
    required this.content,
    required this.messageType,
    required this.sentAt,
    required this.viewers,
    this.index,
    this.chatId,
    this.rplayed,
  });

  Storie.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    content = json['content'];
    sentAt = json['sentAt'];
    viewers = json['viewers'];
    index = json['index'];
    chatId = json['chatId'];
    rplayed = json['rplayed'];
    messageType = StorieType.values.byName(json['messageType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderID'] = senderID;
    data['content'] = content;
    data['sentAt'] = sentAt;
    data['viewers'] = viewers;
    data['messageType'] = messageType!.name;
    data['index'] = index;
    data['chatId'] = chatId;
    data['rplayed'] = rplayed;
    return data;
  }
}
