import 'package:seen/models/message_model.dart';

class Stories {
  String? id;
  List<String>? followers;
  List<Message>? stories;
  // List<String>? preventAndroidScreenShot;
  // List<String>? typing;
  Stories({
    required this.id,
    required this.followers,
    required this.stories,
    // required this.preventAndroidScreenShot,
    // required this.typing,
  });

  Stories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    followers = List<String>.from(json['followers']);
    stories =
        List.from(json['stories']).map((m) => Message.fromJson(m)).toList();
    // preventAndroidScreenShot = List<String>.from(json['preventAndroidScreenShot']);
    // typing = List<String>.from(json['typing']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['followers'] = followers;
    data['messages'] = stories?.map((m) => m.toJson()).toList() ?? [];
    // data['preventAndroidScreenShot'] = preventAndroidScreenShot;
    // data['typing'] = typing;
    return data;
  }
}
