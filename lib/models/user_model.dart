import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String phoneNumber;
  final String fcToken;
  final String password;
  final String profImg;
  final String newSeen;
  final String lastSeen;
  final List followers;
  final bool onLine;

  User({
    required this.username,
    required this.uid,
    required this.phoneNumber,
    required this.fcToken,
    required this.password,
    required this.profImg,
    required this.newSeen,
    required this.lastSeen,
    required this.followers,
    required this.onLine,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      password: snapshot['password'],
      profImg: snapshot['profImg'],
      lastSeen: snapshot['lastSeen'], // تعديل هنا
      newSeen: snapshot['newSeen'], // تعديل هنا
      followers: snapshot["followers"],
      uid: snapshot["uid"],
      phoneNumber: snapshot["phoneNumber"],
      fcToken: snapshot["fcToken"],
      onLine: snapshot["onLine"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "followers": followers,
        "profImg": profImg,
        "newSeen": newSeen,
        "lastSeen": lastSeen,
        "uid": uid,
        "phoneNumber": phoneNumber,
        "fcToken": fcToken,
        "onLine": onLine,
      };
}
