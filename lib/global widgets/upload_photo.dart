import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';
import 'package:uuid/uuid.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});
  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  String? profImage;
  Future<void> _pickImage({required bool isOneImage}) async {
    final selectedSource = await showAlertDialog(
      context: context,
      title: 'إختار مصدر الصورة',
      body: 'عايز تحمل الصوره منين ؟',
      actionsTextButtonOne: 'المعرض',
      actionsTextButtonTow: 'الكاميرا',
      icon: const Icon(Icons.info),
    );

    if (selectedSource != null) {
      final pickedFile = await ImagePicker().pickImage(source: selectedSource);

      if (pickedFile != null) {
        final compressedBytes =
            await testCompressFile(file: File(pickedFile.path));
        if (compressedBytes != null) {
          final compressedFile = File(pickedFile.path); // Define a path
          await uploadImageToFirebaseStorage(
                  imageFile: compressedFile, category: 'profileImages')
              .then(
            (value) {
              setState(() {
                profImage = value;
              });
              print(value);
            },
          );
        }
      }
    }
    return;
  }

  Future<File?> testCompressFile({required File file}) async {
    try {
      var result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 100,
        minHeight: 100,
        quality: 94,
        rotate: 90,
      );
      // حفظ البيانات المضغوطة في ملف جديد
      File compressedFile = File('${file.path}.compressed');
      await compressedFile.writeAsBytes(result!);

      // await uploadImageToFirebaseStorage(imageFile: compressedFile , category: '');
      return compressedFile;
    } catch (error) {
      print('Error compressing image: $error');
      return null; // Return null on error
    }
  }

  Future<String?> uploadImageToFirebaseStorage(
      {required File imageFile, required String category}) async {
    try {
      var uuid = const Uuid();

      // إنشاء معرف UUID فريد
      String uniqueId = uuid.v4();
      Reference storageRef =
          FirebaseStorage.instance.ref().child(category).child(uniqueId);

      // رفع الصورة إلى Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // انتظار اكتمال عملية الرفع
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // الحصول على عنوان URL للصورة المحملة
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null; // Return null on error
    }
  }

  Future<ImageSource?> showAlertDialog({
    required BuildContext context,
    required String title,
    required String body,
    required String actionsTextButtonOne,
    required String actionsTextButtonTow,
    required Icon icon,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text(actionsTextButtonOne),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text(actionsTextButtonTow),
          ),
        ],
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return profImage!.isEmpty
        ? SizedBox(
            width: 120,
            height: 120,
            child: InkWell(
              onTap: () async {
                await _pickImage(
                  isOneImage: false,
                );
              },
              child: const Icon(Icons.add_a_photo_rounded),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: SizedBox(
              child: OctoImage.fromSet(
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  profImage!,
                ),
                octoSet: OctoSet.circleAvatar(
                  backgroundColor: Colors.grey,
                  text: const Text(""),
                ),
                placeholderFadeInDuration: const Duration(seconds: 1),
              ),
            ),
          );
  }
}
