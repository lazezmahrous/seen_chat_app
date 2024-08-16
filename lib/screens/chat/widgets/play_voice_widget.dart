import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seen/services/translate_services.dart';
import 'package:seen/constanc.dart';
import 'package:seen/models/message_model.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../generated/l10n.dart';
import 'he_and_you.dart';
import 'time_and_seen_plus_sent.dart';

class PlayVoiceWidget extends StatefulWidget {
  const PlayVoiceWidget({super.key, required this.message});

  final Message message;
  @override
  State<PlayVoiceWidget> createState() => _PlayVoiceWidgetState();
}

class _PlayVoiceWidgetState extends State<PlayVoiceWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment:
          widget.message.senderID == FirebaseAuth.instance.currentUser!.uid
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
      children: [
        HeAndYou(
          senderID: widget.message.senderID!,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            maxWidth: width / 1.6,
          ),
          child: Column(
            children: [
              widget.message.rplay != null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Constanc.kColorGray,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: widget.message.content!.length < 24 ||
                                widget.message.messageType == MessageType.Voice
                            ? width / 2
                            : width / 1.5,
                      ),
                      margin:
                          const EdgeInsetsDirectional.only(top: 10, bottom: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text(
                          widget.message.rplay!.first.content!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              InkWell(
                onDoubleTap: () {
                  // Translate.transcribeAudio(widget.message.content!)
                  //     .then((onValue) {
                  //   print(onValue);
                  // });
                },
                child: VoiceMessageView(
                  activeSliderColor: widget.message.senderID !=
                          FirebaseAuth.instance.currentUser!.uid
                      ? Constanc.kSecondColor
                      : Constanc.kOrignalColor,
                  circlesColor: widget.message.senderID !=
                          FirebaseAuth.instance.currentUser!.uid
                      ? Constanc.kSecondColor
                      : Constanc.kOrignalColor,
                  size: 30,
                  controller: VoiceController(
                    maxDuration: const Duration(seconds: 1),
                    isFile: false,
                    audioSrc: widget.message.content!,
                    onComplete: () {
                      /// do something on complete
                    },
                    onPause: () {
                      /// do something on pause
                    },
                    onPlaying: () {
                      /// do something on playing
                    },
                    onError: (err) {
                      /// do somethin on error
                    },
                  ),
                  innerPadding: 12,
                  cornerRadius: 20,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimeAndSeenPlusSent(
                      message: widget.message,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
