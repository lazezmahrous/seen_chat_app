import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seen/constanc.dart';
import 'package:seen/screens/user%20profile/cubit/user_profile_cubit.dart';

import '../Services/firebase_storage_service.dart';
import 'chat/cubits/send_message_cubit/send_message_cubit.dart';
import 'signup/cubits/get_image_cubit/get_image_cubit.dart';

class GalleryPage extends StatefulWidget {
  GalleryPage(
      {super.key, this.isProfileImg, this.isChatPage, this.anotherUserid});

  static String id = 'galleryPage';
  bool? isProfileImg = false;
  bool? isChatPage = false;
  String? anotherUserid = '';
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> images = [];
  List<Uint8List> selectedImages = [];
  AssetPathEntity? selectedAlbum;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      loadAlbums();
    } else {
      requestPermission();
    }
  }

  Future<void> loadAlbums() async {
    albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    if (albums.isNotEmpty) {
      loadImages(albums[0]);
    }
    setState(() {});
  }

  Future<void> loadImages(AssetPathEntity album) async {
    List<AssetEntity> imageList =
        await album.getAssetListPaged(page: 0, size: 100);
    setState(() {
      images = imageList;
      selectedAlbum = album;
    });
  }

  Future<dynamic> _cropImage(Uint8List imageBytes, BuildContext ctx) async {
    final imageCropped = await ImageCropper().cropImage(
      sourcePath: await _saveImageToFile(imageBytes),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Constanc.kOrignalColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 520,
          ),
        ),
      ],
    ).then((value) async {
      if (value != null) {
        if (widget.isProfileImg!) {
          print('profile image');
          BlocProvider.of<UserProfileCubit>(context)
              .changeProfileImage(newProfileImage: value.path);
        } else if (widget.isChatPage!) {
          print("hello wrole ");
          await sendMessage(croppedFile: value.path).then((v) {
            Navigator.pop(context);
          });
        }
        Navigator.pop(context);
      }
    });

    return imageCropped!.path;
  }

  Future sendMessage({required String croppedFile}) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseStorageMethods.uploadToFirebase(croppedFile)
          .then((value) async {
        await BlocProvider.of<SendMessageCubit>(context).sendMessage(
          context: context,
          replay: null,
          secondUserUid: widget.anotherUserid!,
          messageContent: value,
          isOrignalMessage: true,
          isVoiceMessage: false,
          isImageMessage: true,
        );
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('error =============== $e');
    }
  }

  Future<String> _saveImageToFile(Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final file =
        await File('${tempDir.path}/temp_image.jpg').writeAsBytes(imageBytes);
    return file.path;
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const SpinKitPulse(
        color: Colors.indigoAccent,
        size: 100.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gallery"),
        ),
        body: Column(
          children: [
            if (albums.isNotEmpty)
              DropdownButton<AssetPathEntity>(
                value: selectedAlbum,
                items: albums.map((album) {
                  return DropdownMenuItem<AssetPathEntity>(
                    value: album,
                    child: Text(album.name),
                  );
                }).toList(),
                onChanged: (album) {
                  if (album != null) {
                    loadImages(album);
                  }
                },
              ),
            Expanded(
              child: images.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return FutureBuilder<Uint8List?>(
                                future: images[index].originBytes,
                                builder: (context, snapshot) {
                                  final bytes = snapshot.data;
                                  if (bytes == null) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  bool isSelected =
                                      selectedImages.contains(images[index]);
                                  return GestureDetector(
                                    onTap: () async {
                                      await _cropImage(bytes, context);
                                    },
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.memory(
                                            bytes,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (isSelected)
                                          const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: images.length,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
