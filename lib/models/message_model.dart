import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  Text,
  Image,
  Video,
  Voice,
  ScreenShot,
  // Add other types as needed
}

class Message {
  String? senderID;
  String? content;
  Timestamp? sentAt;
  bool isRead;
  bool isOrignal;
  bool unSend;
  int? index;
  String? messageId;
  String? chatId;
  List<Message>? rplay;
  MessageType? messageType;

  Message({
    this.senderID,
    this.content,
    this.sentAt,
    this.isRead = false,
    this.isOrignal = false,
    this.unSend = false,
    this.index,
    this.messageId,
    this.chatId,
    this.rplay,
    this.messageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderID: json['senderID'] as String?,
      content: json['content'] as String?,
      sentAt: json['sentAt'],
      isRead: json['isRead'] ?? false,
      isOrignal: json['isOrignal'] ?? false,
      unSend: json['unsend'] ?? false,
      index: json['index'] as int?,
      messageId: json['messageId'] as String?,
      chatId: json['chatId'] as String?,
      rplay: (json['rplay'] as List<dynamic>?)
          ?.map((item) => item != null && item is Map<String, dynamic>
              ? Message.fromJson(item)
              : null)
          .where((item) => item != null)
          .toList()
          .cast<Message>(),
      messageType: json['messageType'] != null
          ? MessageType.values.firstWhere(
              (e) => e.toString() == 'MessageType.${json['messageType']}',
              orElse: () => MessageType.Text,
            )
          : MessageType.Text,
    );
  }

  factory Message.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Message.fromJson(data ?? {});
  }

  Map<String, dynamic> toJson() {
    return {
      'senderID': senderID,
      'content': content,
      'sentAt': sentAt,
      'isRead': isRead,
      'isOrignal': isOrignal,
      'unsend': unSend,
      'index': index,
      'messageId': messageId,
      'chatId': chatId,
      'rplay': rplay?.map((item) => item.toJson()).toList(),
      'messageType': messageType?.toString().split('.').last,
    };
  }
}
