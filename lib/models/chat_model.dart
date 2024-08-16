import 'package:seen/models/message_model.dart';

class Chat {
  String? id;
  bool? block = false;
  List<String>? participants;
  List<String>? preventAndroidScreenShot;
  List<String>? typing;
  DateTime? lastMessageTime; // إضافة المتغير

  Chat({
    required this.id,
    required this.block,
    required this.participants,
    required this.preventAndroidScreenShot,
    required this.typing,
    required this.lastMessageTime, // تضمين المتغير في الباني
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    block = json['block'];
    participants = List<String>.from(json['participants']);
    preventAndroidScreenShot = List<String>.from(json['preventAndroidScreenShot']);
    typing = List<String>.from(json['typing']);
    lastMessageTime = json['lastMessageTime'] != null
        ? DateTime.parse(json['lastMessageTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['block'] = block;
    data['participants'] = participants;
    data['preventAndroidScreenShot'] = preventAndroidScreenShot;
    data['typing'] = typing;
    data['lastMessageTime'] = lastMessageTime?.toIso8601String(); // تضمين المتغير في toJson
    return data;
  }
}
