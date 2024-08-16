import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageMethods {
  static final storageRef = FirebaseStorage.instance;

  static Future<String> uploadToFirebase(String filePath) async {
    File file = File(filePath);
    String name = const Uuid().v4();

    String fileName = '${filePath + name}.aac';
    Reference voiceRef = storageRef.ref().child('voice_messages/$fileName');
    UploadTask uploadTask = voiceRef.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
