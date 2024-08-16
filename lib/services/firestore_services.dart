import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seen/models/user_model.dart' as model;

class FireStoreService {
  static final FirebaseFirestore _ref = FirebaseFirestore.instance;

  static Future<model.User> getUserDataWithUid(
      {required String anotherUserUid}) async {
    final userDoc = await _ref.collection('users').doc(anotherUserUid).get();

    return model.User.fromSnap(userDoc);
  }

 
 static Future<void> setOnLineAndNewSeen() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _ref
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "onLine": true,
        "newSeen": DateTime.now().toString(),
      });
    }
  }

 static Future<void> setOfLineAndLastSeen() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _ref
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "onLine": false,
        "lastSeen": DateTime.now().toString(),
      });
    }
  }
}
