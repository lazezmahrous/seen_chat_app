import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seen/services/firebase_storage_service.dart';
import 'package:seen/services/local_storage.dart';
import 'package:seen/services/push_notifcation_service.dart';
import 'package:seen/services/translate_services.dart';
import 'package:seen/constanc.dart';
import 'package:seen/global cubits/screen_actions_cubit/screen_actions_cubit.dart';
import 'package:seen/models/message_model.dart';
import 'package:seen/screens/gallery_page.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../../../generated/l10n.dart';
import '../cubits/replay_messages_cubit/replay_messages_cubit.dart';
import '../cubits/send_message_cubit/send_message_cubit.dart';

class TextFieldTools extends StatefulWidget {
  TextFieldTools({
    super.key,
    required this.userInChatUID,
    required this.anotherUserFcToken,
  });

  String? userInChatUID;
  String? anotherUserFcToken;

  @override
  State<TextFieldTools> createState() => _TextFieldToolsState();
}

class _TextFieldToolsState extends State<TextFieldTools> {
  final TextEditingController _messageController = TextEditingController();
  bool? _isRecording = false;
  bool? _isReplay = false;
  Message? replayedMessage;
  bool? isOrignalMessage = true;
  late Map<String, dynamic>? cachedUserData;

  Future<void> setTyping({required String data}) async {
    QuerySnapshot<Map<String, dynamic>> chatCollection =
        await Constanc.getChatWherUserIn(secondUserUid: widget.userInChatUID!);

    if (chatCollection.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in chatCollection.docs) {
        List<dynamic> typingUsers = doc['typing'] ?? [];

        if (data.isNotEmpty && _messageController.value.text.isNotEmpty) {
          if (!typingUsers.contains(FirebaseAuth.instance.currentUser!.uid)) {
            typingUsers.add(FirebaseAuth.instance.currentUser!.uid);
          }
        } else {
          typingUsers.remove(FirebaseAuth.instance.currentUser!.uid);
        }
        await doc.reference.update({'typing': typingUsers});
      }
    }
  }

  Future<String> _checkPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      return 'done';
    } else {
      return 'failure';
    }
  }

  @override
  void initState() {
    _messageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    setTyping(data: 'data');
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return BlocListener<ScreenActionsCubit, ScreenActionsState>(
      listener: (context, state) {
        if (state is ScreenActionsOpenkeyboard) {
          focusNode.requestFocus();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Container(
              width: constraints.maxWidth - 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                color: Constanc.kColorGray,
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !_isRecording!,
                      child: IconButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GalleryPage(
                              isProfileImg: false,
                              isChatPage: true,
                              anotherUserid: widget.userInChatUID,
                            ),
                          ));
                        },
                        icon: const Icon(
                          Icons.image_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isRecording!,
                      child: IconButton(
                        icon: const Icon(
                          Icons.translate_outlined,
                          size: 20,
                        ),
                        onPressed: () async {
                          await Translate.toSekkymallawany(
                                  message: _messageController.text)
                              .then((messageAfterSekkyMallawany) {
                            _messageController.text =
                                messageAfterSekkyMallawany;
                            setState(() {
                              isOrignalMessage = false;
                            });
                          });
                        },
                      ),
                    ),
                    BlocListener<SendMessageCubit, SendMessageState>(
                      listener: (context, sendMessageState) async {
                        if (sendMessageState is SendMessageSuccess) {
                          setState(() {
                            _messageController.clear();
                          });
                          await setTyping(data: _messageController.text);
                        }
                      },
                      child: Visibility(
                        visible: !_isRecording!,
                        child: Expanded(
                          flex: 4,
                          child: BlocListener<ReplayMessagesCubit,
                              ReplayMessagesState>(
                            listener: (context, replayMessagesState) async {
                              if (replayMessagesState
                                  is GetReplayMessageSuccesss) {
                                setState(() {
                                  replayedMessage = replayMessagesState.message;
                                  _isReplay = true;
                                });
                              } else {
                                setState(() {
                                  _isReplay = false;
                                });
                              }
                            },
                            child: TextFormField(
                              validator: (data) {
                                return null;
                              },
                              controller: _messageController,
                              onChanged: (data) async {
                                await setTyping(data: data);
                              },
                              focusNode: focusNode,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: _messageController.text.length > 60
                                  ? 4
                                  : null,
                              autofocus: true,
                              maxLength: 800,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: S.of(context).writeMessage,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _messageController.text.isEmpty
                        ? Expanded(
                            child: SocialMediaRecorder(
                              recordIcon: const Icon(Icons.mic),
                              backGroundColor: null,
                              maxRecordTimeInSecond: 60,
                              startRecording: () async {
                                await _checkPermissions().then((value) {
                                  if (value == "done") {
                                    setState(() {
                                      _isRecording = true;
                                    });
                                  }
                                });
                              },
                              stopRecording: (time) {
                                setState(() {
                                  _isRecording = false;
                                });
                              },
                              sendRequestFunction: (soundFile, time) async {
                                await FirebaseStorageMethods.uploadToFirebase(
                                        soundFile.path)
                                    .then((value) async {
                                  if (mounted) {
                                    await BlocProvider.of<SendMessageCubit>(
                                            context)
                                        .sendMessage(
                                      context: context,
                                      secondUserUid: widget.userInChatUID!,
                                      messageContent: value,
                                      isOrignalMessage: true,
                                      isVoiceMessage: true,
                                    );
                                    setState(() {
                                      _isRecording = false;
                                    });
                                  }
                                });
                              },
                              encode: AudioEncoderType.AAC,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              await BlocProvider.of<SendMessageCubit>(context)
                                  .sendMessage(
                                context: context,
                                isReplayMessage: _isReplay!,
                                replay: replayedMessage ?? replayedMessage,
                                secondUserUid: widget.userInChatUID!,
                                messageContent: _messageController.text,
                                isOrignalMessage: isOrignalMessage!,
                                isVoiceMessage: false,
                              );

                              setState(() {
                                isOrignalMessage = true;
                              });
                            },
                            icon: const Icon(Icons.send),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
